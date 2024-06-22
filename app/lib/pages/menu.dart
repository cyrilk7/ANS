import 'package:ashesi_navigation_app/main.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 248, 250),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(130),
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          flexibleSpace: const Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -2,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 170, 59, 62),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 27, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                    initialIndex: 1), // Navigate to index 1
                              ),
                            );
                          },
                          child: Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Image.asset(
                                'assets/images/events_large.png',
                                width: 37,
                                height: 40,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Events',
                          style: TextStyle(
                            letterSpacing: 2,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Image.asset(
                                'assets/images/buildings_red.png',
                                width: 45,
                                height: 45,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Buildings',
                          style: TextStyle(
                            letterSpacing: 2,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: Card(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            elevation: 3,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Image.asset(
                                'assets/images/map_red.png',
                                width: 40,
                                height: 40,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Map',
                          style: TextStyle(
                            letterSpacing: 2,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 19),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Card(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Image.asset(
                              'assets/images/schedule_red.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Schedule',
                        style: TextStyle(
                          letterSpacing: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(350, 50)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 170, 59, 62)),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
    );
  }
}
