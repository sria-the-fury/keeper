import 'package:flutter/material.dart';
import 'package:keeper/boxes/Boxes.dart';
import 'package:keeper/model/KeeperModel.dart';
import 'package:keeper/theme/ThemeModel.dart';
import 'package:keeper/utilities/NoteCard.dart';
import 'package:keeper/utilities/WriteNote.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
                                onTap: (){

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          title: Container(
                                            padding: EdgeInsets.only(left: 10.0, right: 25.0),

                                            child: Row(
                                              children: [
                                                Container(
                                                  height: 45,
                                                  width: 45,
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context).accentColor,
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black.withOpacity(0.5),
                                                          spreadRadius: 3,
                                                          blurRadius: 5,
                                                          offset: Offset(0, 3),
                                                        )
                                                      ],
                                                      image: DecorationImage(
                                                          image: AssetImage('assets/vocab-keeper.png',),
                                                          fit: BoxFit.scaleDown,
                                                          scale: 1.0
                                                      )
                                                  ),
                                                ),
                                                SizedBox(width: 5.0,),
                                                Text('Keeper', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),)
                                              ],
                                            ),
                                          ),
                                          children: <Widget>[
                                            Container(
                                              alignment: Alignment.topLeft,
                                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text('1. Click on any card to read.'),
                                                  Text('2. Long press/click on any card to delete.'),
                                                  Text('3. Everything is simple, you will figure these out.'),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 20.0,),

                                            Container(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  TextButton(onPressed: () async {
                                                    var gitHubUrl = 'https://github.com/sria-the-fury';
                                                    await canLaunch(gitHubUrl) ? await launch(gitHubUrl) : throw 'Could not launch $gitHubUrl';
                                                  },
                                                      child: Text('SRIA-THE-FURY')
                                                  ),
                                                  SizedBox(width: 20.0,),
                                                  TextButton(onPressed: () async {
                                                    var followUrl = 'https://oasisoneiric.tech/author';
                                                    await canLaunch(followUrl) ? await launch(followUrl) : throw 'Could not launch $followUrl';
                                                  },
                                                      child: Text('FOLLOW')
                                                  ),

                                                ],
                                              ),
                                            )


                                          ],
                                        );
                                      }
                                  );

                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 10.0, right: 25.0),

                                  child: Row(
                                    children: [
                                      Container(
                                        height: 45,
                                        width: 45,
                                        decoration: BoxDecoration(
                                            color: Theme.of(context).accentColor,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.5),
                                                spreadRadius: 3,
                                                blurRadius: 5,
                                                offset: Offset(0, 3),
                                              )
                                            ],
                                            image: DecorationImage(
                                                image: AssetImage('assets/vocab-keeper.png',),
                                                fit: BoxFit.scaleDown,
                                                scale: 1.0
                                            )
                                        ),
                                      ),
                                      SizedBox(width: 5.0,),
                                      Text('Keeper', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),)
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
