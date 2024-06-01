import 'package:flutter/material.dart';
import 'package:ashesi_navigation_app/models/location_model.dart';

class LocationProvider extends ChangeNotifier {
  int _selectedIndex = 0; // Default selected index is 0 (Map)
  Location? _startLocation; // Start location
  Location? _endLocation; // End location

  // Getter for selected index
  int get selectedIndex => _selectedIndex;

  // Setter for selected index
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notify listeners about the change
  }

  // Getter for start location
  Location? get startLocation => _startLocation;

  // Setter for start location
  void setStartLocation(Location location) {
    _startLocation = location;
    notifyListeners(); // Notify listeners about the change
  }

  // Getter for end location
  Location? get endLocation => _endLocation;

  // Setter for end location
  void setEndLocation(Location location) {
    _endLocation = location;
    notifyListeners(); // Notify listeners about the change
  }
}
