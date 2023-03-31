import 'package:flutter/material.dart';
import 'package:google_keep_notes/Models/MyNoteModel.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:google_keep_notes/services/db.dart';
import 'package:uuid/uuid.dart';

import 'home.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key});

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  var uuid = Uuid();
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
                await NotesDatabase.instance.insertEntry(Note(
                    uniqueId: uuid.v1(),
                    pin: false,
                    title: title.text,
                    content: content.text,
                    createdTime: DateTime.now()));
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                    (route) => false);
              },
              icon: Icon(Icons.save_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(children: [
            TextField(
              controller: title,
              cursorColor: white,
              style: TextStyle(
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
            Container(
              // height: 300,
              child: TextField(
                minLines: 30,
                controller: content,
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
            )
          ]),
        ),
      ),
    );
  }
}
