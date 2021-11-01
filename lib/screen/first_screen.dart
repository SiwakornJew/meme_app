import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:meme_app/repository/coinCard.dart';
import 'package:meme_app/repository/coinModel.dart';

import '../constants.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Future<List<Coin>> fetchCoin() async {
    coinList = [];
    Timer _time;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: signup_bg,
        appBar: AppBar(
          backgroundColor: login_bg,
          title: Text(
            'CRYPTOPRICE',
            style: TextStyle(
              color: Colors.greenAccent[100],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: coinList.length > 0
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: coinList.length,
                itemBuilder: (context, index) {
                  return CoinCard(
                    name: coinList[index].name,
                    symbol: coinList[index].symbol,
                    imageUrl: coinList[index].imageUrl,
                    price: coinList[index].price.toDouble(),
                    change: coinList[index].change.toDouble(),
                    changePercentage:
                        coinList[index].changePercentage.toDouble(),
                  );
                },
              )
            : SizedBox());
  }
}
