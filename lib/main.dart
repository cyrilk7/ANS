import 'package:ashesi_navigation_app/controllers/route_controller.dart';
import 'package:ashesi_navigation_app/pages/buildings.dart';
import 'package:ashesi_navigation_app/pages/menu.dart';
import 'package:ashesi_navigation_app/pages/schedule.dart';
import 'package:flutter/material.dart';
import 'package:ashesi_navigation_app/pages/events.dart';
import 'package:ashesi_navigation_app/pages/map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/menu': (context) => Menu(),
        '/events': (context) => Events(),
        '/buildings': (context) => Buildings(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int initialIndex;
  const MyHomePage({this.initialIndex = 0});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  List pages = [
    Map(), 
    const Events(), 
    const Buildings(), 
    const Schedule()
  ];

  final List<String> pageTexts = [
    'Map',
    'Events',
    'Buildings',
    'Schedule',
  ];

    @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // Set initial index
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: currentIndex != 0 ? PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 170, 59, 62),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      pageTexts[currentIndex],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ) : null,
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: currentIndex == 0
                  ? Image.asset(
                      'assets/images/map_red.png',
                      width: 24,
                      height: 24,
                    )
                  : Image.asset(
                      'assets/images/map_grey.png',
                      width: 24,
                      height: 24,
                    ),
              label: 'Map'),
          BottomNavigationBarItem(
            icon: currentIndex == 1
                ? Image.asset(
                    'assets/images/events_red.png',
                    width: 23,
                    height: 23,
                  )
                : Image.asset(
                    'assets/images/events_grey.png',
                    width: 23,
                    height: 23,
                  ),
            label: 'Events',
          ),
          BottomNavigationBarItem(
              icon: currentIndex == 2
                  ? Image.asset(
                      'assets/images/buildings_red.png',
                      width: 24,
                      height: 24,
                    )
                  : Image.asset(
                      'assets/images/buildings_grey.png',
                      width: 24,
                      height: 24,
                    ),
              label: 'Buildings'),
          BottomNavigationBarItem(
              icon: currentIndex == 3
                  ? Image.asset(
                      'assets/images/schedule_red.png',
                      width: 24,
                      height: 24,
                    )
                  : Image.asset(
                      'assets/images/schedule_grey.png',
                      width: 24,
                      height: 24,
                    ),
              label: 'Schedule')
        ],
        selectedItemColor: const Color.fromARGB(255, 170, 59, 62),
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
        ),
        selectedLabelStyle: const TextStyle(fontSize: 10, letterSpacing: 2),
      ),
    );
  }
}
