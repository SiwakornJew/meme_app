import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/constants.dart';
import 'package:meme_app/controller/google_login_controller.dart';
import 'package:provider/provider.dart';

import '../auth_page.dart';
import 'package:meme_app/auth_page.dart';

class ThridScreen extends StatefulWidget {
  const ThridScreen({Key? key}) : super(key: key);

  @override
  _ThridScreenState createState() => _ThridScreenState();
}

class _ThridScreenState extends State<ThridScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Scaffold(
        appBar: AppBar(
          title: Text("Account"),
          backgroundColor: login_bg,
        ),
        body: loginUI());
  }

  loginUI() {
    return Consumer<GoogleSignINController>(
      builder: (context, model, child) {
        return Center(
          child: loggedInUI(model),
        );
      },
    );
  }

  loggedInUI(GoogleSignINController model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(model.googleAccount!.photoUrl ?? '').image,
          radius: 50,
        ),
        Text(model.googleAccount!.displayName ?? ''),
        Text(model.googleAccount!.email),
        ActionChip(
            avatar: Icon(Icons.logout),
            label: Text("Logout"),
            onPressed: () {
              Provider.of<GoogleSignINController>(context, listen: false)
                  .logOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => AuthPage()));
            })
      ],
    );
  }
}
