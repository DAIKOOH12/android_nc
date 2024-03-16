
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';


class theGhiNhoTV extends StatefulWidget {
  final List<String> listTu;
  final List<String> listNghia;
  final List<String> listLinkAnh;

  const theGhiNhoTV({super.key, required this.listTu, required this.listNghia, required this.listLinkAnh});

  @override
  State<theGhiNhoTV> createState() => _theGhiNhoTVState();
}

class _theGhiNhoTVState extends State<theGhiNhoTV>
    with TickerProviderStateMixin {
  Offset _offset = Offset.zero;

  Color mauVienThe = Colors.white;

  late FlipCardController _flipCardController;
  late int ind;
  double _opacity = 1.0;

  List<Widget> cachedImages = [];

  void initListCache() {
    for (String i in widget.listLinkAnh) {
      cachedImages.add(CachedNetworkImage(
        imageUrl: i,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ));
    }
  }


  Future<void> loadImage() async {
    try {
      for(String imageUrl in widget.listLinkAnh)
      // load network image example
      await precacheImage(NetworkImage(imageUrl), context);
      // or
      // Load assets image example
      // await precacheImage(AssetImage(imagePath), context);
      print('Image loaded and cached successfully!');
    } catch (e) {
      print('Failed to load and cache the image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _flipCardController = FlipCardController();
    ind = 0;
    // initListCache();
    loadImage();
  }


  Future getListTV() async {
    // final result = await FirebaseFirestore.instance.collection('tuVungTheoCD').
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;

    if (_offset == Offset.zero) {
      _offset = Offset(size.width / 2 - 150, size.height / 2 - 200);
    }

    // print(_offset.dx);

    return Material(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            width: size.width,
            height: size.height,
            color: Colors.grey[100],
            child: GestureDetector(
              onTap: () {
                _flipCardController.toggleCard();
              },
              onPanUpdate: (details) {

                setState(() {
                  _offset += details.delta;
                  print(_offset);
                  if (_offset.dx < 10) {
                    mauVienThe = Colors.orangeAccent;
                  }
                  if (_offset.dx > 50) {
                    mauVienThe = Colors.green;
                  }
                  if(_offset.dx < 50 && _offset.dx > 10) {
                    mauVienThe = Colors.white;
                  }
                });
              },
              onPanEnd: (details) {
                if (_offset.dx > 50) {
                  setState(() {
                    _opacity = 0.0;  // Card mờ dần và biến mất

                  });
                  // Hiển thị lại card sau một khoảng thời gian
                  Future.delayed(Duration(milliseconds: 300), () {
                    setState(() {
                      _opacity = 1.0;  // Card hiện lại
                      ind++;
                    });
                  });
                } else if (_offset.dx < 10) {
                  setState(() {
                    _opacity = 0.0;

                  });
                  Future.delayed(Duration(milliseconds: 300), () {
                    setState(() {
                      _opacity = 1.0;
                      ind++;
                    });
                  });
                }
                if(!_flipCardController.state!.isFront) {

                  _flipCardController.toggleCard();

                }
                // Reset offset when dragging ends
                Future.delayed(Duration(milliseconds: 300), () {
                   setState(() {
                     _offset = Offset.zero;
                   });
                });
                setState(() {

                  mauVienThe = Colors.white;
                });
              },
              child: Stack(
                children: [
                  Positioned(
                    left: _offset.dx,
                    top: _offset.dy,
                    child: FlipCard(
                      controller: _flipCardController,
                      front: AnimatedOpacity(
                        opacity: _opacity,
                        duration: Duration(milliseconds: 300),
                        child: Container(
                            width: 300,
                            height: 400,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: mauVienThe,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 200,
                                    // child: Image.asset('images/facebook.png'),
                                    // child: cachedImages[ind],
                                    child: Image.network(widget.listLinkAnh[ind]),
                                  ),
                                  Text(
                                    widget.listNghia[ind],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                        ),
                      ),
                      back: Container(
                          width: 300,
                          height: 400,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: mauVienThe,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              widget.listTu[ind],
                              style: TextStyle(color: Colors.black),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
