import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather1/constants/constants.dart';
import 'package:weather1/models/weather.dart';
import 'provider.dart';

part 'theme_state.dart';

class ThemeProvider with ChangeNotifier {
  ThemeState _state = ThemeState.initial();

  ThemeState get state => _state;

  void update(WeatherProvider wp) {
    final Weather? weather = wp.state.weather;
    if (weather != null && weather.temp > kWarmOrNot) {
      _state = _state.copyWith(appTheme: AppTheme.light);
    } else {
      _state = _state.copyWith(appTheme: AppTheme.dark);
    }
    notifyListeners();
  }
}
