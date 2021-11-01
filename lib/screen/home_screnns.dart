import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meme_app/constants.dart';
import 'package:meme_app/repository/coinModel.dart';
import 'package:meme_app/screen/first_screen.dart';
import 'package:meme_app/screen/screens.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    final response = await http.get(Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false'));

    if (response.statusCode == 200) {
      List<dynamic> values = [];
      values = json.decode(response.body);
      if (values.length > 0) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coinList.add(Coin.fromJson(map));
          }
        }
        setState(() {
          coinList;
        });
      }
      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  late Timer _time;
  @override
  void initState() {
    fetchCoin();
    _time = new Timer.periodic(Duration(seconds: 10), (timer) => fetchCoin());
    super.initState();
  }

  @override
  void dispose() {
    _time.cancel();
    super.dispose();
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _screenList = [
    FirstScreen(),
    SecondScreen(),
    ThridScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screenList[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: login_bg,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/BTC_logo.png",
                width: 24,
                height: 24,
              ),
              label: 'Bitcoins',
              backgroundColor: Colors.black,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.crop_original),
              label: 'Meme',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                "assets/icons/account.png",
                width: 24,
                height: 24,
              ),
              label: 'Account',
            )
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber.shade800,
          onTap: _onItemTapped,
        ));
  }
}
