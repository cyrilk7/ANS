import 'package:ashesi_navigation_app/controllers/event_controller.dart';
import 'package:ashesi_navigation_app/models/event_model.dart';
import 'package:ashesi_navigation_app/widgets/custom_calendar.dart';
import 'package:ashesi_navigation_app/widgets/event_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Events extends StatefulWidget {
  const Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  late Future<Map<String, List<Event>>> _futureEvents;
  DateTime _selectedDay = DateTime.now(); 

  @override
  void initState() {
    super.initState();
    _futureEvents = EventController()
        .fetchEventsByDay(DateFormat('yyyy-MM-dd').format(_selectedDay)); // Replace with the desired date
  }

  void _loadEventsForDay(DateTime day) {
    setState(() {
      _selectedDay = day;
      _futureEvents = EventController().fetchEventsByDay(
          DateFormat('yyyy-MM-dd').format(day)); // Fetch events for selected day
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 250),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
              child: CustomCalendar(
                onTapCallback: _loadEventsForDay,
              ),
            ),
            Expanded(
              child: FutureBuilder<Map<String, List<Event>>>(
                future: _futureEvents,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No events found'));
                  } else {
                    final groupedEvents = snapshot.data!;
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: groupedEvents.entries.map((entry) {
                            final startTime = entry.key;
                            final events = entry.value;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, bottom: 8),
                                  child: Text(
                                    startTime,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: Color.fromARGB(255, 170, 59, 62),
                                    ),
                                  ),
                                ),
                                ...events.map((event) => EventCard(event: event)).toList(),
                                const SizedBox(height: 10),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
