import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:login_app/color/color.dart';

class EmailSignup extends StatefulWidget {
  @override
  _EmailSignupState createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Email Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:20),
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: 30
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top:15),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Write Email Here'
                 ),
                 keyboardType: TextInputType.emailAddress,
              ),
            ),
             Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top:10),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Write Password Here'
                 ),
                obscureText: true,
              ),
            ),
            InkWell(
              onTap: () {
                _signup();
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    primaryColor,
                    secondaryColor,
                  ]),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical:20),
                margin: EdgeInsets.symmetric(horizontal: 30, vertical:20),
                child: Center(
                  child: Text(
                    'Sign up using Email',
                    style: TextStyle(
                      color:Colors.white,
                    ),
                    ),
                ),
                ),
            ),
          ],
        ), 
        ),
      ),
    );
  }
  void _signup() {
   final String email = _emailController.text.trim();
   final String password = _passwordController.text;

   if (email.isNotEmpty && password.isNotEmpty) {
     _auth.createUserWithEmailAndPassword(
       email: email, 
       password: password
       ).then((user){

         _db.collection('users').document(user.user.uid).setData({
           'email': email,
           'lastseen': DateTime.now(),
           'signin_method': user.user.providerId,
         });

        showDialog(context: context, builder: (context) {
        return AlertDialog(
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Success'),
          content: Text('Sign Up process done, now you can sign in.'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
            }, child: Text('ok'),
            ),
          ],
        );
        });
       })
       .catchError((e){
       showDialog(context: context, builder: (context) {
        return AlertDialog(
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Error'),
          content: Text('${e.message}'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
            }, child: Text('0k'),
            ),
          ],
        );
     });
    });

   } else {
           showDialog(context: context, builder: (context) {
        return AlertDialog(
          shape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Error'),
          content: Text('Please provide email and password'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
            }, child: Text('Ok'),
            ),
          ],
        );
     });
   }
  }
}