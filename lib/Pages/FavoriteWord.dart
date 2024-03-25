import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesWord extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_FavoritesWord();
}
class _FavoritesWord extends State<FavoritesWord>{
  final FlutterTts flutterTts = FlutterTts();
  List<String> lstFavorites=[];
  String? user;
  bool isLoading=true;
  Future<void> loadFavorites() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user = pref.getString('auth_token');
      lstFavorites=pref.getStringList(user!+'_Favorites')??[];
    });
    if(lstFavorites.length>0){
      setState(() {
        isLoading=false;
      });
    }
  }
  void speakOut(String text) async {
    await flutterTts.setLanguage('en-EN');
    await flutterTts.setPitch(1.5);
    await flutterTts.speak(text);
  }
  Future<void> deleteFavorite(int index,List<String> lstFavorites) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      user = pref.getString('auth_token');
      pref.setStringList(user!+'_Favorites',lstFavorites);
    });
  }
  @override
  void initState() {
    loadFavorites();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading?Center(child: CircularProgressIndicator()):Scaffold(
      appBar: AppBar(
        title: Text('Favorite Words'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              for(int i=0;i<lstFavorites.length;i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      title: Text(
                        lstFavorites[i].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        lstFavorites[i].toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,3,0,5),
                            child: GestureDetector(
                              onTap: () {
                                lstFavorites.removeAt(i);
                                print(lstFavorites.length);
                                deleteFavorite(i, lstFavorites);
                              },
          
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                                speakOut(lstFavorites[i].toString());
                            },
                            child: Icon(
                              Icons.volume_up_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
}