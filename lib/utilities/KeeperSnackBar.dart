import 'package:flutter/material.dart';

class KeeperSnackBar {
  static successSnackBar(message, context){

    var width = MediaQuery.of(context).size.width;

    return SnackBar(
      content: Container(

        height:40.0,
        decoration: BoxDecoration(color: Colors.green[500], borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.fromLTRB(700, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(message, style: TextStyle(color: Colors.white) ,)),
        ),
      ), backgroundColor: Colors.transparent, elevation: 1000, behavior: SnackBarBehavior.floating,);
  }

  static errorSnackBar(message, context, isLongText){

    return SnackBar(
      content: Container(

        height:40.0,
        decoration: BoxDecoration(color: Colors.red[500], borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.fromLTRB(isLongText ? 500 : 700, 0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(message, style: TextStyle(color: Colors.white) ,overflow: TextOverflow.fade,)),
        ),
      ), backgroundColor: Colors.transparent, elevation: 1000, behavior: SnackBarBehavior.floating,);
  }

}