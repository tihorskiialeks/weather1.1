import 'package:equatable/equatable.dart';

class CityCoordinates extends Equatable {
  final String name;
  final double lat;
  final double lon;
  final String country;

  const CityCoordinates({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  factory CityCoordinates.fromJson(final Map<String, Object?> data) {
    return CityCoordinates(
      name: data['name']! as String,
      lat: data['lat']! as double,
      lon: data['lon']! as double,
      country: data['country']! as String,
    );
  }

  @override
  List<Object?> get props => [name, lat, lon, country];

  @override
  bool get stringify {
    return true;
  }
}
