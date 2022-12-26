import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oman_events/Screens/Home/home.dart';
import 'dart:io';
import '../../../constants.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String imageUrl = '';
  String imageName = '';

  //Text Editing Controllers
  TextEditingController type = TextEditingController();
  TextEditingController subtype = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController organizer = TextEditingController();
  TextEditingController beneficiars = TextEditingController();
  TextEditingController participants = TextEditingController();
  TextEditingController audiance = TextEditingController();
  TextEditingController locationName = TextEditingController();

  Future addNewEvent() async {
    //to get the user information
    final user = FirebaseAuth.instance.currentUser;

    //add the new event
    await FirebaseFirestore.instance.collection('events').doc().set({
      'id': 0,
      'image': imageUrl,
      'type': type.text,
      'subtype': subtype.text,
      'start date': startDate.text,
      'end date': endDate.text,
      'start time': startTime.text,
      'end time': endDate.text,
      'title': title.text,
      'description': description.text,
      'organizer': organizer.text,
      'beneficiars': beneficiars.text,
      'participants': participants.text,
      'audiance': audiance.text,
      'ticket cost': cost.text,
      'location name': locationName.text,
      'location coord': '',
      'rating': 0,
      'created by': user?.uid
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add new Event",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Times new roman",
                          fontSize: 20,
                          color: Colors.black,
                          decorationColor: Color(0xedffffff)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  elevation: 1,
                  padding: EdgeInsets.all(10),
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (file == null) return;

                    /*Step 2: Upload to Firebase storage*/
                    //Install firebase_storage
                    //Import the library
                    imageName = file.name;

                    //Get a reference to storage root
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('images');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload =
                        referenceDirImages.child('name');

                    //Handle errors/success
                    try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(file.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      //Some error occurred
                    }
                  },
                  color: searchLightColor,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.image,
                        color: searchColor,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text(
                        "Add Event Poster",
                        style: TextStyle(color: searchColor),
                      )
                    ],
                  ),
                ),
                //const SizedBox(height: 5,),
                Text(imageName),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: validate,
                        maxLines: 1,
                        maxLength: 20,
                        controller: type,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          counterText: "",
                          hintStyle: TextStyle(
                              color: searchColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'times'),
                          hintText: "event type",
                          fillColor: searchLightColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        maxLines: 1,
                        maxLength: 20,
                        controller: subtype,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          counterText: "",
                          hintStyle: TextStyle(
                              color: searchColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'times'),
                          hintText: "event subtype",
                          fillColor: searchLightColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: validate,
                        maxLines: 1,
                        maxLength: 20,
                        controller: startDate,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: searchColor,
                          ),
                          counterText: "",
                          hintStyle: TextStyle(
                              color: searchColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'times'),
                          hintText: "Start Date",
                          fillColor: searchLightColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: validate,
                        maxLines: 1,
                        maxLength: 20,
                        controller: endDate,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.calendar_month,
                            color: searchColor,
                          ),
                          counterText: "",
                          hintStyle: TextStyle(
                              color: searchColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'times'),
                          hintText: "end date",
                          fillColor: searchLightColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: validate,
                        maxLines: 1,
                        maxLength: 20,
                        controller: startTime,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: searchColor,
                          ),
                          counterText: "",
                          hintStyle: TextStyle(
                              color: searchColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'times'),
                          hintText: "start time",
                          fillColor: searchLightColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        validator: validate,
                        maxLines: 1,
                        maxLength: 20,
                        controller: endTime,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        cursorColor: kPrimaryColor,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.access_time,
                            color: searchColor,
                          ),
                          counterText: "",
                          hintStyle: TextStyle(
                              color: searchColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'times'),
                          hintText: "end time",
                          fillColor: searchLightColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: validate,
                  maxLines: 1,
                  maxLength: 40,
                  controller: locationName,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    counterText: "",
                    hintStyle: TextStyle(
                        color: searchColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'times'),
                    hintText: "location name",
                    fillColor: searchLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: validate,
                  maxLines: 1,
                  maxLength: 40,
                  controller: title,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    counterText: "",
                    hintStyle: TextStyle(
                        color: searchColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'times'),
                    hintText: "event title",
                    fillColor: searchLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: validate,
                  minLines: 4,
                  maxLength: 400,
                  maxLines: 4,
                  controller: description,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    counterText: "",
                    hintStyle: TextStyle(
                        color: searchColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'times'),
                    hintText: "event description",
                    fillColor: searchLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: validate,
                  maxLines: 1,
                  maxLength: 40,
                  controller: organizer,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: searchColor,
                    ),
                    counterText: "",
                    hintStyle: TextStyle(
                        color: searchColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'times'),
                    hintText: "organizer name",
                    fillColor: searchLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 1,
                  maxLength: 40,
                  controller: beneficiars,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.emoji_people,
                      color: searchColor,
                    ),
                    counterText: "",
                    hintStyle: TextStyle(
                        color: searchColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'times'),
                    hintText: "enter beneficiars",
                    fillColor: searchLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLines: 1,
                  maxLength: 40,
                  controller: participants,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_add,
                      color: searchColor,
                    ),
                    counterText: "",
                    hintStyle: TextStyle(
                        color: searchColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'times'),
                    hintText: "enter participants",
                    fillColor: searchLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: validate,
                  maxLines: 1,
                  maxLength: 40,
                  controller: audiance,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.people,
                      color: searchColor,
                    ),
                    counterText: "",
                    hintStyle: TextStyle(
                        color: searchColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'times'),
                    hintText: "enter allowed audiance age",
                    fillColor: searchLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: validate,
                  maxLines: 1,
                  maxLength: 40,
                  controller: cost,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  cursorColor: kPrimaryColor,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.monetization_on,
                      color: searchColor,
                    ),
                    counterText: "",
                    hintStyle: TextStyle(
                        color: searchColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'times'),
                    hintText: "enter the ticket price",
                    fillColor: searchLightColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      try {
                        addNewEvent();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomePage();
                            },
                          ),
                        );
                      } catch (error) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              "There wan an error. Please try again later."),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 45),
                    decoration: BoxDecoration(
                        color: searchColor,
                        borderRadius: BorderRadius.circular(30)),
                    child: const Text(
                      "Publish the event",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'times',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String? validate(String? value) {
  if (value == null || value.isEmpty) {
    return 'this field is required.';
  }

  return null;
}
