import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ashesi_navigation_app/models/route_model.dart';
import 'package:latlong2/latlong.dart';

class RouteService {
  Future<RouteModel> fetchRoute(LatLng start, LatLng destination) async {
    final String apiUrl = 'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?steps=true';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final routeCoords = _extractRouteCoords(decodedData);
        return RouteModel(routeCoords: routeCoords);
      } else {
        throw Exception('Failed to fetch route: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching route: $e');
    }
  }

  List<LatLng> _extractRouteCoords(Map<String, dynamic> decodedData) {
    final List<dynamic> routeSteps = decodedData['routes'][0]['legs'][0]['steps'];
    final List<LatLng> routeCoords = routeSteps.map((step) {
      final List<dynamic> maneuverLocation = step['maneuver']['location'];
      return LatLng(maneuverLocation[1], maneuverLocation[0]);
    }).toList();
    return routeCoords;
  }
}
