import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_app/color/color.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   

  final Firestore _db =Firestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;

  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 300,),
      child: Center(child: Column(children: <Widget>[
        Text('Home Screen',
        style: TextStyle(
          color: primaryColor,
          fontSize: 24,
        ),
        ),
        SizedBox(height:30),
        RaisedButton(
          child: Text('SignOut'),
          color: primaryColor,
          onPressed: () {
          FirebaseAuth.instance.signOut();
          
        }),
      ],
      ),
      ),
      );

  }
}