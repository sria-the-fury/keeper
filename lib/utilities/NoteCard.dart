import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:intl/intl.dart';
import 'package:keeper/model/KeeperModel.dart';
import 'package:keeper/utilities/KeeperSnackBar.dart';
import 'package:keeper/utilities/ReadNote.dart';


class NoteCard extends StatefulWidget {
  final note;
  const NoteCard ({Key? key, this.note}) : super(key: key);

  @override
  _NoteCardState createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> {




  Widget bottomLoaderDelete(context) {

    return Container(
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),

      child: Center(
          child:
          ListTile(
              title:  TextButton.icon(
                onPressed: () async{
                  try{
                    deleteNote(widget.note);

                  } catch (e){
                    ScaffoldMessenger.of(context).showSnackBar(KeeperSnackBar.errorSnackBar(e.toString(), context, true));

                  } finally{

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(KeeperSnackBar.errorSnackBar('Note Deleted', context, false));
                  }


                },
                icon: Icon(Icons.delete, color: Colors.red),
                label: Text('wanna delete this? ', style: TextStyle(fontSize: 20.0, color: Colors.red, fontFamily: 'ZillaSlab-Regular'),),
              ),
              subtitle: Text('After deleting, you can\'t get it anymore', textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.withOpacity(0.9)),)
          )
      ),
    );
  }

  void deleteNote(KeeperModel keeper) {

    keeper.delete();
  }

  @override
  Widget build(BuildContext context) {


    QuillController? _quillController = QuillController(document: Document.fromJson(jsonDecode(widget.note.noteDelta)), selection: TextSelection.collapsed(offset: 0));

    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(new MaterialPageRoute<Null>(
            builder: (BuildContext context) => new ReadNote(noteData: widget.note), fullscreenDialog: true));
      },
      onLongPress: (){
        showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(20.0))),
          context: context,
          isDismissible: true,
          builder: (BuildContext context) {
            return bottomLoaderDelete(context);
          },
        );
      },
      child: Container(
          height: 120.0,
          width: 90.0,
          constraints: BoxConstraints(
            minHeight: 120.0, minWidth: 90, maxHeight: 120.0, maxWidth: 90.0,

          ),
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Theme.of(context).accentColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10.0)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(_quillController.document.toPlainText(),overflow: TextOverflow.fade, softWrap: true, maxLines: 11,),
                ),
              ),


              Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0)
                ),
                child: Text(DateFormat.yMMMd().add_jms().format(widget.note.createdAt),
                  style: TextStyle(fontSize: 10.0),),
              )

            ],
          )

      ),
    );
  }
}
