// import 'dart:convert';

import 'package:ashesi_navigation_app/controllers/building_controller.dart';
import 'package:ashesi_navigation_app/models/building_model.dart';
import 'package:ashesi_navigation_app/models/location_model.dart';
import 'package:ashesi_navigation_app/models/room_model.dart';
import 'package:ashesi_navigation_app/providers/location_provider.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class SearchLocation extends StatefulWidget {
  final Location? chosenDestination;

  const SearchLocation({super.key, this.chosenDestination});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  Position? userPosition;
  BuildingController buildingController =
      BuildingController(); // Instantiate the controller
  List<Building> buildings =
      []; // List to hold buildings fetched from the controller
  List<Building> previousLocations = [];
  List<Building> filteredLocations = [];
  bool isLoading = true;
  bool isSelectingStart = true;
  bool isFocused = false;

  TextEditingController startLocationController = TextEditingController();
  TextEditingController endLocationController = TextEditingController();

  Location? startLocation;
  Location? endLocation;

  void fetchBuildings() async {
    List<Building> fetchedBuildings = await buildingController.fetchBuildings();
    setState(() {
      buildings = fetchedBuildings;
      isLoading = false;
    });
  }

  void getCurrentLocation() async {
    Position pos = await determinePosition();
    setState(() {
      userPosition = pos;

      if (userPosition != null) {
        startLocation = Location(
            name: 'Current location',
            latitude: userPosition!.latitude,
            longitude: userPosition!.longitude);
        startLocationController.text =
            'Current Location (${userPosition!.latitude}, ${userPosition!.longitude})';
      }
    });
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location Permissions are denied");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    fetchBuildings();
    // loadRecentSearches();
    if (widget.chosenDestination != null) {
      endLocation = widget.chosenDestination;
      endLocationController.text = widget.chosenDestination!.name;
      final locationProvider =
          Provider.of<LocationProvider>(context, listen: false);
      locationProvider.setEndLocation(endLocation!);
    }
    filteredLocations = previousLocations;
    startLocationController.addListener(onStartLocationChanged);
    endLocationController.addListener(onEndLocationChanged);
  }

  @override
  void dispose() {
    startLocationController.removeListener(onStartLocationChanged);
    endLocationController.removeListener(onEndLocationChanged);
    startLocationController.dispose();
    endLocationController.dispose();
    super.dispose();
  }

  void onStartLocationChanged() {
    String query = startLocationController.text.toLowerCase();
    setState(() {
      filteredLocations = query.isEmpty
          ? previousLocations
          : buildings
              .where((building) => building.name.toLowerCase().contains(query))
              .toList();
    });
  }

  void onEndLocationChanged() {
    String query = endLocationController.text.toLowerCase();
    setState(() {
      filteredLocations = query.isEmpty
          ? previousLocations
          : buildings
              .where((building) => building.name.toLowerCase().contains(query))
              .toList();
    });
  }

  void selectLocation(Building building, [Room? room]) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    setState(() {
      if (isSelectingStart) {
        startLocation = building.location;
        // startLocationController.text = building.location.name;
        startLocationController.text = room != null
            ? '${building.name} - ${room.roomName}'
            : building.location.name;
        locationProvider.setStartLocation(building.location);
        if (room != null) {
          locationProvider.setStartRoom(room);
        }
      } else {
        endLocation = building.location;
        endLocationController.text = room != null
            ? '${building.name} - ${room.roomNumber}'
            : building.location.name;
        locationProvider.setEndLocation(building.location);
        if (room != null) {
          locationProvider.setEndRoom(room);
        }
      }
      isFocused = false;
      // updateRecentSearches(building);
      filteredLocations = previousLocations;
    });

    // Navigate back to the previous screen (Map page)
    if (startLocation != null && endLocation != null) {
      if (widget.chosenDestination == null) {
        Navigator.pop(context);
      } else {
        locationProvider.setSelectedIndex(0);
        Navigator.popUntil(context, ModalRoute.withName('/'));
      }
    }
  }

  // Future<void> updateRecentSearches(Building matchingBuilding) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     previousLocations.removeWhere(
  //         (building) => building.location == matchingBuilding.location);
  //     previousLocations.insert(0, matchingBuilding);
  //     if (previousLocations.length > 10) {
  //       previousLocations.removeLast();
  //     }
  //   });

  //   List<String> recentSearches = previousLocations
  //       .map((building) => jsonEncode(building.toJson()))
  //       .toList();

  //   await prefs.setStringList('recent_searches', recentSearches);
  // }

  // Future<void> loadRecentSearches() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();

  //   List<String>? recentSearches = prefs.getStringList('recent_searches');
  //   if (recentSearches != null) {
  //     setState(() {
  //       previousLocations = recentSearches.map((search) {
  //         var decoded = jsonDecode(search);
  //         return Building.fromJson(decoded);
  //       }).toList();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Enter Location'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Material(
                        elevation: 4,
                        shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                        child: TextField(
                          onTap: () {
                            setState(() {
                              isSelectingStart = true;
                              isFocused = true;
                            });
                          },
                          controller: startLocationController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromARGB(255, 248, 248, 248),
                            prefixIcon: const Icon(Icons.circle,
                                color: Color.fromARGB(255, 170, 59, 62)),
                            hintText: 'Enter a starting point',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      if (startLocation != null ||
                          widget.chosenDestination != null) ...[
                        const SizedBox(
                          height: 20,
                        ),
                        Material(
                          elevation: 4,
                          shadowColor: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          child: TextField(
                            onTap: () {
                              setState(() {
                                isSelectingStart = false;
                                isFocused = true;
                              });
                            },
                            controller: endLocationController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 248, 248, 248),
                              prefixIcon: const Icon(Icons.circle,
                                  color: Color.fromARGB(255, 170, 59, 62)),
                              hintText: 'Enter destination location',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(

                        color: Color.fromARGB(
                            255, 242, 242, 242), // Set the color of the border
                        width: 5.0, // Set the width of the border
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (isFocused &&
                          startLocationController.text.isEmpty) ...[
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            getCurrentLocation();
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.location_pin,
                                  color: Color.fromARGB(255, 170, 59, 62)),
                              SizedBox(
                                  width:
                                      5), // Adjust spacing between icon and text
                              Text(
                                'Current location',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 170, 59, 62),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // if (isFocused &&
                      //     (startLocationController.text.isEmpty &&
                      //         endLocationController.text.isEmpty)) ...[
                      //   const SizedBox(
                      //     height: 20,
                      //   ),
                      //   const Align(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text(
                      //       'RECENT SEARCHES',
                      //       style: TextStyle(
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ],
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                if (isFocused) ...[
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredLocations.length,
                      itemBuilder: (context, index) {
                        Building building = filteredLocations[index];
                        List<Widget> buildingAndRoomsList = [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 242, 242,
                                      242), // Set the color of the border
                                  width: 5.0, // Set the width of the border
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 19),
                              child: ListTile(
                                leading:
                                    const Icon(Icons.location_pin, size: 30),
                                title: Text(building.name),
                                subtitle: const Text("Ashesi University"),
                                onTap: () {
                                  selectLocation(building);
                                },
                              ),
                            ),
                          ),
                        ];

                        if (building.mapId.isNotEmpty) {
                          buildingAndRoomsList
                              .addAll(building.rooms.map((room) {
                            return Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromARGB(255, 242, 242,
                                        242), // Set the color of the border
                                    width: 5.0, // Set the width of the border
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 19),
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.meeting_room, size: 30),
                                  title: Text(
                                      '${building.name} - ${room.roomName}'),
                                  subtitle: const Text("Ashesi University"),
                                  onTap: () {
                                    selectLocation(building, room);
                                  },
                                ),
                              ),
                            );
                          }).toList());
                        }

                        return Column(
                          children: buildingAndRoomsList,
                        );
                      },
                    ),
                  ),
                ]
              ],
            ),
    );
  }
}
