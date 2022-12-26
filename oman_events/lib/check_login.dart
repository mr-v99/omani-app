import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oman_events/Screens/Login/login_screen.dart';
import 'package:oman_events/Screens/Welcome/welcome_screen.dart';
import 'package:oman_events/Screens/Home/home.dart';

class CheckLogin extends StatelessWidget {
  const CheckLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return HomePage();
          }
          else{
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
