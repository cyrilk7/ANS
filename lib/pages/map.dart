import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:ashesi_navigation_app/pages/map_input.dart';
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
  final start = TextEditingController();
  final end = TextEditingController();
  bool isVisible = false;

  List<LatLng> routpoints = [LatLng(5.759221, -0.220316)];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          myInput(controler: start, hint: 'Enter Starting address'),
          const SizedBox(
            height: 20,
          ),
          myInput(controler: end, hint: 'Enter destination address'),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
              onPressed: () async {
                // List<Location> start_l = await locationFromAddress(start.text);
                // print(start_l);
                // List<Location> end_l = await locationFromAddress(end.text);

                var v1 = 5.75848;
                var v2 = -0.22052;
                var v3 = 5.75897;
                var v4 = -0.22010;

                var url = Uri.parse(
                    'http://router.project-osrm.org/route/v1/foot/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
                var response = await http.get(url);
                print(response.body);
                setState(() {
                  routpoints = [];
                  var ruter = jsonDecode(response.body)['routes'][0]['geometry']
                      ['coordinates'];
                  for (int i = 0; i < ruter.length; i++) {
                    var reep = ruter[i].toString();
                    reep = reep.replaceAll("[", "");
                    reep = reep.replaceAll("]", "");
                    var lat1 = reep.split(',');
                    var long1 = reep.split(",");
                    routpoints.add(
                        LatLng(double.parse(lat1[1]), double.parse(long1[0])));
                  }
                  isVisible = !isVisible;
                  print(routpoints);
                });
              },
              child: Text('Press')),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 400,
            width: 400,
            child: Visibility(
              visible: true,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: routpoints[0],
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  PolylineLayer(
                    polylineCulling: false,
                    polylines: [
                      Polyline(
                          points: routpoints,
                          color: Colors.blue,
                          strokeWidth: 9)
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
