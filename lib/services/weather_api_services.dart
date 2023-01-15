import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'http_error_handler.dart';
import '../constants/constants.dart';
import '../models/direct_geocoding.dart';
import '../exceptions/weather_exception.dart';

class WeatherApiServices {
  final http.Client httpClient;

  WeatherApiServices({required this.httpClient});

  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    Uri uri = Uri(
        scheme: 'https',
        host: kApiHost,
        path: 'geo/1.0/direct',
        queryParameters: {
          'q': city,
          'limit': kLimit,
          'appid': dotenv.env['APPID']
        }
    );
    try {
      final http.Response response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }
      final responseBody = json.decode(response.body);
      if (responseBody.isEmty) {
        throw WeatherException(
            message: 'Cannot get location of the $city';
        );
      }
      final directGeocoding = DirectGeocoding.fromJson(responseBody);
      return directGeocoding;
    } catch (e) {
      rethrow;
    }
  }
}
