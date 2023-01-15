import 'package:weather1/exceptions/weather_exception.dart';
import 'package:weather1/models/custom_error.dart';

import '../services/weather_api_services.dart';
import '../models/weather.dart';
import '../models/direct_geocoding.dart';

class WeatherRepository {
  WeatherApiServices weatherApiServices;

  WeatherRepository({required this.weatherApiServices});

  Future<Weather> fetchWeather(String city) async {
    try {
      final DirectGeocoding directGeocoding =
          await weatherApiServices.getDirectGeocoding(city);
      final Weather tempWeather =
          await weatherApiServices.getWeather(directGeocoding);
      final Weather weather = tempWeather.copyWith(
        name: directGeocoding.name,
        country: directGeocoding.country,
      );
      return weather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
