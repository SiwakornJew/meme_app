import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meme_app/constants.dart';
import 'package:meme_app/controller/google_login_controller.dart';
import 'package:meme_app/crypto.dart';
import 'package:meme_app/editmeme.dart';
import 'package:meme_app/screen/screens.dart';
import 'package:meme_app/selectmeme.dart';
import 'auth_page.dart';
import 'home_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textSize = Theme.of(context).textTheme;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignINController(),
          child: AuthPage(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Animation',
        home: AuthPage(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white38,
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.symmetric(
                vertical: defpaultPadding * 1.2, horizontal: defpaultPadding),
          ),
        ),
      ),
    );
  }
}
