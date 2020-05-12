import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login_app/screens/home_screen.dart';
import 'package:login_app/screens/login_screen.dart';
import 'color/color.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      theme: ThemeData(
        primaryColor: primaryColor,
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
      ),
    );
  }
}
class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
          if(snapshot.hasData) {

            FirebaseUser user = snapshot.data;

            if (user !=null) {
              return HomeScreen();
             
            } else {
              return LoginScreen();
            }
          }
          return LoginScreen();
        },
      ),
    );
  }
}


