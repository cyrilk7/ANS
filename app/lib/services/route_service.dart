import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteService {
  Future<List<LatLng>> fetchRoute(
      double latitude1, double longitude1, double latitude2, double longitude2) async {
    var v1 = latitude1;
    var v2 = longitude1;
    var v3 = latitude2;
    var v4 = longitude2;

    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/foot/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);

    var routePoints = <LatLng>[];
    var ruter = jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
    for (int i = 0; i < ruter.length; i++) {
      var reep = ruter[i].toString();
      reep = reep.replaceAll("[", "");
      reep = reep.replaceAll("]", "");
      var lat1 = reep.split(',');
      var long1 = reep.split(",");
      routePoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
    }
    return routePoints;
  }
}
