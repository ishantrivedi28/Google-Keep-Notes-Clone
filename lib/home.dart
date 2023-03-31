import 'package:flutter/material.dart';
import 'package:google_keep_notes/CreateNote.dart';
import 'package:google_keep_notes/NoteView.dart';
import 'package:google_keep_notes/SearchPage.dart';
import 'package:google_keep_notes/SideMenuBar.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_notes/services/db.dart';
import 'package:google_keep_notes/services/localdb.dart';
import 'Models/MyNoteModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  late String? ImgUrl;
  bool isStaggered = true;
  List<Note> allNotesList = [];
  List<Note> notesList = [];
  List<Note> pinnedNotesList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAllNotes();
  }

  Future createEntry(Note note) async {
    await NotesDatabase.instance.insertEntry(note);
  }

  Future getAllNotes() async {
    await LocalDataSaver.getImg().then((value) {
      if (this.mounted) {
        setState(() {
          ImgUrl = value;
        });
      }
    });

    allNotesList = await NotesDatabase.instance.readAllNotes();

    for (var note in allNotesList) {
      if (note.pin == false) {
        notesList.add(note);
      }
    }

    for (var e in allNotesList) {
      if (e.pin == true) {
        pinnedNotesList.add(e);
      }
    }
    // print(notesList[0].uniqueId);
    // print(Note.fromJson(notesList[0].toJson()).uniqueId);
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future getOneNote(int id) async {
    await NotesDatabase.instance.readOneNote(id);
  }

  Future updateNote(Note note) async {
    await NotesDatabase.instance.updateNote(note);
  }

  Future delete(Note note) async {
    await NotesDatabase.instance.deleteNote(note);
  }

  // String note1 = "THIS IS SMALL NOTE BOYS";
  // String bigNote =
  //     "NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE";
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            backgroundColor: bgcolor,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              backgroundColor: cardColor,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CreateNote()));
              },
            ),
            endDrawerEnableOpenDragGesture: true,
            key: _drawerKey,
            drawer: SideMenu(),
            backgroundColor: bgcolor,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: 55,
                      decoration: BoxDecoration(
                        color: cardColor,
                        boxShadow: [
                          BoxShadow(
                            color: black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 3,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _drawerKey.currentState!.openDrawer();
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: white,
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchPage()));
                                },
                                child: Container(
                                  height: 55,
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Search Your Notes",
                                        style: TextStyle(
                                          color: white.withOpacity(0.5),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isStaggered = !isStaggered;
                                    });
                                  },
                                  child: Icon(
                                    isStaggered ? Icons.list : Icons.grid_view,
                                    color: white,
                                  ),
                                  style: ButtonStyle(
                                    overlayColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => white.withOpacity(0.1)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                CircleAvatar(
                                  onBackgroundImageError:
                                      (Object, StacktTrace) {
                                    print("ok");
                                  },
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      NetworkImage(ImgUrl.toString()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (pinnedNotesList.isNotEmpty)
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        child: Column(children: [
                          Text(
                            "Pinned",
                            style: TextStyle(
                              color: white.withOpacity(0.5),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ]),
                      ),
                    if (isStaggered)
                      notesSectionPinned()
                    else
                      notesListViewPinned(),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: Column(children: [
                        Text(
                          "All",
                          style: TextStyle(
                            color: white.withOpacity(0.5),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ]),
                    ),
                    isStaggered ? notesSectionAll() : notesListViewAll(),
                  ],
                ),
              ),
            ),
          );
  }

  Widget notesSectionAll() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //   height: MediaQuery.of(context).size.height,
      child: MasonryGridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: notesList.length,
        itemBuilder: ((context, index) => Container(
              decoration: BoxDecoration(
                  border: Border.all(color: white.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(7)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteView(
                                note: notesList[index],
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notesList[index].title,
                        style: TextStyle(
                          color: white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        notesList[index].content.length > 250
                            ? "${notesList[index].content.substring(0, 250)}..."
                            : notesList[index].content,
                        style: TextStyle(color: white, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget notesSectionPinned() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //   height: MediaQuery.of(context).size.height,
      child: MasonryGridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        itemCount: pinnedNotesList.length,
        itemBuilder: ((context, index) => Container(
              decoration: BoxDecoration(
                  border: Border.all(color: white.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(7)),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NoteView(
                                note: pinnedNotesList[index],
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pinnedNotesList[index].title,
                        style: TextStyle(
                          color: white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        pinnedNotesList[index].content.length > 250
                            ? "${pinnedNotesList[index].content.substring(0, 250)}..."
                            : pinnedNotesList[index].content,
                        style: TextStyle(color: white, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget notesListViewAll() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //   height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: notesList.length,
        itemBuilder: ((context, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteView(
                              note: notesList[index],
                            )));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: white.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(7)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notesList[index].title,
                        style: const TextStyle(
                          color: white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        notesList[index].content.length > 250
                            ? "${notesList[index].content.substring(0, 250)}..."
                            : notesList[index].content,
                        style: TextStyle(color: white, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget notesListViewPinned() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //   height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pinnedNotesList.length,
        itemBuilder: ((context, index) => InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NoteView(
                              note: pinnedNotesList[index],
                            )));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: white.withOpacity(0.4)),
                    borderRadius: BorderRadius.circular(7)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pinnedNotesList[index].title,
                        style: const TextStyle(
                          color: white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        pinnedNotesList[index].content.length > 250
                            ? "${pinnedNotesList[index].content.substring(0, 250)}..."
                            : pinnedNotesList[index].content,
                        style: TextStyle(color: white, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
