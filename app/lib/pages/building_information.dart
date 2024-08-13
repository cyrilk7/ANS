import 'package:ashesi_navigation_app/pages/search_location.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ashesi_navigation_app/models/building_model.dart';

class BuildingInformationPage extends StatefulWidget {
  final Building building;

  const BuildingInformationPage({super.key, required this.building});

  @override
  State<BuildingInformationPage> createState() =>
      _BuildingInformationPageState();
}

class _BuildingInformationPageState extends State<BuildingInformationPage> {
  bool detailsClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: detailsClicked
                ? MediaQuery.of(context).size.height * 0.3
                : MediaQuery.of(context).size.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.building.imagePath,
                  fit: BoxFit.cover,
                ),
                if (!detailsClicked)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Card(
                              elevation: 4,
                              color: const Color(0x90909498),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      child: Text(
                                        widget.building.name,
                                        maxLines: 3,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            height: 1.2,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 30),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: Image.asset(
                                              widget.building.categoryIconPath,
                                              fit: BoxFit.cover),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          widget.building.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Row(
                                      children: [
                                        Icon(
                                          size: 25,
                                          Icons.timer,
                                          color:
                                              Color.fromARGB(255, 170, 60, 63),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "7am - 6pm",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size(double.infinity, 55),
                                        backgroundColor: const Color.fromARGB(
                                            255, 170, 60, 63),
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                SearchLocation(
                                              chosenDestination:
                                                  widget.building.location,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Get Directions",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                detailsClicked = true;
                              });
                            },
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'More Details',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  left: 15,
                  top: 40,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (detailsClicked)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 20,
                            width: 20,
                            child: Image.asset(widget.building.categoryIconPath,
                                fit: BoxFit.cover),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            widget.building.category,
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 260,
                                child: AutoSizeText(
                                  widget.building.name,
                                  maxLines: 2,
                                  minFontSize: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      height: 1,
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.green,
                                size: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Open",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.building.description,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'History',
                        style: TextStyle(
                            color: Color.fromARGB(255, 170, 60, 63),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.building.history,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(100, 55),
                          backgroundColor:
                              const Color.fromARGB(255, 170, 60, 63),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchLocation(
                                chosenDestination: widget.building.location,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Get Directions",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
