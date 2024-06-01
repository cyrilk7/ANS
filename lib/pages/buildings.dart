import 'package:ashesi_navigation_app/controllers/building_controller.dart';
import 'package:ashesi_navigation_app/models/building_model.dart';
import 'package:flutter/material.dart';

class Buildings extends StatefulWidget {
  const Buildings({super.key});

  @override
  State<Buildings> createState() => _BuildingsState();
}

class _BuildingsState extends State<Buildings> {
  final BuildingController controller = BuildingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Building>>(
        future: controller.fetchBuildings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator while fetching data
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Building> buildings = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: buildings.length,
                itemBuilder: (context, index) {
                  return buildings[index];
                },
              ),
            );
          }
        },
      ),
    );
  }
}


