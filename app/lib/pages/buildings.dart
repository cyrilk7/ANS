import 'package:ashesi_navigation_app/controllers/building_controller.dart';
import 'package:ashesi_navigation_app/models/building_model.dart';
import 'package:flutter/material.dart';

class Buildings extends StatefulWidget {
  const Buildings({super.key});

  @override
  State<Buildings> createState() => _BuildingsState();
}

class _BuildingsState extends State<Buildings> {
  final BuildingController controller = BuildingController();
  TextEditingController searchController = TextEditingController();
  late Future<List<Building>> buildings;
  List<Building> filteredBuildings = [];
  String selectedCategory = 'All'; // Default category

  @override
  void initState() {
    super.initState();
    buildings = controller.fetchBuildings().then((value) {
      setState(() {
        filteredBuildings = value;
      });
      return value;
    });
  }

  Future<void> updateFilteredBuildings(String query) async {
    query = query.toLowerCase();
    final temp = await buildings;
    setState(() {
      filteredBuildings = temp
          .where((building) =>
              building.name.toLowerCase().contains(query) &&
              (selectedCategory == 'All' ||
                  building.category == selectedCategory))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          actions: [],
          backgroundColor: const Color.fromARGB(255, 170, 59, 62),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage('assets/images/logo.png'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Buildings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 35,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7)),
                      child: PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.filter_list,
                          color: Color.fromARGB(255, 170, 59, 62),
                        ),
                        onSelected: (value) {
                          setState(() {
                            selectedCategory = value;
                          });
                          updateFilteredBuildings(searchController.text);
                        },
                        itemBuilder: (BuildContext context) {
                          List<String> categories = [
                            'All',
                            'Academic & Administrative',
                            'Health & Sports',
                            'Dining'
                          ]; // Replace with your categories
                          return categories.map((String category) {
                            return PopupMenuItem<String>(
                              value: category,
                              child: Text(category),
                            );
                          }).toList();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 3),
            child: TextField(
              onChanged: (value) {
                updateFilteredBuildings(value);
              },
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search,
                    color: Color.fromARGB(255, 170, 59, 62)),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 38, 50, 56),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Building>>(
              future: buildings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator()); // Show loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  // List<Building> buildings = snapshot.data!;
                  return filteredBuildings.isEmpty
                      ? const Center(child: Text('No data found'))
                      : Padding(
                          padding: const EdgeInsets.all(15),
                          child: ListView.builder(
                            itemCount: filteredBuildings.length,
                            itemBuilder: (context, index) {
                              return filteredBuildings[index];
                            },
                          ),
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
