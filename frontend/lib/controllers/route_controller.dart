import 'package:ashesi_navigation_app/services/route_service.dart';
import 'package:latlong2/latlong.dart';

class RouteController {
  final RouteService _routeService = RouteService();

  Future<List<LatLng>> findRoute(
      double latitude1, double longitude1, double latitude2, double longitude2) async {
    return await _routeService.fetchRoute(latitude1, longitude1, latitude2, longitude2);
  }

  
}
