import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meme_app/screen/home_screnns.dart';

class GoogleSignINController with ChangeNotifier {
  var _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;
  login() async {
    this.googleAccount = await _googleSignIn.signIn();
    notifyListeners();
    //Navigator.of(context)
    //.pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  logOut() async {
    this.googleAccount = await _googleSignIn.signOut();
    notifyListeners();
  }
}
