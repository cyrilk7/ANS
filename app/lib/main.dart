import 'package:ashesi_navigation_app/pages/buildings.dart';
import 'package:ashesi_navigation_app/pages/indoor_map.dart';
import 'package:ashesi_navigation_app/pages/menu.dart';
import 'package:ashesi_navigation_app/pages/schedule.dart';
import 'package:ashesi_navigation_app/pages/splash_screen.dart';
import 'package:ashesi_navigation_app/providers/location_provider.dart';
import 'package:flutter/material.dart';
import 'package:ashesi_navigation_app/pages/events.dart';
import 'package:ashesi_navigation_app/pages/map.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // Set your desired background color here
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MyHomePage(),
        '/menu': (context) => const Menu(),
        '/events': (context) => const Events(),
        '/buildings': (context) => const Buildings(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int initialIndex;
  const MyHomePage({super.key, this.initialIndex = 0});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List pages = [
    const Map(),
    // const IndoorMap(mapId: "6668718e8de671000ba55c93"),
    const Events(),
    const Buildings(),
  ];

  final List<String> pageTexts = [
    'Map',
    'Events',
    'Buildings',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        int currentIndex = locationProvider.selectedIndex;
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 248, 248, 250),
          appBar: currentIndex != 0 && currentIndex != 2
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(90),
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
                                backgroundImage:
                                    AssetImage('assets/images/logo.png'),
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
                )
              : null,
          body: pages[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) {
              locationProvider.setSelectedIndex(index);
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
            ],
            selectedItemColor: const Color.fromARGB(255, 170, 59, 62),
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: const TextStyle(
              fontSize: 10,
            ),
            selectedLabelStyle: const TextStyle(fontSize: 10, letterSpacing: 2),
          ),
        );
      },
    );
  }
}
