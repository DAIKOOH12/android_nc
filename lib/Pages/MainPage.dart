import 'package:english_learning/Pages/Home.dart';
import 'package:english_learning/Pages/TestPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = <Widget>[
    Home(),
    TestPage(),
    Icon(Icons.insights, size: 150)
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: _pages.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedFontSize: 15,
            selectedIconTheme: IconThemeData(color: Colors.yellow, size: 40),
            selectedItemColor: Colors.yellow,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedItemColor: Colors.white,
            unselectedIconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue,
            unselectedLabelStyle: TextStyle(color: Colors.white),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.white), label: 'Trang chủ'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.book, color: Colors.white), label: 'Thi thử'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.insights, color: Colors.white),
                  label: 'Tiến độ'),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
