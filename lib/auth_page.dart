// ignore_for_file: prefer_const_constructors

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meme_app/constants.dart';
import 'package:meme_app/crypto.dart';
import 'package:meme_app/home_page.dart';
import 'package:meme_app/screen/home_screnns.dart';
import 'package:meme_app/selectmeme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'controller/google_login_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

bool _isLoginG = false;

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isShow = false;
  bool _isLogin = false;
  final auth = FirebaseAuth.instance;
  late AnimationController _animationController;
  late Animation<double> _animationTextRotate;
  late FToast fToast;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void setupAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: defaultDuration);
    _animationTextRotate =
        Tween<double>(begin: 0, end: 90).animate(_animationController);
  }

  void updataView() {
    setState(() {
      _isShow = !_isShow;
    });
    _isShow ? _animationController.forward() : _animationController.reverse();
  }

  @override
  void initState() {
    setupAnimation();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // ignore: unused_element
  void _showToast1() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("Complete"),
        ],
      ),
    );

    fToast.showToast(
        child: toast,
        toastDuration: Duration(seconds: 3),
        gravity: ToastGravity.TOP);
  }

  void _showToast2() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.close),
          SizedBox(
            width: 12.0,
          ),
          Text("Fail"),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      toastDuration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _googleSignIn.currentUser;
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Stack(
              children: [
                //Login
                AnimatedPositioned(
                    duration: defaultDuration,
                    width: _size.width * 0.88,
                    height: _size.height,
                    left: _isShow ? -_size.width * 0.76 : 0,
                    child: Container(
                        color: login_bg,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.13),
                          child: Form(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                TextField(
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _email = value.trim();
                                      //print(_email);
                                    });
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: defpaultPadding),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                    ),
                                    onChanged: (value) {
                                      _password = value.trim();
                                      //print(value);
                                    },
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Spacer(flex: 2),
                              ],
                            ),
                          ),
                        ))),
                //Sign up
                AnimatedPositioned(
                    duration: defaultDuration,
                    height: _size.height,
                    width: _size.width * 0.88,
                    left: _isShow ? _size.width * 0.12 : _size.width * 0.88,
                    child: Container(
                      color: signup_bg,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.13),
                        child: Form(
                          child: Column(
                            children: [
                              Spacer(),
                              TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Email",
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _email = value.trim();
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: defpaultPadding),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                  ),
                                  onChanged: (value) {
                                    _password = value.trim();
                                  },
                                ),
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                ),
                                onChanged: (value) {
                                  _confirmPassword = value.trim();
                                },
                              ),
                              Spacer(flex: 2)
                            ],
                          ),
                        ),
                      ),
                    )),
                //Logo
                AnimatedPositioned(
                    duration: defaultDuration,
                    top: _size.height * 0.1,
                    left: 0,
                    right: _isShow ? _size.width * 0.06 : _size.height * 0.06,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white60,
                      child: AnimatedSwitcher(
                        duration: defaultDuration,
                        child: _isShow
                            ? SvgPicture.asset(
                                "assets/icons/dollar.svg",
                                //color: signup_bg,
                              )
                            : SvgPicture.asset(
                                "assets/icons/dollar.svg",
                                //color: login_bg,
                              ),
                      ),
                    )),
                //Sosial
                AnimatedPositioned(
                  duration: defaultDuration,
                  width: _size.width,
                  bottom: _size.height * 0.1,
                  right: _isShow ? -_size.width * 0.06 : _size.width * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          Provider.of<GoogleSignINController>(context,
                                  listen: false)
                              .login();
                        },
                        icon: Image.asset("assets/login/fb1.png"),
                        iconSize: 10,
                      ),
                      IconButton(
                          onPressed: () async {
                            Provider.of<GoogleSignINController>(context,
                                    listen: false)
                                .login();
                            setState(() {});
                          },
                          icon: Image.asset("assets/login/google.png")),
                    ],
                  ),
                ),
                //LoginAnimate
                AnimatedPositioned(
                  duration: defaultDuration,
                  bottom: _isShow ? _size.height / 2 - 80 : _size.height * 0.3,
                  left: _isShow ? 0 : _size.width * 0.44 - 80,
                  child: AnimatedDefaultTextStyle(
                    duration: defaultDuration,
                    style: TextStyle(
                      fontSize: _isShow ? 20 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                    child: Transform.rotate(
                      angle: -_animationTextRotate.value * pi / 180,
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () async {
                          if (_isShow) {
                            updataView();
                          } else {
                            try {
                              await auth.signInWithEmailAndPassword(
                                  email: _email, password: _password);
                              _isLogin = true;
                              _showToast1();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            } on FirebaseAuthException catch (e) {
                              _isLogin = false;
                              print(e.message);
                            }
                            if (_isLogin == false) {
                              _showToast2();
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: defpaultPadding * 0.75),
                          width: 160,
                          child: Text(
                            "Log in".toUpperCase(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //Sign up
                AnimatedPositioned(
                  duration: defaultDuration,
                  bottom: !_isShow ? _size.height / 2 - 80 : _size.height * 0.3,
                  right: _isShow ? _size.width * 0.44 - 80 : 0,
                  child: AnimatedDefaultTextStyle(
                    duration: defaultDuration,
                    style: TextStyle(
                      fontSize: !_isShow ? 20 : 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                    child: Transform.rotate(
                      angle: (90 - _animationTextRotate.value) * pi / 180,
                      alignment: Alignment.topRight,
                      child: InkWell(
                        onTap: () async {
                          if (_isShow) {
                            try {
                              if (_password == _confirmPassword) {
                                await auth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                                _showToast1();
                              } else {
                                _showToast2();
                              }
                            } on FirebaseAuthException catch (e) {
                              print(e.message);
                            }
                          } else {
                            updataView();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: defpaultPadding * 0.75),
                          width: 160,
                          child: Text(
                            "Sign up".toUpperCase(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
