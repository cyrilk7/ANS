import 'package:ashesi_navigation_app/controllers/route_controller.dart';
import 'package:ashesi_navigation_app/models/location_model.dart';
import 'package:ashesi_navigation_app/pages/indoor_map.dart';
import 'package:ashesi_navigation_app/pages/menu.dart';
import 'package:ashesi_navigation_app/pages/search_location.dart';
import 'package:ashesi_navigation_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late RouteController _routeController;
  List<LatLng> routpoints = [const LatLng(5.759221, -0.220316)];
  bool locationInitialized = false;
  late Location start;
  late Location end;
  bool showIndoorMap = false;
  String? indoorMapId;
  bool sameBuilding = false;
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _routeController = RouteController();
    // _initLocationTracking();
  }

  Future<void> _initLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentPosition = position;
        _fetchRoute(
          position.latitude,
          position.longitude,
          end.latitude,
          end.longitude,
        );
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locationProvider = Provider.of<LocationProvider>(context);
    if (locationProvider.startLocation != null &&
        locationProvider.endLocation != null) {
      setState(() {
        locationInitialized = true;
        start = locationProvider.startLocation!;
        end = locationProvider.endLocation!;
        showIndoorMap = locationProvider.startRoom != null;
        indoorMapId = locationProvider.startLocation?.mapId;
        sameBuilding = locationProvider.startLocation?.name ==
            locationProvider.endLocation?.name;
      });
      // _initLocationTracking();
      _fetchRoute(start.latitude, start.longitude, end.latitude, end.longitude);
    }
  }

  Future<void> _fetchRoute(
    double latitude1,
    double longitude1,
    double latitude2,
    double longitude2,
  ) async {
    final route = await _routeController.findRoute(
      latitude1,
      longitude1,
      latitude2,
      longitude2,
    );
    setState(() {
      routpoints = route;
    });
  }

  void toggleMapView() {
    setState(() {
      showIndoorMap = !showIndoorMap; // Toggle the map view
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final startLocation = locationProvider.startLocation;
    final endLocation = locationProvider.endLocation;
    final startRoom = locationProvider.startRoom;
    final endRoom = locationProvider.endRoom;

    return Stack(children: [
      if (showIndoorMap && indoorMapId != null)
        IndoorMap(
          mapId: indoorMapId!,
          startSpace: startRoom!.roomName,
          endSpace: endRoom!.roomName,
        )
      // IndoorMap(mapId: indoorMapId!, startSpace: 'None', endSpace: 'None',)
      else
        FlutterMap(
          options: MapOptions(
            initialCenter: routpoints[0],
            initialZoom: 17,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            PolylineLayer(
              polylineCulling: false,
              polylines: [
                Polyline(points: routpoints, color: Colors.blue, strokeWidth: 9)
              ],
            ),
            if (startLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point:
                        LatLng(startLocation.latitude, startLocation.longitude),
                    child: const Icon(Icons.location_pin, color: Colors.blue),
                  ),
                ],
              ),
            if (endLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(endLocation.latitude, endLocation.longitude),
                    child: const Icon(Icons.location_pin, color: Colors.red),
                  ),
                ],
              ),
          ],
        ),
      Positioned(
        top: 60,
        left: 20,
        right: 20,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Select location',
                    prefixIcon: const Icon(Icons.gps_fixed,
                        color: Color.fromARGB(255, 170, 59, 62)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchLocation(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Menu(),
                  ),
                );
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu,
                    size: 30,
                    color: Color.fromARGB(255, 170, 59, 62),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      if (!sameBuilding)
        Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 26),
              child: GestureDetector(
                onTap: () {
                  toggleMapView();
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.map_sharp,
                      size: 30,
                      color: Color.fromARGB(255, 170, 59, 62),
                    ),
                  ),
                ),
              ),
            ))
      // if (locationInitialized) ...[
      //   Align(
      //     alignment: Alignment.bottomCenter,
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //       child: SizedBox(
      //         width: double.infinity,
      //         child: Card(
      //           color: Colors.white,
      //           elevation: 4,
      //           child: Padding(
      //             padding: const EdgeInsets.all(12.0),
      //             child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 const Text(
      //                   'Start Location',
      //                   style: TextStyle(
      //                       color: Colors.grey,
      //                       fontSize: 14,
      //                       fontWeight: FontWeight.bold),
      //                 ),
      //                 const SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   start.name,
      //                   style: const TextStyle(
      //                       fontWeight: FontWeight.bold, fontSize: 20),
      //                 ),
      //                 const SizedBox(
      //                   height: 10,
      //                 ),
      //                 const Text(
      //                   'End location',
      //                   style: TextStyle(
      //                       color: Colors.grey,
      //                       fontSize: 14,
      //                       fontWeight: FontWeight.bold),
      //                 ),
      //                 const SizedBox(
      //                   height: 5,
      //                 ),
      //                 Text(
      //                   end.name,
      //                   style: const TextStyle(
      //                       fontWeight: FontWeight.bold, fontSize: 20),
      //                 ),
      //                 const SizedBox(
      //                   height: 10,
      //                 ),
      //                 ElevatedButton(
      //                   style: ElevatedButton.styleFrom(
      //                     minimumSize: const Size(double.infinity, 55),
      //                     shape: RoundedRectangleBorder(
      //                       borderRadius: BorderRadius.circular(
      //                           10.0), // Set desired border radius here
      //                     ),
      //                     backgroundColor:
      //                         const Color.fromARGB(255, 170, 60, 63),
      //                     foregroundColor: Colors.white,
      //                   ),
      //                   onPressed: () {
      //                     _fetchRoute(start.latitude, start.longitude,
      //                         end.latitude, end.longitude);
      //                     setState(() {
      //                       locationInitialized = false;
      //                     });
      //                   },
      //                   child: const Text(
      //                     "Start",
      //                     style: TextStyle(
      //                         fontSize: 17, fontWeight: FontWeight.bold),
      //                   ),
      //                 ),
      // if ((startRoom != null && !showIndoorMap) ||
      //     (endRoom != null && showIndoorMap))
      //   ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       minimumSize: const Size(double.infinity, 55),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(10.0),
      //       ),
      //       backgroundColor: Colors.blue,
      //       foregroundColor: Colors.white,
      //     ),
      //     onPressed: toggleMapView,
      //     child: Text(
      //       showIndoorMap ? 'Switch to Outdoor Map' : 'Switch to Indoor Map',
      //       style: const TextStyle(),
      //     ),
      //   )
      //               ],
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   )
      // ]
    ]);
  }
}
