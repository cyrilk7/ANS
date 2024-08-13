import 'package:ashesi_navigation_app/models/room_model.dart';

class Location {
  final String name;
  final double latitude;
  final double longitude;
  final Room? room;
  final String? mapId;

  Location(
      {required this.name,
      required this.latitude,
      required this.longitude,
      this.mapId,
      this.room});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
