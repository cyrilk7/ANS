import 'dart:convert';

import 'package:ashesi_navigation_app/models/building_model.dart';
import 'package:http/http.dart' as http;

class BuildingService {
  Future<List<Building>> getAllBuildings() async {
    var url = 'https://europe-west2-capstone-431814.cloudfunctions.net/function-1/buildings';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // print(data);

      // Convert the JSON data into a list of Building objects
      List<Building> buildings = data.map((json) {
        return Building.fromJson(json);
      }).toList();

      return buildings;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load buildings');
    }
  }
}
