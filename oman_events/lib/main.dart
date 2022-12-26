import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oman_events/Screens/Home/components/new_event.dart';
import 'package:oman_events/Screens/Home/home.dart';
import 'package:oman_events/Screens/Welcome/components/welcome_image.dart';
import 'package:oman_events/interests.dart';
import 'package:oman_events/test.dart';
import 'Screens/Welcome/welcome_screen.dart';
import 'check_login.dart';
import 'constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Omani Events',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: const Color(0xedffffff),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: const WelcomeScreen(),
    );
  }
}
