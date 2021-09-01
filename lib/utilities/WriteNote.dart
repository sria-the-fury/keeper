import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:keeper/boxes/Boxes.dart';
import 'package:keeper/model/KeeperModel.dart';
import 'package:keeper/utilities/KeeperSnackBar.dart';


class WriteNote extends StatefulWidget {
  const WriteNote ({Key? key}) : super(key: key);

  @override
  _WriteNoteState createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {

  QuillController _quillController = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  String diaryText = '';

 Future addNote(String noteDelta, String dayMonthYear, DateTime createdAt) async {
   final keeper = KeeperModel()
       ..noteDelta = noteDelta
       ..dayMonthYear = dayMonthYear
       ..createdAt = createdAt;

   final box = Boxes.getNote();
   box.add(keeper);


 }

 _addNote() async {
   try{
     await addNote(jsonEncode(_quillController.document.toDelta().toJson()),
         '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}', DateTime.now());


   }catch(e){
     ScaffoldMessenger.of(context).showSnackBar(KeeperSnackBar.errorSnackBar(e.toString(), context, true));

   } finally{
     Navigator.of(context).pop();
     ScaffoldMessenger.of(context).showSnackBar(KeeperSnackBar.successSnackBar('Note Added', context));
     
   }
 }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event){
          setState(() {
            diaryText = _quillController.document.toPlainText();
          });
          if (event.data.isControlPressed && event.character == 'b') {
            if (_quillController
                .getSelectionStyle()
                .attributes
                .keys
                .contains('bold')) {
              _quillController
                  .formatSelection(Attribute.clone(Attribute.bold, null));
            } else {
              _quillController.formatSelection(Attribute.bold);
            }
          }
        },
        child: Container(
        padding: EdgeInsets.all(5.0),
        child: QuillEditor(
            controller: _quillController,
            scrollController: ScrollController(),
            scrollable: true,
            focusNode: _focusNode,
            autoFocus: true,
            readOnly: false,
            placeholder: 'Write Note',
            expands: false,
            padding: EdgeInsets.zero,

        ),
      ),
      )
        ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: diaryText.length > 1 ? _addNote : (){
          Navigator.of(context).pop();
        },
        child: Icon( diaryText.length > 1 ? Icons.save : Icons.arrow_back_ios_new, color: Colors.white,),
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
                  alignment: Alignment.center,
                    height: 50,
                    padding: EdgeInsets.only(top:5.0, bottom: 5.0, left: 5.0, right: 80.0),
                    child : QuillToolbar.basic(controller: _quillController, showHistory: false,)
                    )
                );

          },

        ),
      ),
    );
  }
}
