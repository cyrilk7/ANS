import 'package:ashesi_navigation_app/models/building_model.dart'; // Import your Building model here

class Event {
  final int eventId;
  final String title;
  final String organizer;
  final DateTime eventDate;
  final String startTime;
  final String endTime;
  final DateTime dateBooked;
  final Building building; // Include Building as a parameter

  Event({
    required this.eventId,
    required this.title,
    required this.organizer,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
    required this.dateBooked,
    required this.building,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['event_id'],
      title: json['title'],
      organizer: json['organizer'],
      eventDate: DateTime.parse(json['event_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      dateBooked: DateTime.parse(json['date_booked']),
      building: Building.fromJson(json['building']), // Parse Building from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'title': title,
      'organizer': organizer,
      'event_date': eventDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'date_booked': dateBooked.toIso8601String(),
      'building': building.toJson(), // Convert Building to JSON
    };
  }
}
