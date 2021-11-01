import 'package:flutter/material.dart';
import 'package:meme_app/editmeme.dart';
import 'meme_data.dart';

class SelectMeme1 extends StatefulWidget {
  const SelectMeme1({Key? key}) : super(key: key);

  @override
  _SelectMeme1State createState() => _SelectMeme1State();
}

class _SelectMeme1State extends State<SelectMeme1> {
  int _pageIndex = 0;
  late PageController _pageController;
  int item = 20;
  List<Widget> tabPages = [
    //Screen1(),
    //Screen2(),
    //Screen3(),
  ];
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text(
          'Select Meme',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Wrap(
              spacing: 2,
              runSpacing: 2,
              children: [
                for (var i = 0; i < item; i++)
                  RawMaterialButton(
                    onPressed: () {
                      print(memeName[i]);
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return EditMeme(
                            imageName: memeName[i],
                          );
                        },
                      ));
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 4) / 3,
                      height: (MediaQuery.of(context).size.width - 4) / 3,
                      //color: Colors.red,
                      child: Image.asset(
                        'assets/meme/${memeName[i]}.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ],
            ),
            item < memeName.length
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        if (item + 20 < memeName.length) {
                          item = item + 20;
                        } else {
                          item = memeName.length;
                        }
                      });
                    },
                    child: Text('Load More'),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
