import 'package:ashesi_navigation_app/models/building_model.dart';
import '../services/buildings_service.dart';

class BuildingController {
  final BuildingService buildingService = BuildingService();

  Future<List<Building>> fetchBuildings() async {
    try {
      return await buildingService.getAllBuildings();
    } catch (e) {
      print('Error fetching buildings: $e');
      return []; // Return empty list if there's an error
    }
  }
}
