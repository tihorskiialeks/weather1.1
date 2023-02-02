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
      final CityCoordinates cityCoordinates =
          await weatherApiServices.getCityCoordinates(city);

      return await weatherApiServices.getWeather(cityCoordinates);
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
