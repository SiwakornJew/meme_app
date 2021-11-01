// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class EditMeme extends StatefulWidget {
  final String imageName;
  const EditMeme({Key? key, required this.imageName}) : super(key: key);

  @override
  _EditMemeState createState() => _EditMemeState();
}

class _EditMemeState extends State<EditMeme> {
  bool _isEditingText = false;
  //late TextEditingController _editingController1;
  String topText = "Top text";
  String bottomText = "";
  GlobalKey globalKey = new GlobalKey();
  double xTop = 30, yTop = 100, xBot = 30, yBot = 200;
  double fontsize = 20;

  @override
  void initState() {
    super.initState();
    topText = "Top text";
    bottomText = "Bottom text";
    //_editingController1 = TextEditingController(text: topText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Add Text',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          RepaintBoundary(
            key: globalKey,
            child: Stack(
              children: [
                DragTarget<String>(
                  builder: (
                    BuildContext context,
                    List<dynamic> accepted,
                    List<dynamic> reject,
                  ) {
                    return Image.asset(
                      'assets/meme/${widget.imageName}.jpg',
                      //scale: sImage,
                      //width: MediaQuery.of(context).size.width * sImage,
                      //height: MediaQuery.of(context).size.height * sImage,
                      //fit: BoxFit.fill,
                    );
                  },
                  onAcceptWithDetails: (DragTargetDetails<String> details) {
                    print(details.data);
                    print(details.offset);
                    var newX =
                        details.offset.dx - MediaQuery.of(context).padding.left;
                    var newY = details.offset.dy -
                        MediaQuery.of(context).padding.left -
                        AppBar().preferredSize.height;
                    setState(() {
                      if (details.data == 'top') {
                        xTop = newX;
                        yTop = newY;
                      } else if (details.data == 'bottom') {
                        xBot = newX;
                        yBot = newY;
                      }
                    });
                  },
                ),
                Positioned(
                  top: yTop,
                  left: xTop,
                  child: Draggable<String>(
                    data: 'top',
                    child: buildStorkeText(topText, fontsize),
                    feedback: buildStorkeText(topText, fontsize),
                    childWhenDragging: Container(),
                  ),
                ),
                Positioned(
                  top: yBot,
                  left: xBot,
                  child: Draggable<String>(
                    data: 'bottom',
                    child: buildStorkeText(bottomText, fontsize),
                    feedback: buildStorkeText(bottomText, fontsize),
                    childWhenDragging: Container(),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                SizedBox(
                  height: 24,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      topText = value;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    filled: true,
                    fillColor: Color(0xFFF7F7F7),
                    hintText: "Top text",
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      bottomText = value;
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    filled: true,
                    fillColor: Color(0xFFF7F7F7),
                    hintText: "Bottom text",
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    padding: EdgeInsets.all(15),
                    child: TextButton(
                      onPressed: () {
                        //print("+");
                        setState(() {
                          fontsize -= 1;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: Text(
                        '-',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        //print("Export");
                        exportMeme();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: Text(
                        'Export',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: TextButton(
                      onPressed: () {
                        //print("+");
                        setState(() {
                          fontsize += 1;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      child: Text(
                        '+',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }

  Stack buildStorkeText(String text, double fontsize) {
    return Stack(
      children: [
        Text(text,
            style: TextStyle(
              fontSize: fontsize,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = Colors.black,
            )),
        Text(
          text,
          style: TextStyle(
              fontSize: fontsize,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
      ],
    );
  }

  void exportMeme() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();

      final directory = (await getApplicationDocumentsDirectory()).path;

      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
      Uint8List pngByte = byteData.buffer.asUint8List();
      File imageFile = File('$directory/meme.png');
      imageFile.writeAsBytesSync(pngByte);

      Share.shareFiles(['$directory/meme.png']);
    } catch (e) {
      print(e);
    }
  }
}
