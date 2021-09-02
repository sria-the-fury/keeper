

import 'package:flutter/material.dart';

import 'package:keeper/boxes/Boxes.dart';
import 'package:keeper/model/KeeperModel.dart';
import 'package:keeper/utilities/KeeperSnackBar.dart';


class WriteNote extends StatefulWidget {
  const WriteNote ({Key? key}) : super(key: key);

  @override
  _WriteNoteState createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {

  final textController = TextEditingController();
  String diaryText = '';

  Future addNote(String noteDelta, String dayMonthYear, DateTime createdAt) async {
    final keeper = KeeperModel()
      ..noteDelta = noteDelta
      ..dayMonthYear = dayMonthYear
      ..createdAt = createdAt;

    final box = Boxes.getNote();
    box.add(keeper);


  }


  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    textController.addListener(() {
      setState(() {
        diaryText = textController.text;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textController.dispose();
    super.dispose();
  }

  _addNote() async {
    try{
      await addNote(diaryText,
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

    print('diarytext => $diaryText');


    return Scaffold(
      body: TextField(
        controller: textController,
        keyboardType: TextInputType.multiline,
        autofocus: true,
        maxLines: null,

        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          hintText: 'Write your note',
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,

        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: diaryText.length > 1 ? _addNote : (){
          Navigator.of(context).pop();
        },
        child: Icon( diaryText.length > 1 ? Icons.save : Icons.arrow_back_ios_new, color: Colors.white,),
      ),

    );
  }
}
