import 'package:ashesi_navigation_app/controllers/route_controller.dart';
import 'package:ashesi_navigation_app/pages/menu.dart';
import 'package:ashesi_navigation_app/pages/search_location.dart';
import 'package:ashesi_navigation_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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

  @override
  void initState() {
    super.initState();
    _routeController = RouteController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locationProvider = Provider.of<LocationProvider>(context);
    if (locationProvider.startLocation != null &&
        locationProvider.endLocation != null) {
      _fetchRoute(
        locationProvider.startLocation!.latitude,
        locationProvider.startLocation!.longitude,
        locationProvider.endLocation!.latitude,
        locationProvider.endLocation!.longitude,
      );
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


  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final startLocation = locationProvider.startLocation;
    final endLocation = locationProvider.endLocation;

    return Stack(children: [
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
                  point: LatLng(startLocation.latitude, startLocation.longitude),
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
    ]);
  }
}
