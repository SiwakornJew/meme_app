import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/auth_page.dart';
import 'package:meme_app/constants.dart';
import 'package:meme_app/editmeme.dart';
import 'meme_data.dart';

class SelectMeme extends StatefulWidget {
  const SelectMeme({Key? key}) : super(key: key);

  @override
  _SelectMemeState createState() => _SelectMemeState();
}

class _SelectMemeState extends State<SelectMeme> {
  final auth = FirebaseAuth.instance;
  int item = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: signup_bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: login_bg,
        title: Text(
          'Select Meme',
          style: TextStyle(color: Colors.white70),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.redAccent.shade700,
              size: 40,
            ),
            tooltip: 'Sign Out',
            onPressed: () {
              auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AuthPage()));
            },
          )
        ],
      ),
    );
  }
}
