import 'package:flutter/material.dart';
import 'package:keeper/boxes/Boxes.dart';
import 'package:keeper/model/KeeperModel.dart';
import 'package:keeper/theme/ThemeModel.dart';
import 'package:keeper/utilities/NoteCard.dart';
import 'package:keeper/utilities/WriteNote.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Keeper extends StatefulWidget {
  const Keeper ({Key? key}) : super(key: key);

  @override
  _KeeperState createState() => _KeeperState();
}

class _KeeperState extends State<Keeper> {

  bool isDarkMode = false;
  bool newDataFirst = true;

  @override
  void initState() {
    super.initState();
    _getTheme();
  }

  _getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('isDarkMode')) {
      var isDark = prefs.getBool('isDarkMode');
      setState(() {
        isDarkMode = isDark!;
      });
    }

  }


  @override
  dispose(){
    Hive.close();
    super.dispose();
  }


  Widget buildContent (List<KeeperModel> keeper){
    if(keeper.isEmpty){
      return Center(child: Text('Add Note'),);
    }
    else{
      var getCount = MediaQuery.of(context).size.width / 220;
      var reverseKeeper = new List.from(keeper.reversed);

      return OrientationBuilder(
          builder: (context, orientation) =>
              GridView.count(
                crossAxisCount: getCount.toInt(),
                children: new List.generate(newDataFirst ? reverseKeeper.length  :keeper.length, (index) =>
                    NoteCard(note: newDataFirst ? reverseKeeper[index] : keeper[index])),

              )
      );

    }

  }


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themeNotifier, child){
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(5.0),
            child: ValueListenableBuilder<Box<KeeperModel>>(
                valueListenable: Boxes.getNote().listenable(),
                builder: (context, box, _) {
                  final note = box.values.toList().cast<KeeperModel>();

                  return buildContent(note);
                }),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            onPressed: (){

              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) => new WriteNote(), fullscreenDialog: true));

            },
            child: Icon(Icons.add, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BottomAppBar(
            clipBehavior: Clip.antiAlias,
            color: Theme.of(context).accentColor,
            elevation: 6.0,
            shape: CircularNotchedRectangle(),
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:Container(
                        height: 50,
                        padding: EdgeInsets.all(5.0),
                        child : Row(
                          children: [

                            GestureDetector(
                                onTap: (){},
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0, right: 25.0),

                                  child: Row(
                                    children: [
                                      Text('Keeper', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                )
                            ),

                            SizedBox(width: 50.0,),
                            themeNotifier.isDark ? ElevatedButton.icon(
                              onPressed: () async {
                                themeNotifier.isDark
                                    ? themeNotifier.isDark = false
                                    : themeNotifier.isDark = true;
                              },
                              icon: Icon(Icons.light),
                              label: Text('LIGHT'),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)
                                  )
                              ) ,


                            ) :  ElevatedButton.icon(
                              onPressed: () async {
                                themeNotifier.isDark
                                    ? themeNotifier.isDark = false
                                    : themeNotifier.isDark = true;
                              },
                              icon: Icon(Icons.dark_mode),
                              label: Text('DARK'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)
                                  )
                              ) ,


                            ),
                            SizedBox(width: 20.0),

                            ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  newDataFirst = !newDataFirst;
                                });
                              },

                              child: Text( newDataFirst ? 'SORT BY OLD' : 'SORT BY NEW'),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepPurpleAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0)
                                  )
                              ) ,


                            ),

                          ],
                        )
                    )
                );

              },

            ),
          ),
        );
      },
    );


  }
}
