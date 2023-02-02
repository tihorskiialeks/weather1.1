import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/direct_geocoding.dart';
import '../exceptions/weather_exception.dart';
import '../models/weather.dart';

String _httpErrorHandler(http.Response response) {
  final statusCode = response.statusCode;
  final reasonPhrase = response.reasonPhrase;

  final String errorMessage =
      'Request failed\nStatus code: $statusCode\nReason: $reasonPhrase';
  return errorMessage;
}

class WeatherApiServices {
  final http.Client httpClient;

  WeatherApiServices({required this.httpClient});

  Future<CityCoordinates> getCityCoordinates(String city) async {
    final http.Response response = await httpClient.get(
      Uri(
          scheme: 'https',
          host: kApiHost,
          path: '/geo/1.0/direct',
          queryParameters: {
            'q': city,
            'limit': kLimit,
            'appid': dotenv.env['APPID']
          }),
    );
    if (response.statusCode != 200) {
      throw Exception(_httpErrorHandler(response));
    }
    final List<Map<String, Object?>> responseBody =
        json.decode(response.body) as List<Map<String, Object?>>;

    if (responseBody.isEmpty) {
      throw WeatherException(message: 'Cannot get location of the $city');
    }
    return CityCoordinates.fromJson(responseBody.first);
  }

  Future<Weather> getWeather(CityCoordinates cityCoordinates) async {
    final http.Response response = await httpClient.get(
      Uri(
          scheme: 'https',
          path: '/data/2.5/weather',
          host: kApiHost,
          queryParameters: {
            'lat': '${cityCoordinates.lat}',
            'lon': '${cityCoordinates.lon}',
            'units': kUnit,
            'appid': dotenv.env['APPID'],
          }),
    );
    if (response.statusCode != 200) {
      throw Exception(_httpErrorHandler(response));
    }
    final resposeBody = json.decode(response.body) as Map<String, Object?>;
    return Weather.fromJson(resposeBody)
        .copyWith(name: cityCoordinates.name, country: cityCoordinates.country);
  }
}
