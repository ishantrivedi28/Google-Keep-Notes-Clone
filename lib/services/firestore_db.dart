import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_keep_notes/CreateNote.dart';
import 'package:google_keep_notes/Models/MyNoteModel.dart';
import 'package:google_keep_notes/services/db.dart';
import 'package:google_keep_notes/services/localdb.dart';

class FireDB {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  createNewNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("usernotes")
            .doc(note.uniqueId)
            .set({
          "title": note.title,
          "content": note.content,
          "uniqueId": note.uniqueId,
          "createdAt": note.createdTime,
        }).then((_) => print("done"));
      }
    });
  }

  Future getAllNotesFirestore() async {
    final User? current_user = _auth.currentUser;
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(current_user!.email)
        .collection("usernotes")
        .orderBy("createdAt")
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((result) {
              Map note = result.data();
              print(result.data());
              NotesDatabase.instance.insertEntry(Note(
                  pin: false,
                  uniqueId: note["uniqueId"],
                  title: note["title"],
                  content: note["content"],
                  createdTime: note["createdAt"].toDate()));
            }));
  }

  updateNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("usernotes")
            .doc(note.uniqueId.toString())
            .update({
          "Title": note.title.toString(),
          "content": note.content.toString(),
        }).then((_) => print("updated"));
      }
    });
  }

  deleteNoteFirestore(Note note) async {
    LocalDataSaver.getSyncSet().then((isSyncOn) async {
      if (isSyncOn.toString() == "true") {
        final User? current_user = _auth.currentUser;
        await FirebaseFirestore.instance
            .collection("notes")
            .doc(current_user!.email)
            .collection("usernotes")
            .doc(note.uniqueId.toString())
            .delete()
            .then((_) => print("deleeted"));
      }
    });
  }
}
