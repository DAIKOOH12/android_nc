import 'package:english_learning/Pages/CT_Reading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LuyenThiSkills extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn kĩ năng'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                    'Test your reading skills',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color.fromRGBO(0, 42, 140, 1.0)
                  ),
                ),
                GestureDetector(
                  onTap: (){
                      Navigator.push(context, 
                        CupertinoPageRoute(builder: (context)=>CT_Reading())
                      );
                  },
                  child: Container(
                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue),
                      child: Center(
                        child: ListTile(
                          leading: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 44,
                                minHeight: 44,
                                maxWidth: 200,
                                maxHeight: 200),
                            child: Image.asset('assets/images/reading_icon.jpg',height: 200,),
                          ),
                          title: Text("Cùng luyện tập để cải thiện kĩ năng đọc của bạn nhé!!",
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  'Test your listening skills',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromRGBO(0, 42, 140, 1.0)
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.blue),
                    child: Center(
                      child: ListTile(
                        leading: ConstrainedBox(
                          constraints: BoxConstraints(
                              minWidth: 44,
                              minHeight: 44,
                              maxWidth: 200,
                              maxHeight: 200),
                          child: Image.asset('assets/images/listening_icon.png',height: 200,),
                        ),
                        title: Text("Cùng luyện tập để cải thiện kĩ năng đọc của bạn nhé!!",
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
