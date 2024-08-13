import 'dart:convert';
import 'package:ashesi_navigation_app/models/event_model.dart';
import 'package:http/http.dart' as http;

class EventController {
  Future<Map<String, List<Event>>> fetchEventsByDay(String day) async {
    var url = 'https://europe-west2-capstone-431814.cloudfunctions.net/function-1/events/$day';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      Map<String, List<Event>> eventsByTime = {};

      jsonResponse.forEach((time, events) {
        eventsByTime[time] = List<Event>.from(events.map((eventJson) {
          return Event.fromJson(eventJson);
        }));
      });

      return eventsByTime;
    } else {
      throw Exception('Failed to load events');
    }
  }
}
