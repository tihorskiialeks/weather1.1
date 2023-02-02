class WeatherException implements Exception {
  late final String message;

  WeatherException({final String message = 'Something went wrong'}) {
    this.message = 'Weather exception: $message';
  }

  @override
  String toString() => message;
}
