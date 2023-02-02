part of 'weather_provider.dart';

enum WeatherStatus { initial, loading, loaded, error }

class WeatherState extends Equatable {
  final WeatherStatus status;
  final Weather? weather;
  final CustomError error;

  const WeatherState({
    this.status = WeatherStatus.initial,
    final CustomError? error,
    this.weather,
  }) : error = error ?? const CustomError();

  WeatherState copyWith(
      {WeatherStatus? status, Weather? weather, CustomError? error}) {
    return WeatherState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, weather, error];

  @override
  bool get stringify {
    return true;
  }
}
