import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
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
  QuillController? _quillController;
  final FocusNode _focusNode = FocusNode();
  bool isEdit = false;

  var newDelta;
  var oldDelta;
  var text;

  @override
  initState(){
    super.initState();
    setState(() {
      oldDelta = widget.noteData.noteDelta;
      if(isEdit == false){
        newDelta = oldDelta;
        _quillController =  QuillController(document: Document.fromJson(jsonDecode(oldDelta)), selection: TextSelection.collapsed(offset: 0));
      }
    });
  }

  _edit(){
    setState(() {
      isEdit = true;
      newDelta = widget.noteData.noteDelta;
      _quillController =  QuillController(document: Document.fromJson(jsonDecode(newDelta)), selection: TextSelection.collapsed(offset: 0));
    });
  }

  _closeEdit(){
    setState(() {
      isEdit = false;
      oldDelta = widget.noteData.noteDelta;
      newDelta = oldDelta;

      _quillController =  QuillController(document: Document.fromJson(jsonDecode(oldDelta)), selection: TextSelection.collapsed(offset: 0));

    });
  }

  _sameDelta(){
    return  newDelta.length == 17 || (newDelta.toString() == oldDelta.toString());
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
        _quillController =  QuillController(document: Document.fromJson(jsonDecode(newDelta)), selection: TextSelection.collapsed(offset: 0));
        ScaffoldMessenger.of(context).showSnackBar(KeeperSnackBar.successSnackBar('Note Updated', context));


      });
    }

  }

  @override
  Widget build(BuildContext context) {



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
      body:
      RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event){
          setState(() {
            text = _quillController!.document.toPlainText();
            newDelta = jsonEncode((_quillController!.document.toDelta().toJson()));
          });
          if (event.data.isControlPressed && event.character == 'b') {
            if (_quillController!
                .getSelectionStyle()
                .attributes
                .keys
                .contains('bold')) {
              _quillController!
                  .formatSelection(Attribute.clone(Attribute.bold, null));
            } else {
              _quillController!.formatSelection(Attribute.bold);
            }
          }
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuillEditor(
              controller: _quillController!,
              scrollController: ScrollController(),
              scrollable: true,
              focusNode: _focusNode,
              autoFocus: isEdit,
              readOnly: !isEdit,
              showCursor: isEdit,
              placeholder: 'Write Note',
              expands: false,
              padding: EdgeInsets.zero,

            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: isEdit && _sameDelta() ? _closeEdit : isEdit && !_sameDelta() ? _updateNote :
        _edit,
        child: Icon( isEdit && _sameDelta() ? Icons.close : isEdit && !_sameDelta() ? Icons.save : Icons.edit, color: Colors.white,),
      ),
      floatingActionButtonLocation: isEdit ? FloatingActionButtonLocation.endDocked : FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Visibility(
        visible: isEdit,
        child: BottomAppBar(
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
                      child : QuillToolbar.basic(controller: _quillController!, showHistory: false,)
                  )
              );

            },

          ),
        ),
      ),
    );
  }
}
