import 'package:flutter/material.dart';
import 'package:google_keep_notes/CreateNote.dart';
import 'package:google_keep_notes/EditNoteView.dart';
import 'package:google_keep_notes/NoteView.dart';
import 'package:google_keep_notes/SideMenuBar.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_notes/services/db.dart';
import 'package:google_keep_notes/services/localdb.dart';

import 'Models/MyNoteModel.dart';
import 'SearchPage.dart';

class ArchiveView extends StatefulWidget {
  const ArchiveView({super.key});

  @override
  State<ArchiveView> createState() => _ArchiveViewState();
}

class _ArchiveViewState extends State<ArchiveView> {
  late List<Note> notesList;
  bool isLoading = true;

  Future getAllNotes() async {
    this.notesList = await NotesDatabase.instance.readAllNotes();
    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String note1 = "THIS IS SMALL NOTE BOYS";
  String bigNote =
      "NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE NOTE THIS IS NOTE";
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: cardColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateNote()));
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
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            color: white,
                          ),
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Container(
                          height: 55,
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
              notesSectionAll(),
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
        itemCount: 10,
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
                                note: null,
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "HEADING",
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
                        index % 2 == 0
                            ? bigNote.length > 250
                                ? "${bigNote.substring(0, 250)}..."
                                : bigNote
                            : note1,
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
