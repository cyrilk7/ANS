import 'dart:convert';
import 'package:ashesi_navigation_app/models/location_model.dart';
import 'package:ashesi_navigation_app/pages/menu.dart';
import 'package:ashesi_navigation_app/pages/search_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
// import 'package:webview_flutter/webview_flutter.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late Location startLocation;
  late Location endLocation;

  void navigateAndSelectLocations(BuildContext context) async {
    final userData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchLocation(),
      ),
    );

    if (userData != null) {
      setState(() {
        startLocation = userData['start'];
        endLocation = userData['end'];
      });

      findRoute(startLocation.latitude, startLocation.longitude,
          endLocation.latitude, endLocation.longitude);
    }
  }

  void findRoute(double latitude1, double longitude1, double latitude2,
      double longitude2) async {
    // print(latitude1);
    var v1 = latitude1;
    var v2 = longitude1;
    var v3 = latitude2;
    var v4 = longitude2;

    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/foot/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);
    // print(response.body);
    setState(() {
      routpoints = [];
      var ruter =
          jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      for (int i = 0; i < ruter.length; i++) {
        var reep = ruter[i].toString();
        reep = reep.replaceAll("[", "");
        reep = reep.replaceAll("]", "");
        var lat1 = reep.split(',');
        var long1 = reep.split(",");
        routpoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
      }
      print(routpoints);
    });
  }

  List<LatLng> routpoints = [LatLng(5.759221, -0.220316)];

  @override
  Widget build(BuildContext context) {
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
          )
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
                    navigateAndSelectLocations(context);
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
