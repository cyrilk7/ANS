import 'package:ashesi_navigation_app/services/route_service.dart';
import 'package:ashesi_navigation_app/models/route_model.dart';
import 'package:latlong2/latlong.dart';

class RouteController {
  final RouteService _routeService;

  RouteController(this._routeService);

  Future<RouteModel> fetchRoute(LatLng start, LatLng destination) async {
    return _routeService.fetchRoute(start, destination);
  }
}
