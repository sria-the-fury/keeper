import 'package:flutter/material.dart';

import 'package:flutter_quill/flutter_quill.dart';

class WriteNote extends StatefulWidget {
  const WriteNote ({Key? key}) : super(key: key);

  @override
  _WriteNoteState createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {

  QuillController _quillController = QuillController.basic();
  final FocusNode _focusNode = FocusNode();
  String diaryText = '';


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
    print('diaryText => ${diaryText.length > 1}');

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
            scrollController: ScrollController(),
            scrollable: true,
            focusNode: _focusNode,
            autoFocus: true,
            readOnly: false,
            placeholder: 'Add content',
            expands: false,
            padding: EdgeInsets.zero,

        ),
      ),
      )
        ,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        onPressed: (){
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
