import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oman_events/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'api.dart';


class EventScreen extends StatefulWidget {
  final String eid;
  const EventScreen({Key? key, required this.eid}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {

  String _title="";
  String _type = "";
  String _subtype="";
  String _description="";
  String _startDate="";
  String _endDate="";
  String _startTime="";
  String _endTime="";
  String _location="";
  String _coordination="";
  String _organizer="";
  String _participants="";
  String _beneficiars="";
  String _imageURL="";
  String _audiance="";
  String _tickets="";
  String _rating="";
  int _eventId=0;

  //To store the recommended events based on the user choice
  List <int> recommended = [];
  CollectionReference events = FirebaseFirestore.instance.collection('events');

  Future _getEventData() async {
    try{
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eid)
          .get()
          .then((value) {
        _eventId = value['id'];
        _imageURL = value['image'];
        _title = value["title"];
        _type = value["type"];
        _subtype = value['subtype'];
        _description = value['description'];
        _startDate = value['start date'];
        _endDate = value['end date'];
        _startTime = value['start time'];
        _endTime = value['end time'];
        _location = value['location name'];
        _organizer = value['organizer'];
        _participants = value['participants'];
        _beneficiars = value['beneficiars'];
        _audiance = value['audiance'];
        _tickets = value['ticket cost'];
        _rating = value['rating'];
        _coordination = value['location coord'];
      });
    }catch (e){
      print(e);
    }
  }

  _setEventImage(){
    if(_type == 'education'){
      _imageURL = 'assets/eventsImages/education.jpg';
    }
    else if(_type == 'sports'){
      _imageURL = 'assets/eventsImages/sports.jpg';
    }
    else if(_type == 'arts'){
      _imageURL = 'assets/eventsImages/arts.jpg';
    }
    else if(_type == 'entertainment'){
      _imageURL = 'assets/eventsImages/entertainment.png';
    }
    else if(_type == 'social'){
      _imageURL = 'assets/eventsImages/social.jpg';
    }
    else if(_type == 'cultural'){
      _imageURL = 'assets/eventsImages/cultural.png';
    }
    else{
      _imageURL = 'assets/eventsImages/regular.jpg';
    }
  }

  _getRecommendation() async {
    //Send the HTTP request to get the recommended events
    var url = 'http://10.0.2.2:5000/?Query=$_eventId';
    //Wait and Listen for the response
    var data = await getData(url);
    //Process the incoming JSON file
    var decodedData = jsonDecode(data);
    //Add the recommended event to a list to be displayed
    decodedData.forEach((key, value) {
      recommended.add(int.parse(key));
    });
  }

  _isRecommended(int eventId){
    for(int id in recommended){
      if(id == eventId){
        return true;
      }
    }
    return false;
  }
  late List <Icon> stars;
  _setRating(int rank){

    stars = [
      Icon(Icons.star_border,color: Colors.grey,),
      Icon(Icons.star_border,color: Colors.grey,),
      Icon(Icons.star_border,color: Colors.grey,),
      Icon(Icons.star_border,color: Colors.grey,),
      Icon(Icons.star_border,color: Colors.grey,),
    ];

    for(int i=0; i < rank; i++){
      stars[i] = const Icon(Icons.star,color: Colors.yellow,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getEventData(),
        builder: (context,snapshot){
          if (snapshot.connectionState != ConnectionState.done) {
            bool showSpinner = true;
            return ModalProgressHUD(
              inAsyncCall: showSpinner,
              color: kPrimaryColor,
              child: Container(color: Colors.white,),
            );
          }
          _setEventImage();
          return Scaffold(
            appBar: AppBar(
              title: Text(_title,style: const TextStyle(fontSize:18),),
              centerTitle: true,
              backgroundColor: kPrimaryColor,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(_imageURL),
                  Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Event Description",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: kPrimaryColor,fontFamily: 'times'),),
                              IconButton(
                                icon: const Icon(Icons.share,color: kPrimaryColor,),
                                onPressed: (){},
                              )
                            ],
                          ),
                          Text('$_type, $_subtype',style: const TextStyle(fontSize: 12,color: eventsColor,fontFamily: 'times',fontWeight: FontWeight.bold),),
                          SizedBox(height: 15,),
                          Text('$_description.',style: const TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'arial'),),
                          SizedBox(height: 20,),
                          Text("Organizers",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: kPrimaryColor,fontFamily: 'times'),),
                          SizedBox(height: 5,),
                          Text('${' '*5}- $_organizer',style: const TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'arial'),),
                          SizedBox(height: 15,),
                          Text("Participants",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: kPrimaryColor,fontFamily: 'times'),),
                          SizedBox(height: 5,),
                          Text('${' '*5}- $_participants',style: const TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'arial'),),
                          SizedBox(height: 15,),
                          Text("Beneficiars",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: kPrimaryColor,fontFamily: 'times'),),
                          Text('${' '*5}- $_beneficiars',style: const TextStyle(fontSize: 14,color: Colors.black,fontFamily: 'arial'),),

                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: myEventColor,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Event Details',style: const TextStyle(fontSize:16,color: Colors.white,fontFamily: 'times',fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text('$_startDate - $_endDate',style: const TextStyle(color: Colors.white,fontFamily: 'times'),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text('$_startTime - $_endTime',style: const TextStyle(color: Colors.white,fontFamily: 'times'),),
                            ],
                          ),
                          //SizedBox(height: 5,),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Icon(Icons.location_on_outlined,color: Colors.white,),
                                SizedBox(width: 10,),
                                Text(_location,style: const TextStyle(color: Colors.white,fontFamily: 'times'),),
                                SizedBox(width: 50,),
                                TextButton(
                                  onPressed: (){},
                                  child: const Text("Get the directions>>",style: const TextStyle(color: Colors.white,decoration: TextDecoration.underline)),
                                )
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              Icon(Icons.attach_money,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text('$_tickets',style: const TextStyle(color: Colors.white,fontFamily: 'times'),),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Icon(Icons.group,color: Colors.white,),
                              SizedBox(width: 10,),
                              Text('$_audiance',style: const TextStyle(color: Colors.white,fontFamily: 'times'),),
                            ],
                          ),
                        ],
                      ),
                    )
                  ),
                  FutureBuilder(
                    future: _getRecommendation(),
                    builder: (context,snapshot){
                      if(recommended.isNotEmpty){
                        return Container(
                          color: eventsColor,
                          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text("Recommended Events",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.black,fontFamily: 'times'),),
                              SizedBox(height: 20,),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: StreamBuilder(
                                    stream: events.snapshots(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Center(child: Text('Loading'));
                                      }

                                      return Row(
                                        children: snapshot.data!.docs.map((event) {
                                          if(_isRecommended(event['id'])){
                                            _setRating(event['rating']);
                                            _type = event['type'];
                                            _setEventImage();
                                            return MaterialButton(
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return EventScreen(eid: event.id);
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 250,
                                                height: 350,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    color: Colors.white
                                                ),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                                                            image: DecorationImage(
                                                                image: AssetImage(_imageURL),
                                                                fit: BoxFit.cover)
                                                        ),
                                                        height: 120,
                                                      ),
                                                      const SizedBox(height: 8,),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
                                                            Text(event['type'],style: const TextStyle(color: kPrimaryColor,fontWeight: FontWeight.bold),),
                                                            const SizedBox(height: 8,),
                                                            Text(event['title'],style: const TextStyle(fontFamily: "times",fontSize: 16,fontWeight: FontWeight.bold),),
                                                            const SizedBox(height: 8,),
                                                            Row(
                                                              children:  [
                                                                const Icon(Icons.timer_outlined,color: kPrimaryColor,),
                                                                const SizedBox(width: 10,),
                                                                Text('${event['start date']}\n${event['start time']}')
                                                              ],),
                                                            const SizedBox(height: 8,),
                                                            SingleChildScrollView(
                                                              scrollDirection: Axis.horizontal,
                                                              child: Row(
                                                                children:  [
                                                                  const Icon(Icons.map,color: kPrimaryColor,),
                                                                  const SizedBox(width: 10,),
                                                                  Text(event['location name']),
                                                                ],),
                                                            ),
                                                            const SizedBox(height: 8,),
                                                            Row(
                                                              children:  [
                                                                const Icon(Icons.group,color: kPrimaryColor,),
                                                                const SizedBox(width: 10,),
                                                                Text(event['audiance'])
                                                              ],),
                                                            const SizedBox(height: 10,),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children:   [
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
                                                                    Icon(Icons.share,color: kPrimaryColor,),
                                                                    SizedBox(width: 20,),
                                                                    Icon(Icons.favorite_border,color: kPrimaryColor,),
                                                                  ],
                                                                )
                                                              ],),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          else{
                                            return const SizedBox();
                                          }
                                        }).toList(),
                                      );
                                    }),
                              ),

                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  )
                ],
              ),
            ),
          );
        }
    );

  }
}
