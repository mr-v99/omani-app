import 'dart:convert';

import 'package:flutter/material.dart';

import 'api.dart';
class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {


  String _movies = '';

  TextEditingController _movieId = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _movieId,
              onChanged: (value){
                _movieId.text = value;
              },
              decoration: const InputDecoration(
                hintText: "Enter movie id"
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () async {
                var url = 'http://10.0.2.2:5000/?Query=${_movieId.text}';
                var data = await getData(url);
                var decodedData = jsonDecode(data);
                _movies='';

                decodedData.forEach((key, value) {
                  _movies = '$_movies id=$key name=$value\n';
                });


                setState(() {
                });

              },
              child: const Text("Get The Recommended Movies"),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Text(_movies),
            )

          ],
        ),
      ),
    );
  }
}
