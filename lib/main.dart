

import 'package:flutter/material.dart';
import 'package:keeper/Keeper.dart';
import 'package:keeper/model/KeeperModel.dart';
import 'package:keeper/theme/ThemeModel.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(KeeperModelAdapter());
  await Hive.openBox<KeeperModel>('keeper');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer(
        builder: (context, ThemeModel themeNotifier, child){
          return  MaterialApp(
                theme: themeNotifier.isDark ? ThemeData.dark().copyWith(
                  accentColor: Colors.black
                ) : ThemeData.light().copyWith(),
              home: Keeper(),
              );
        },
      ),
    );


  }
}
