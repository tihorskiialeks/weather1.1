import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'http_error_handler.dart';
import '../constants/constants.dart';
import '../models/direct_geocoding.dart';
import '../exceptions/weather_exception.dart';
import '../models/weather.dart';

class WeatherApiServices {
  final http.Client httpClient;

  WeatherApiServices({required this.httpClient});

  Future<CityCoordinates> getCityCoordinates(String city) async {
    Uri uri = Uri(
        scheme: 'https',
        host: kApiHost,
        path: '/geo/1.0/direct',
        queryParameters: {
          'q': city,
          'limit': kLimit,
          'appid': dotenv.env['APPID']
        });
    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }
      final responseBody = json.decode(response.body);

      if (responseBody.isEmpty) {
        throw WeatherException(message: 'Cannot get location of the $city');
      }
      final directGeocoding = CityCoordinates.fromJson(responseBody);
      return directGeocoding;
    } catch (e) {
      rethrow;
    }
  }

  Future<Weather> getWeather(CityCoordinates directGeocoding) async {
    final Uri uri = Uri(
      scheme: 'https',
        path: '/data/2.5/weather',
        host: kApiHost,
        queryParameters: {
      'lat': '${directGeocoding.lat}',
      'lon': '${directGeocoding.lon}',
      'units': kUnit,
      'appid': dotenv.env['APPID'],
    });
    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }
      final weatherJson = json.decode(response.body);
      final Weather weather = Weather.fromJson(weatherJson);
      return weather;
    } catch (e) {
      rethrow;
    }
  }
}
