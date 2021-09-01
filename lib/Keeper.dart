import 'package:flutter/material.dart';
import 'package:keeper/theme/ThemeModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Keeper extends StatefulWidget {
  const Keeper ({Key? key}) : super(key: key);

  @override
  _KeeperState createState() => _KeeperState();
}

class _KeeperState extends State<Keeper> {

  bool isDarkMode = false;

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
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ThemeModel themeNotifier, child){
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(5.0),
            child: Text(themeNotifier.isDark ? "Dark Mode" : "Light Mode"),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).accentColor,
            onPressed: (){},
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
                          height: 60,
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


                              )
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
