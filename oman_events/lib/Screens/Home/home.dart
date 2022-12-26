import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:oman_events/event_screen.dart';
import '../../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Login/login_screen.dart';
import '../Signup/signup_screen.dart';
import 'components/new_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //to get the user information
  var _user = FirebaseAuth.instance.currentUser;

  late String _name;
  late String _phone;
  late String _email;

  _getUserData() async {
    if (_user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get()
          .then((value) {
        _name = value["name"];
        _phone = value['phone'];
        _email = value['email'];
      });
    }
  }

  late String _type;
  late String _imageURL;

  _setEventImage() {
    if (_type == 'educational') {
      _imageURL = 'assets/eventsImages/education.jpg';
    } else if (_type == 'sports') {
      _imageURL = 'assets/eventsImages/sports.jpg';
    } else if (_type == 'Arts') {
      _imageURL = 'assets/eventsImages/arts.jpg';
    } else if (_type == 'entertainment') {
      _imageURL = 'assets/eventsImages/entertainment.png';
    } else if (_type == 'social') {
      _imageURL = 'assets/eventsImages/social.jpg';
    } else if (_type == 'cultural') {
      _imageURL = 'assets/eventsImages/cultural.png';
    } else {
      _imageURL = 'assets/eventsImages/regular.jpg';
    }
  }

  // Attributes of Map Page
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(23.592291687293564, 58.174109068407795),
    zoom: 10,
  );
  late GoogleMapController googleMapController;
  Set<Marker> markers = {};
  final Mode _mode = Mode.overlay;

  int _currentPage = 0;

  String dropdownvalue = "1-30 November 2022";

  var dates = [
    "1-30 November 2022",
    "1-31 December 2022",
    "1-31 January 2023",
  ];

  late List<Icon> stars;

  _rating(int rank) {
    stars = [
      Icon(
        Icons.star_border,
        color: Colors.grey,
      ),
      Icon(
        Icons.star_border,
        color: Colors.grey,
      ),
      Icon(
        Icons.star_border,
        color: Colors.grey,
      ),
      Icon(
        Icons.star_border,
        color: Colors.grey,
      ),
      Icon(
        Icons.star_border,
        color: Colors.grey,
      ),
    ];

    for (int i = 0; i < rank; i++) {
      stars[i] = const Icon(
        Icons.star,
        color: Colors.yellow,
      );
    }
  }

  CollectionReference events = FirebaseFirestore.instance.collection('events');

  _displayBottomSheet(String image, String type, String title, String date,
      String location, String eid) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (_) {
          return MaterialButton(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.0,
                    height: 5.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Container(
                          height: 100,
                          width: 150,
                          margin: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              image: DecorationImage(
                                  image: AssetImage(_imageURL),
                                  fit: BoxFit.fill)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: searchColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(title, style: TextStyle(fontSize: 14)),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 20,
                                  color: searchColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(date, style: TextStyle(fontSize: 12))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: searchColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(location, style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return EventScreen(eid: eid);
                  },
                ),
              );
            },
          );
        });
  }

  Widget _displayPage() {
    if (_currentPage == 0) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: const BoxDecoration(
                  color: eventsColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  )),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 50, 0, 0),
                        child: Column(
                          children: [
                            const Text(
                              "Explore Events",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Times new roman",
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            DropdownButton(
                              value: dropdownvalue,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.purple,
                              ),
                              items: dates.map((String dates) {
                                return DropdownMenuItem(
                                  value: dates,
                                  child: Text(dates),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownvalue = newValue!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.asset(
                          "assets/images/home_top.png",
                          alignment: Alignment.topRight,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      height: 45,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.sports_gymnastics,
                            color: kPrimaryColor,
                          ),
                          Text("Sports"),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      height: 45,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.work,
                            color: kPrimaryColor,
                          ),
                          Text("Business"),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      height: 45,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.science,
                            color: kPrimaryColor,
                          ),
                          Text("Science"),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      height: 45,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.phone_android,
                            color: kPrimaryColor,
                          ),
                          Text("Tech"),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: Container(
                      height: 45,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Icon(
                            Icons.image,
                            color: kPrimaryColor,
                          ),
                          Text("Arts"),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: eventsColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Last added Events",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "times",
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  StreamBuilder(
                      stream: events.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: Text('Loading'));
                        }
                        return Column(
                          children: snapshot.data!.docs.map((event) {
                            //represent the rating as a stars icons
                            _rating(event['rating']);
                            //set the event's image
                            _type = event['type'];
                            _setEventImage();
                            //if there is a coordination, add a marker to the map
                            if (event['location coord'] != "") {
                              double latitude = double.parse(
                                  event['location coord']
                                      .toString()
                                      .split(',')[0]);
                              double longitude = double.parse(
                                  event['location coord']
                                      .toString()
                                      .split(',')[1]);

                              markers.add(Marker(
                                  markerId: MarkerId(event['location name']),
                                  position: LatLng(latitude, longitude),
                                  onTap: () {
                                    _displayBottomSheet(
                                        _imageURL,
                                        event['type'],
                                        event['title'],
                                        event['start date'] +
                                            ' - ' +
                                            event['end date'],
                                        event['location name'],
                                        event.id);
                                  }));
                            }
                            //display the event's data
                            return MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EventScreen(eid: event.id);
                                    },
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30)),
                                            image: DecorationImage(
                                                image: AssetImage(_imageURL),
                                                fit: BoxFit.cover)),
                                        height: 200,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              event['type'],
                                              style: const TextStyle(
                                                  color: kPrimaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              event['title'],
                                              style: const TextStyle(
                                                  fontFamily: "times",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.timer_outlined,
                                                  color: kPrimaryColor,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                    '${event['start date']}\n${event['start time']}')
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.map,
                                                    color: kPrimaryColor,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                        event['location name']),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.group,
                                                  color: kPrimaryColor,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(event['audiance'])
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    stars[0],
                                                    stars[1],
                                                    stars[2],
                                                    stars[3],
                                                    stars[4],
                                                  ],
                                                ),
                                                Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.share,
                                                      color: kPrimaryColor,
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Icon(
                                                      Icons.favorite_border,
                                                      color: kPrimaryColor,
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (_currentPage == 1) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            zoomControlsEnabled: false,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
        ],
      );
    } else if (_currentPage == 2) {
      if (_user == null) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Your Events",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "You are not signed in.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SignUpScreen();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const Text(
                    "or",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Your Events",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times new roman",
                        fontSize: 22,
                      ),
                    ),
                    IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const NewEvent();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder(
                    stream: events.snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: Text('Loading...'));
                      }
                      return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: searchLightColor),
                          child: Column(
                            children: snapshot.data!.docs.map((event) {
                              if (event['created by'] == _user?.uid) {
                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EventScreen(eid: event.id);
                                            },
                                          ),
                                        );
                                      },
                                      title: Text(
                                        event['title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'times',
                                            color: searchColor),
                                      ),
                                      subtitle: Text(
                                        "This event will end in ${event['end date']},",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'times',
                                            color: searchColor),
                                      ),
                                      trailing: const Icon(Icons.mode)),
                                );
                              }
                              return const SizedBox();
                            }).toList(),
                          )
                      );
                    }),
              ],
            ),
          ),
        );
      }
    } else {
      if (_user == null) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Welcome in Omani Events",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: "Times new roman",
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "You are not signed in.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SignUpScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    "or",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const LoginScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              ListTile(
                leading: Icon(Icons.announcement, color: myEventColor),
                title: Text(
                  "About us",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times"),
                ),
                trailing: Icon(Icons.arrow_right, color: myEventColor),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (x) {
                        return SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                title: Text("ِAbout us",
                                    style: TextStyle(
                                        fontFamily: "times",
                                        fontWeight: FontWeight.bold,
                                        color: myEventColor)),
                                content: Column(
                                  children: [
                                    Text(
                                        "Design and development rights reserved to",
                                        style: TextStyle(fontFamily: "times")),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 50),
                                      child: Text(
                                          "ِAli Albadi\nAlmoatamid Alsubhi\nAbdulrhaman Alhinai",
                                          style: TextStyle(
                                              fontFamily: "times",
                                              letterSpacing: 2)),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ok",
                                            style: TextStyle(
                                                fontFamily: "times",
                                                fontSize: 16)),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            backgroundColor: myEventColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              ListTile(
                leading: Icon(Icons.call, color: myEventColor),
                title: Text(
                  "Contact us",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times"),
                ),
                trailing: Icon(Icons.arrow_right, color: myEventColor),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (x) {
                        return SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                title: Text("Contact us",
                                    style: TextStyle(
                                        fontFamily: "times",
                                        fontWeight: FontWeight.bold,
                                        color: myEventColor)),
                                content: Column(
                                  children: [
                                    Text(
                                        "For any suggestions, complaints or inquiries, please contact us",
                                        style: TextStyle(fontFamily: "times")),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 50),
                                      child: Text(
                                          "Email: oman_events@gmail.com\nInstagram: oman_events\nTwitter: oman_events",
                                          style:
                                              TextStyle(fontFamily: "times")),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ok",
                                            style: TextStyle(
                                                fontFamily: "times",
                                                fontSize: 16)),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            backgroundColor: myEventColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              ListTile(
                leading: Icon(Icons.policy, color: myEventColor),
                title: Text(
                  "Policy & Privecy",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times"),
                ),
                trailing: Icon(Icons.arrow_right, color: myEventColor),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (x) {
                        return SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                title: Text("Policy & Privecy",
                                    style: TextStyle(
                                        fontFamily: "times",
                                        fontWeight: FontWeight.bold,
                                        color: myEventColor)),
                                content: Column(
                                  children: [
                                    Text(
                                        "By using this app, you agree on the policy and privecy represented in the following",
                                        style: TextStyle(fontFamily: "times")),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 50),
                                      child: Text(
                                          "Personal Information\nCurrent Location\nInteraction with the app",
                                          style:
                                              TextStyle(fontFamily: "times")),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ok",
                                            style: TextStyle(
                                                fontFamily: "times",
                                                fontSize: 16)),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            backgroundColor: myEventColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
            ],
          ),
        );
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: myEventLightColor,
                padding: EdgeInsets.fromLTRB(15, 40, 15, 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Your Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times new roman",
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: myEventColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          _name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'times',
                              fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          color: myEventColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          _email,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'times',
                              fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_android,
                          color: myEventColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          _phone,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'times',
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              ListTile(
                leading: Icon(Icons.favorite_border, color: myEventColor),
                title: Text(
                  "Favorite Events",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times"),
                ),
                trailing: Icon(Icons.arrow_right, color: myEventColor),
                onTap: () {},
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              ListTile(
                leading: Icon(Icons.announcement, color: myEventColor),
                title: Text(
                  "About us",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times"),
                ),
                trailing: Icon(Icons.arrow_right, color: myEventColor),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (x) {
                        return SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                title: Text("ِAbout us",
                                    style: TextStyle(
                                        fontFamily: "times",
                                        fontWeight: FontWeight.bold,
                                        color: myEventColor)),
                                content: Column(
                                  children: [
                                    Text(
                                        "Design and development rights reserved to",
                                        style: TextStyle(
                                            fontFamily: "times",
                                            fontWeight: FontWeight.bold)),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 50),
                                      child: Text(
                                          "ِAli Albadi\nAlmoatamid Alsubhi\nAbdulrhaman Alhinai",
                                          style: TextStyle(
                                              fontFamily: "times",
                                              letterSpacing: 1,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ok",
                                            style: TextStyle(
                                                fontFamily: "times",
                                                fontSize: 16)),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            backgroundColor: myEventColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              ListTile(
                leading: Icon(Icons.call, color: myEventColor),
                title: Text(
                  "Contact us",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times"),
                ),
                trailing: Icon(Icons.arrow_right, color: myEventColor),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (x) {
                        return SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                title: Text("Contact us",
                                    style: TextStyle(
                                        fontFamily: "times",
                                        fontWeight: FontWeight.bold,
                                        color: myEventColor)),
                                content: Column(
                                  children: [
                                    Text(
                                        "For any suggestions, complaints or inquiries, please contact us",
                                        style: TextStyle(fontFamily: "times")),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 50),
                                      child: Text(
                                          "Email: oman_events@gmail.com\nInstagram:\nTwitter",
                                          style:
                                              TextStyle(fontFamily: "times")),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ok",
                                            style: TextStyle(
                                                fontFamily: "times",
                                                fontSize: 16)),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            backgroundColor: myEventColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              ListTile(
                leading: Icon(Icons.policy, color: myEventColor),
                title: Text(
                  "Policy & Privecy",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times"),
                ),
                trailing: Icon(Icons.arrow_right, color: myEventColor),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (x) {
                        return SizedBox(
                          height: 300,
                          width: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                title: Text("Contact us",
                                    style: TextStyle(
                                        fontFamily: "times",
                                        fontWeight: FontWeight.bold,
                                        color: myEventColor)),
                                content: Column(
                                  children: [
                                    Text(
                                        "For any suggestions, complaints or inquiries, please contact us",
                                        style: TextStyle(fontFamily: "times")),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 50),
                                      child: Text(
                                          "Email: oman_events@gmail.com\nInstagram: oman_events\nTwitter: oman_events",
                                          style:
                                              TextStyle(fontFamily: "times")),
                                    ),
                                    SizedBox(
                                      height: 40,
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("ok",
                                            style: TextStyle(
                                                fontFamily: "times",
                                                fontSize: 16)),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            backgroundColor: myEventColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
              const Divider(
                height: 0,
                thickness: 1.5,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: myEventColor),
                title: Text(
                  "Sign out",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "times"),
                ),
                trailing: Icon(Icons.arrow_right, color: myEventColor),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  _user = FirebaseAuth.instance.currentUser;
                  setState(() {});
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _displayPage(),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: GNav(
          onTabChange: (value) {
            setState(() {
              _currentPage = value;
            });
          },
          gap: 8,
          padding: const EdgeInsets.all(15),
          tabs: const [
            GButton(
              backgroundColor: kPrimaryColor0,
              iconActiveColor: kPrimaryColor,
              textColor: kPrimaryColor,
              icon: Icons.local_activity,
              text: 'Explore',
            ),
            GButton(
              backgroundColor: searchLightColor,
              iconActiveColor: searchColor,
              textColor: searchColor,
              icon: Icons.map,
              text: 'Map',
            ),
            GButton(
              backgroundColor: profileLightColor,
              iconActiveColor: profileColor,
              textColor: profileColor,
              icon: Icons.event_note,
              text: "Events",
            ),
            GButton(
              backgroundColor: myEventLightColor,
              iconActiveColor: myEventColor,
              textColor: myEventColor,
              icon: Icons.person,
              text: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
