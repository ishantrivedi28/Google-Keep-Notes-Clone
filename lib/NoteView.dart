import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_keep_notes/EditNoteView.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:google_keep_notes/home.dart';
import 'package:google_keep_notes/services/db.dart';

import 'Models/MyNoteModel.dart';

class NoteView extends StatefulWidget {
  Note? note;
  NoteView({required this.note});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  String bigNote =
      "NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        elevation: 0.0,
        actions: [
          IconButton(
              splashRadius: 17,
              onPressed: () async {
                await NotesDatabase.instance.pinNote(widget.note);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(
                  widget.note!.pin ? Icons.push_pin : Icons.push_pin_outlined)),

          ///Enable this after making archive functionality working
          // IconButton(
          //     splashRadius: 17,
          //     onPressed: () {},
          //     icon: Icon(Icons.archive_outlined)),
          IconButton(
              splashRadius: 17,
              onPressed: () async {
                await NotesDatabase.instance.deleteNote(widget.note);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(Icons.delete_forever_outlined)),
          IconButton(
              splashRadius: 17,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditNoteView(note: widget.note)));
              },
              icon: Icon(Icons.edit_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.all(15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
                "Created On ${DateFormat('dd-MM-yyy - kk:mm').format(widget.note!.createdTime)}"),
            Text(
              widget.note!.title,
              style: TextStyle(
                  color: white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.note!.content,
              style: TextStyle(color: white, fontSize: 15),
            )
          ]),
        ),
      ),
    );
  }
}
