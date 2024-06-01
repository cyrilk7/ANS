import 'package:ashesi_navigation_app/models/location_model.dart';
import 'package:ashesi_navigation_app/models/room_model.dart';
import 'package:ashesi_navigation_app/pages/building_information.dart';
import 'package:flutter/material.dart';

class Building extends StatelessWidget {
  final String category;
  final String description;
  final String name;
  final String history;
  final Location location;
  final List<Room> rooms;

  Building({
    required this.category,
    required this.description,
    required this.name,
    required this.history,
    required this.location,
    required this.rooms,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    List<dynamic> roomsJson = json['rooms'];
    Location location = Location(
        name: json['name'],
        latitude: json['latitude'],
        longitude: json['longitude']);
    List<Room> rooms =
        roomsJson.map((roomJson) => Room.fromJson(roomJson)).toList();

    return Building(
      category: json['category'],
      description: json['description'],
      name: json['name'],
      history: json['history'],
      location: location,
      rooms: rooms,
    );
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
                    child: Image.asset(
                      "assets/images/building_template.jpeg",
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
                              child: Image.asset(
                                  "assets/images/academic_category.png",
                                  fit: BoxFit.cover),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              category.toUpperCase(),
                              style: const TextStyle(
                                color: Color.fromARGB(255, 114, 114, 119),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
                          maxLines: 3,
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
