
import 'package:flutter/material.dart';
class theGhiNhoTV extends StatefulWidget {
  const theGhiNhoTV({super.key});

  @override
  State<theGhiNhoTV> createState() => _theGhiNhoTVState();
}

class _theGhiNhoTVState extends State<theGhiNhoTV> {



  double _xPosition = 0; // Vị trí ban đầu


  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;

    return Material(
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Container(
            width: size.width * 0.85,
            height: size.height * 0.8,
            color: Colors.red,
            child: GestureDetector(

              onPanUpdate: (details) {
                setState(() {
                  _offset += details.delta;

                });
              },
              onPanEnd: (details) {
                // Reset offset when dragging ends
                setState(() {
                  _offset = Offset.zero;

                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 2000),
                child: Stack(
                  children: [
                    Positioned(
                      left: _offset.dx,
                      top: _offset.dy,
                      child: Container(
                        width: 300,
                        height: 400,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'Drag Me!',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



}
