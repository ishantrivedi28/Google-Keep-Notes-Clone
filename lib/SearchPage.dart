import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:google_keep_notes/services/db.dart';

import 'Models/MyNoteModel.dart';
import 'NoteView.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: white.withOpacity(0.1)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: white,
                      )),
                  Expanded(
                    child: TextField(
                      onChanged: (value) {},
                      onSubmitted: (value) {
                        setState(() {
                          SearchResults(value.toLowerCase());
                        });
                      },
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Search Your Notes",
                          hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.5))),
                    ),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : notesSectionAll()
          ],
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
        itemCount: SearchResultNotes.length,
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
                                note: SearchResultNotes[index],
                              )));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SearchResultNotes[index]!.title,
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
                        SearchResultNotes[index]!.content.length > 250
                            ? "${SearchResultNotes[index]!.content.substring(0, 250)}..."
                            : SearchResultNotes[index]!.content,
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

  List<int> SearchResultIDs = [];
  List<Note?> SearchResultNotes = [];
  bool isLoading = false;
  void SearchResults(String query) async {
    SearchResultNotes.clear();
    setState(() {
      _isLoading = true;
    });
    final ResultIDs = await NotesDatabase.instance.getNoteString(query);
    List<Note?> SearchResultNotesLocal = [];
    print(ResultIDs.length);
    print(ResultIDs);
    ;
    if (ResultIDs.length != 0) {
      ResultIDs.forEach((element) async {
        final SearchNote = await NotesDatabase.instance.readOneNote(element);
        SearchResultNotesLocal.add(SearchNote);
        setState(() {
          SearchResultNotes.add(SearchNote);
          print(SearchNote);
        });
      });
      _isLoading = false;
    }
  }
}
