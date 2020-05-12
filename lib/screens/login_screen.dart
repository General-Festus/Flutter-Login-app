import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login_app/color/color.dart';
import 'package:login_app/screens/email_signup.dart';
import 'package:login_app/screens/phone_signin.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(bottom: 80),
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:80),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0x4400F580),
                    blurRadius: 30,
                    offset: Offset(10, 10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Image(
                image: AssetImage('assets/login_logo5.png'),
                width: 200,
                height: 200,
              ),
            ),
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
                _signIn();
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
                    'Login With Email',
                    style: TextStyle(
                      color:Colors.white,
                    ),
                    ),
                ),
                ),
            ),
            FlatButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => EmailSignup()
              ),);
            },
             child: Text('Signup using Email'),
             ),
             Wrap(children: <Widget>[
               FlatButton.icon(
                 onPressed: (){
                   _signInUsingGoogle();
                 }, 
                 icon: Icon(FontAwesomeIcons.google, color: Colors.red,), 
                 label: Text('Sig-in Using Gmail',
                 style: TextStyle(color:Colors.red),
                 ),
                 ),
                 FlatButton.icon(
                 onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PhoneSignin(),
              ),); 
                 }, 
                 icon: Icon(Icons.phone, color: Colors.blue,), 
                 label: Text('Sig-in Using Phone',
                 style: TextStyle(color: Colors.blue),
                 ),
                 ),
             ],
             ),
          ],
        ),    
      ),
    );
  }

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;
   

    if (email.isNotEmpty && password.isNotEmpty) {
       _auth.signInWithEmailAndPassword(
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
          title: Text('Done'),
          content: Text('Sign in success'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
            }, child: Text('Cancel'),
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
            }, child: Text('Cancel'),
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
          content: Text('Please Provide email and password...'),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
            }, child: Text('Cancel'),
            ),
            FlatButton(
              onPressed: (){
              _emailController.text = "";
              _passwordController.text ="";
              Navigator.of(context).pop();
            }, child: Text('Ok'),
            ),
          ],
        );
      });
    } 
    }
void _signInUsingGoogle() async {
  try {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print("signed in " + user.displayName);

  if(user !=null) {
     _db.collection('users').document(user.uid).setData({
           'displayName': user.displayName,
           'email': user.email,
           'photoUrl': user.photoUrl,
           'lastseen': DateTime.now(),
           'signin_method': user.providerId,
         });
  }

  } catch (e) {
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
            }, child: Text('Cancel'),
            ),
          ],
        );
     });
    }
}
}