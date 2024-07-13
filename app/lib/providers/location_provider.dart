import 'package:ashesi_navigation_app/models/room_model.dart';
import 'package:flutter/material.dart';
import 'package:ashesi_navigation_app/models/location_model.dart';

class LocationProvider extends ChangeNotifier {
  int _selectedIndex = 0; // Default selected index is 0 (Map)
  Location? _startLocation; // Start location
  Location? _endLocation; // End location
  Room? _startRoom;
  Room? _endRoom;
  bool _locationsChanged = false;

  // Getter for selected index
  int get selectedIndex => _selectedIndex;
  bool get locationsChanged => _locationsChanged;
  Location? get startLocation => _startLocation;
  Location? get endLocation => _endLocation;
  Room? get startRoom => _startRoom;
  Room? get endRoom => _endRoom;

  // Setter for selected index
  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners(); // Notify listeners about the change
  }

  // Getter for start location

  // Setter for start location
  void setStartLocation(Location location) {
    _startLocation = location;
    _locationsChanged = true;
    notifyListeners(); // Notify listeners about the change
  }

  void setStartRoom(Room room) {
    _startRoom = room;
    _locationsChanged = true;
  }

  // Getter for end location

  // Setter for end location
  void setEndLocation(Location location) {
    _endLocation = location;
    _locationsChanged = true;
    notifyListeners(); // Notify listeners about the change
  }

  void setEndRoom(Room room) {
    _endRoom = room;
    _locationsChanged = true;
  }

  void resetLocationsChanged() {
    _locationsChanged = false;
    notifyListeners();
  }
}
