import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../models/custom_error.dart';
import '../repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherProvider with ChangeNotifier {
  WeatherState _state = WeatherState.initial();
  final WeatherRepository repository;

  WeatherState get state => _state;

  WeatherProvider({required this.repository});

  Future<void> fetchWeather(String city) async {
    _state = _state.copyWith(status: WeatherStatus.loading);
    notifyListeners();
    try {
      final Weather weather = await repository.fetchWeather(city);
      _state = _state.copyWith(weather: weather, status: WeatherStatus.loaded);
      //todo print(state) to check if it works properly;
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(status: WeatherStatus.error, error: e);
      //todo print(state) to check if it works properly;
      notifyListeners();
    }
  }
}