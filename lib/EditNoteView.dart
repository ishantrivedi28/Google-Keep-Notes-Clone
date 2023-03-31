import 'package:flutter/material.dart';
import 'package:google_keep_notes/NoteView.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:google_keep_notes/services/db.dart';
import 'Models/MyNoteModel.dart';

class EditNoteView extends StatefulWidget {
  Note? note;
  EditNoteView({required this.note});

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late String newDet;
  late String newTitle;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.newDet = widget.note!.content;
    this.newTitle = widget.note!.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        elevation: 0.0,
        actions: [
          IconButton(
              onPressed: () async {
                Note newNote = Note(
                    uniqueId: widget.note!.uniqueId,
                    pin: false,
                    title: newTitle,
                    content: newDet,
                    createdTime: widget.note!.createdTime,
                    id: widget.note!.id);
                await NotesDatabase.instance.updateNote(newNote);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteView(note: newNote)));
              },
              icon: Icon(Icons.save_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            Form(
              child: TextFormField(
                initialValue: widget.note!.title,
                cursorColor: white,
                onChanged: (value) {
                  newTitle = value;
                },
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: "Title",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.withOpacity(0.8))),
              ),
            ),
            Container(
              // height: 300,
              child: Form(
                child: TextFormField(
                  initialValue: widget.note!.content,
                  onChanged: (value) {
                    newDet = value;
                  },
                  minLines: 30,
                  maxLines: null,
                  cursorColor: white,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 17, color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: "Note",
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.7),
                          fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
