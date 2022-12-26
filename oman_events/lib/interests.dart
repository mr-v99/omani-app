import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oman_events/components/background.dart';
import 'package:path_provider/path_provider.dart';
import 'Screens/Home/home.dart';
import 'constants.dart';


class Interests extends StatefulWidget {
  const Interests({Key? key}) : super(key: key);

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {

  //final User user = FirebaseAuth.instance.currentUser!;

  List<Color> allColors = [
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
    kPrimaryColor0,
  ];

  List <String> interests = [];

  late Directory _dir;
  late File _file;

  _getFile() async {
    // gets a reference to the file
    _dir = await getApplicationDocumentsDirectory();
    String path = _dir.path;
    print(path);
    _file = File("$path/filename.txt");
  }

  _writeFile () async {
    String allInterests="";

    for (String interest in interests){
      allInterests = "$allInterests\n$interest";
    }

    await _file.writeAsString(allInterests, mode: FileMode.writeOnly);
  }

  _readFile () async {
    String content = await _file.readAsString();
  }


  @override
  void initState() {
    super.initState();
    _getFile();
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  const Text(
                    "Select Your Interests",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Find the best Events for you",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Education
                  Row(
                    children: const [
                      Icon(Icons.menu_book),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "EDUCATION",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                if (allColors[0] == kPrimaryColor0) {
                                  allColors[0] = kPrimaryColor;
                                  interests.add('Computer Science');
                                } else {
                                  allColors[0] = kPrimaryColor0;
                                  interests.remove('Computer Science');
                                }
                                setState(() {});

                              },
                              color: allColors[0],
                              child: const Text(
                                'Computer Science',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              onPressed: () {
                                if (allColors[1] == kPrimaryColor0) {
                                  allColors[1] = kPrimaryColor;
                                  interests.add('Law');
                                } else {
                                  allColors[1] = kPrimaryColor0;
                                  interests.remove('Law');
                                }
                                setState(() {});
                              },
                              color: allColors[1],
                              child: const Text(
                                'Law',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              onPressed: () {
                                if (allColors[2] == kPrimaryColor0) {
                                  allColors[2] = kPrimaryColor;
                                  interests.add('Engineering');
                                } else {
                                  allColors[2] = kPrimaryColor0;
                                  interests.remove('Engineering');
                                }
                                setState(() {});
                              },
                              color: allColors[2],
                              child: const Text(
                                'Engineering',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            MaterialButton(
                              onPressed: () {
                                if (allColors[3] == kPrimaryColor0) {
                                  allColors[3] = kPrimaryColor;
                                  interests.add('Physics');
                                } else {
                                  allColors[3] = kPrimaryColor0;
                                  interests.remove('Physics');
                                }
                                setState(() {});
                              },
                              color: allColors[3],
                              child: const Text(
                                'Physics',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              onPressed: () {
                                if (allColors[4] == kPrimaryColor0) {
                                  allColors[4] = kPrimaryColor;
                                  interests.add('Chemistry');
                                } else {
                                  allColors[4] = kPrimaryColor0;
                                  interests.remove('Chemistry');
                                }
                                setState(() {});
                              },
                              color: allColors[4],
                              child: const Text(
                                'Chemistry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MaterialButton(
                              onPressed: () {
                                if (allColors[5] == kPrimaryColor0) {
                                  allColors[5] = kPrimaryColor;
                                  interests.add('Biology');
                                } else {
                                  allColors[5] = kPrimaryColor0;
                                  interests.remove('Biology');
                                }
                                setState(() {});
                              },
                              color: allColors[5],
                              child: const Text(
                                'Biology',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Business

                  Row(
                    children: const [
                      Icon(Icons.business_center),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "BUSINESS",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[6] == kPrimaryColor0) {
                                    allColors[6] = kPrimaryColor;
                                    interests.add('Taxes');
                                  } else {
                                    allColors[6] = kPrimaryColor0;
                                    interests.remove('Taxes');
                                  }
                                  setState(() {});
                                },
                                color: allColors[6],
                                child: const Text(
                                  'Taxes',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[7] == kPrimaryColor0) {
                                    allColors[7] = kPrimaryColor;
                                    interests.add('stock market');
                                  } else {
                                    allColors[7] = kPrimaryColor0;
                                    interests.remove('stock market');
                                  }
                                  setState(() {});
                                },
                                color: allColors[7],
                                child: const Text(
                                  'stock market',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[8] == kPrimaryColor0) {
                                    allColors[8] = kPrimaryColor;
                                    interests.add('Insurance');
                                  } else {
                                    allColors[8] = kPrimaryColor0;
                                    interests.remove('Insurance');
                                  }
                                  setState(() {});
                                },
                                color: allColors[8],
                                child: const Text(
                                  'Insurance',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[9] == kPrimaryColor0) {
                                    allColors[9] = kPrimaryColor;
                                    interests.add('Financial');
                                  } else {
                                    allColors[9] = kPrimaryColor0;
                                    interests.remove('Financial');
                                  }
                                  setState(() {});
                                },
                                color: allColors[9],
                                child: const Text(
                                  'Financial',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[10] == kPrimaryColor0) {
                                    allColors[10] = kPrimaryColor;
                                    interests.add('Capitalism');
                                  } else {
                                    allColors[10] = kPrimaryColor0;
                                    interests.remove('Capitalism');
                                  }
                                  setState(() {});
                                },
                                color: allColors[10],
                                child: const Text(
                                  'Capitalism',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[11] == kPrimaryColor0) {
                                    allColors[11] = kPrimaryColor;
                                    interests.add('Socialism');
                                  } else {
                                    allColors[11] = kPrimaryColor0;
                                    interests.remove('Socialism');
                                  }
                                  setState(() {});
                                },
                                color: allColors[11],
                                child: const Text(
                                  'Socialism',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),

                  //Entertainment
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Icon(Icons.videogame_asset),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "ENTERTAINMENT",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[12] == kPrimaryColor0) {
                                    allColors[12] = kPrimaryColor;
                                    interests.add('Gaming');
                                  } else {
                                    allColors[12] = kPrimaryColor0;
                                    interests.remove('Gaming');
                                  }
                                  setState(() {});
                                },
                                color: allColors[12],
                                child: const Text(
                                  'Gaming',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[13] == kPrimaryColor0) {
                                    allColors[13] = kPrimaryColor;
                                    interests.add('Movies');
                                  } else {
                                    allColors[13] = kPrimaryColor0;
                                    interests.remove('Movies');
                                  }
                                  setState(() {});
                                },
                                color: allColors[13],
                                child: const Text(
                                  'Movies',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[14] == kPrimaryColor0) {
                                    allColors[14] = kPrimaryColor;
                                    interests.add('Netflix');
                                  } else {
                                    allColors[14] = kPrimaryColor0;
                                    interests.remove('Netflix');
                                  }
                                  setState(() {});
                                },
                                color: allColors[14],
                                child: const Text(
                                  'Netflix',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[15] == kPrimaryColor0) {
                                    allColors[15] = kPrimaryColor;
                                    interests.add('Sports');
                                  } else {
                                    allColors[15] = kPrimaryColor0;
                                    interests.remove('Sports');
                                  }
                                  setState(() {});
                                },
                                color: allColors[15],
                                child: const Text(
                                  'Sports',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[16] == kPrimaryColor0) {
                                    allColors[16] = kPrimaryColor;
                                    interests.add('Music');
                                  } else {
                                    allColors[16] = kPrimaryColor0;
                                    interests.remove('Music');
                                  }
                                  setState(() {});
                                },
                                color: allColors[16],
                                child: const Text(
                                  'Music',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  if (allColors[17] == kPrimaryColor0) {
                                    allColors[17] = kPrimaryColor;
                                    interests.add('Comedy');
                                  } else {
                                    allColors[17] = kPrimaryColor0;
                                    interests.remove('Comedy');
                                  }
                                  setState(() {});
                                },
                                color: allColors[17],
                                child: const Text(
                                  'Comedy',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                  ),

                ],
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 90),
          child: ElevatedButton(
            onPressed: () {
              _writeFile();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const HomePage();
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              elevation: 0,

            ),
            child: const Text("Confirm & Next"),
          ),
        )
      ],
    ));
  }
}

