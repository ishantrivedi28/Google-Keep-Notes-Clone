import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:google_keep_notes/home.dart';
import 'package:google_keep_notes/services/auth.dart';
import 'package:google_keep_notes/services/db.dart';
import 'package:google_keep_notes/services/firestore_db.dart';
import 'package:google_keep_notes/services/localdb.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 150,
              backgroundImage: AssetImage('assets/keep.png'),
            ),

            //   // color: Colors.blue,
            // ),
            // Container(
            //   margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            //   child: ClipOval(
            //     child: Image.asset(
            //       'assets/keep.png',
            //       fit: BoxFit.cover,
            //       width: MediaQuery.of(context).size.height / 2.5,
            //       height: MediaQuery.of(context).size.height / 2.5,
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Welcome to Google Keep Notes",
                style: TextStyle(
                    color: white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SignInButton(Buttons.GoogleDark, onPressed: () async {
              await signInWithGoogle();

              final User? currentUser = await _auth.currentUser;
              try {
                LocalDataSaver.saveLoginData(true);
                LocalDataSaver.saveImg(currentUser!.photoURL.toString());
                LocalDataSaver.saveName(currentUser.displayName.toString());
                LocalDataSaver.saveMail(currentUser.email.toString());
                LocalDataSaver.saveSyncSet(true);
              } catch (e) {
                print(e);
              }
              await FireDB().getAllNotesFirestore();
              await NotesDatabase.instance.database;
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Home()));
            }),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "By Continuing, You Agree With Our TnC",
                style: TextStyle(
                    color: white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
