
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeper/model/KeeperModel.dart';
import 'package:keeper/utilities/KeeperSnackBar.dart';

class ReadNote extends StatefulWidget {
  final noteData;
  ReadNote ({Key? key, this.noteData}) : super(key: key);

  @override
  _ReadNoteState createState() => _ReadNoteState();
}

class _ReadNoteState extends State<ReadNote> {
  final textController = TextEditingController();
  bool isEdit = false;

  var newDelta;
  var oldDelta;
  var text;

  @override
  initState(){
    super.initState();

    textController.addListener(() {
      setState(() {
        newDelta = textController.text;
      });
    });

    setState(() {
      oldDelta = widget.noteData.noteDelta;
      if(isEdit == false){
        newDelta = oldDelta;
        textController.text = newDelta;
      }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    textController.dispose();
    super.dispose();
  }

  _edit(){
    setState(() {
      isEdit = true;
      newDelta = widget.noteData.noteDelta;
      textController.text = newDelta;
    });
  }

  _closeEdit(){
    setState(() {
      isEdit = false;
      oldDelta = widget.noteData.noteDelta;
      newDelta = oldDelta;
      textController.text = oldDelta;


    });
  }

  _sameDelta(){
    return  newDelta.length == 0 || (newDelta == oldDelta);
  }

  void _editNoteBox(KeeperModel keeper, String noteDelta){
    keeper.noteDelta = noteDelta;
    keeper.save();
  }

  _updateNote() async {
    try{
      _editNoteBox(widget.noteData, newDelta);
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(KeeperSnackBar.errorSnackBar(e.toString(), context, true));

    } finally{
      setState(() {
        isEdit = false;
        oldDelta = newDelta;
        textController.text = newDelta;
        ScaffoldMessenger.of(context).showSnackBar(KeeperSnackBar.successSnackBar('Note Updated', context));


      });
    }

  }

  @override
  Widget build(BuildContext context) {

    print('sameDelta() => ${_sameDelta()}');
    print('newDelta() => $newDelta');



    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: !_sameDelta() ? ()
                {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text('Discard'),
                      content: Text('Are you sure to discard editing?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'OK');
                            _closeEdit();
                          },
                          child: Text('OK', style: TextStyle(color: Colors.red[500]),),
                        ),
                      ],
                    ),
                  );

                }

                    : (){
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15.0)
                ),
                child: Text(DateFormat.yMMMd().add_jms().format(widget.noteData.createdAt),
                  style: TextStyle(fontSize: 13.0),),
              )
            ],
          ),
        ),
      ),
      body: isEdit ? TextField(
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
      ) : Container(
        padding: EdgeInsets.all(5.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(widget.noteData.noteDelta),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: isEdit && _sameDelta() ? _closeEdit : isEdit && !_sameDelta() ? _updateNote :
        _edit,
        child: Icon( isEdit && _sameDelta() ? Icons.close : isEdit && !_sameDelta() ? Icons.save : Icons.edit, color: Colors.white,),
      ),

    );
  }
}
