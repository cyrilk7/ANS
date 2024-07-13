import 'package:ashesi_navigation_app/models/event_model.dart';
import 'package:ashesi_navigation_app/pages/search_location.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Event event;
  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 241, 241, 241)),
            child: Column(
              children: [
                Text(
                  event.startTime,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  event.endTime,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 145, 143, 143)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Container(
              decoration: const BoxDecoration(),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        // mainAxisAlignment: Mai,
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Color.fromARGB(255, 170, 59, 62),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            event.building.name,
                            style: const TextStyle(
                                // color: Color.fromARGB(255, 191, 191, 191),
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchLocation(
                            chosenDestination: event.building.location,
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.gps_fixed,
                      color: Color.fromARGB(255, 170, 59, 62),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
