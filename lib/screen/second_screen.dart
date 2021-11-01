import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/auth_page.dart';
import 'package:meme_app/constants.dart';
import 'package:meme_app/editmeme.dart';
import 'package:meme_app/meme_data.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
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
      body: GridView.builder(
        itemCount: memeName.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (ctx, i) => GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return EditMeme(imageName: memeName[i]);
              },
            ));
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/meme/${memeName[i]}.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
