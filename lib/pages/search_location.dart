import 'package:ashesi_navigation_app/models/location_model.dart';
import 'package:ashesi_navigation_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class SearchLocation extends StatefulWidget {
  final Location? chosenDestination;

  const SearchLocation({super.key, this.chosenDestination});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  Position? userPosition;

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

  List<Location> previousLocations = [
    Location(
        name: 'Entrepreneurship, Innovation & Service Centre',
        latitude: 5.75886,
        longitude: -0.21748),
    Location(
        name: 'Engineering Workshop', latitude: 5.75905, longitude: -0.21769),
  ];

  List<Location> allLocations = [
    Location(
        name: 'Entrepreneurship, Innovation & Service Centre',
        latitude: 5.75886,
        longitude: -0.21748),
    Location(
        name: 'Engineering Workshop', latitude: 5.75905, longitude: -0.21769),
    Location(
        name: 'Natembea Health Centre', latitude: 5.75927, longitude: -0.21803),
    Location(
        name: 'Fabrication Lab (Fab Lab)',
        latitude: 5.75948,
        longitude: -0.21829),
    Location(name: 'Sports Centre', latitude: 5.75785, longitude: -0.21715),
    Location(name: 'Nutor Hall', latitude: 5.75902, longitude: -0.21967),
    //Check coordinates for engineering building
    Location(
        name: 'King Engineering Building',
        latitude: 5.75955,
        longitude: -0.21934),
    Location(name: 'Warren Library', latitude: 5.75976, longitude: -0.21979),
    Location(name: 'Apt Hall', latitude: 5.75954, longitude: -0.21982),
    Location(name: 'Ashesi Bookshop', latitude: 5.75915, longitude: -0.21994),
  ];

  List<Location> filteredLocations = [];
  bool isSelectingStart = true;
  bool isFocused = false;

  TextEditingController startLocationController = TextEditingController();
  TextEditingController endLocationController = TextEditingController();

  Location? startLocation;
  Location? endLocation;

  @override
  void initState() {
    super.initState();
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
          : allLocations
              .where((location) => location.name.toLowerCase().contains(query))
              .toList();
    });
  }

  void onEndLocationChanged() {
    String query = endLocationController.text.toLowerCase();
    setState(() {
      filteredLocations = query.isEmpty
          ? previousLocations
          : allLocations
              .where((location) => location.name.toLowerCase().contains(query))
              .toList();
    });
  }

  void selectLocation(Location location) {
    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    setState(() {
      if (isSelectingStart) {
        startLocation = location;
        startLocationController.text = location.name;
        locationProvider.setStartLocation(location);
      } else {
        endLocation = location;
        endLocationController.text = location.name;
        locationProvider.setEndLocation(location);
      }
      isFocused = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            TextField(
              onTap: () {
                setState(() {
                  isSelectingStart = true;
                  isFocused = true;
                });
              },
              controller: startLocationController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 170, 59, 62)),
                hintText: 'Enter a starting point',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (startLocation != null || widget.chosenDestination != null) ...[
              const SizedBox(
                height: 20,
              ),
              TextField(
                onTap: () {
                  setState(() {
                    isSelectingStart = false;
                    isFocused = true;
                  });
                },
                controller: endLocationController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: const Icon(Icons.search,
                      color: Color.fromARGB(255, 170, 59, 62)),
                  hintText: 'Enter destination location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
            if (isFocused && startLocationController.text.isEmpty) ...[
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
                    SizedBox(width: 5), // Adjust spacing between icon and text
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
            if (isFocused &&
                (startLocationController.text.isEmpty ||
                    endLocationController.text.isEmpty)) ...[
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'RECENT SEARCHES',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            if (isFocused) ...[
              ListView.builder(
                shrinkWrap: true,
                itemCount: filteredLocations.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredLocations[index].name),
                    onTap: () {
                      selectLocation(filteredLocations[index]);
                    },
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
