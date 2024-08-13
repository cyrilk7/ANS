// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:ashesi_navigation_app/models/location_model.dart';
import 'package:ashesi_navigation_app/models/room_model.dart';
import 'package:ashesi_navigation_app/pages/building_information.dart';

class Building extends StatelessWidget {
  final String category;
  final String description;
  final String name;
  final String history;
  final String imagePath;
  final Location location;
  final String mapId;
  final List<Room> rooms;
  final String categoryIconPath;

  const Building(
      {super.key,
      required this.category,
      required this.description,
      required this.name,
      required this.history,
      required this.location,
      required this.mapId,
      required this.rooms,
      required this.imagePath,
      required this.categoryIconPath});

  factory Building.fromJson(Map<String, dynamic> json) {
    Location location = Location(
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      mapId: json['map_id'] ?? '',
    );

    List<Room> rooms = [];
    if (json.containsKey('rooms') && json['rooms'] != null) {
      // print("so");
      List<dynamic> roomsJson = json['rooms'];
      rooms = roomsJson.map((roomJson) => Room.fromJson(roomJson)).toList();
    }

    return Building(
      category: json['category'],
      description: json['description'],
      name: json['name'],
      imagePath: json['image_path'],
      history: json['history'] ?? '',
      categoryIconPath: json['categoryImage'] ?? '',
      mapId: json['map_id'] ?? '',
      location: location,
      rooms: rooms,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'description': description,
      'history': history,
      'location': location.toJson(),
      'image_path': imagePath,
      'map_id': mapId,
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BuildingInformationPage(building: this),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: double.infinity,
          height: 140,
          child: Card(
            elevation: 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: 115,
                      height: double.infinity,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset(categoryIconPath,
                                  fit: BoxFit.cover),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            SizedBox(
                              width: 160,
                              child: Text(
                                category.toUpperCase(),
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 114, 114, 119),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 170, 60, 63),
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          description,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 114, 114, 119),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
