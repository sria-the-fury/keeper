import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as Widgets;
import 'package:flutter_quill/flutter_quill.dart';

class WriteNote extends StatefulWidget {
  const WriteNote ({Key? key}) : super(key: key);

  @override
  _WriteNoteState createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {

  QuillController _quillController = QuillController.basic();
  String diaryText = '';

  // @override
  // void initState() {
  //   super.initState();
  //   _quillController.addListener(() {
  //     setState(() {
  //       diaryText = _quillController.document.toPlainText();
  //     });
  //   });
  // }
  // //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _quillController
  //   super.dispose();
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      diaryText = _quillController.document.toPlainText();
    });
  }

  @override
  Widget build(BuildContext context) {

    print('quill => ${_quillController.document.toDelta()}');

    return Scaffold(
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (event){
          setState(() {
            diaryText = _quillController.document.toPlainText();
          });
        },
        child: Container(
        padding: EdgeInsets.all(5.0),
        child: QuillEditor(
          controller: _quillController,
          autoFocus: true,
          focusNode: FocusNode(),
          readOnly: false,
          scrollable: true,
          expands: false,
          showCursor: true,

          placeholder: "Write your Note",
          scrollController: ScrollController(),
          padding: EdgeInsets.all(5),

        ),
      ),
      )
        ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: (){
          Navigator.of(context).pop();
        },
        child: Icon(Icons.arrow_back_ios_new, color: Colors.white,),
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
