import 'package:equatable/equatable.dart';

class CityCoordinates extends Equatable {
  final String name;
  final double lat;
  final double lon;
  final String country;

  CityCoordinates({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  factory CityCoordinates.fromJson(List<dynamic> json) {
    final Map<String, dynamic> data = json[0];
    return CityCoordinates(
      name: data['name'],
      lat: data['lat'],
      lon: data['lon'],
      country: data['country'],
    );
  }

  @override
  List<Object?> get props => [name, lat, lon, country];

  @override
  bool get stringify {
    return true;
  }
}
