import 'package:flutter/material.dart';
import 'package:google_keep_notes/ArchiveView.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:google_keep_notes/services/auth.dart';
import 'package:google_keep_notes/services/db.dart';
import 'package:google_keep_notes/services/localdb.dart';

import 'Settings.dart';
import 'login.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(color: Colors.black87),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Text(
                "Google Keep",
                style: TextStyle(color: white, fontSize: 25),
              ),
            ),
            Divider(
              color: white.withOpacity(0.3),
            ),
            sectionOne(),
            SizedBox(
              height: 5,
            ),
            sectionSettings(),
            SizedBox(
              height: 5,
            ),
            sectionTwo(),
          ],
        )),
      ),
    );
  }

  Widget sectionOne() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  Colors.orangeAccent.withOpacity(0.3)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50)),
              ))),
          onPressed: () {},
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  size: 25,
                  color: white.withOpacity(0.7),
                ),
                SizedBox(
                  width: 27,
                ),
                Text(
                  "Notes",
                  style: TextStyle(
                    color: white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget sectionTwo() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50)),
          ))),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    actionsPadding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: cardColor,
                    title: Text(
                      "Logout",
                      style: TextStyle(color: white),
                    ),
                    content: Text(
                      "Are you sure you want to logout?",
                      style: TextStyle(color: white),
                    ),
                    actions: [
                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.cancel_outlined,
                            color: white,
                          )),
                      InkWell(
                          onTap: () async {
                            signOut();
                            await LocalDataSaver.saveLoginData(false);
                            await NotesDatabase.instance.deleteSQLDB();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                          },
                          child: Icon(
                            Icons.done,
                            color: white,
                          )),
                    ],
                  );
                });
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  size: 25,
                  color: white.withOpacity(0.7),
                ),
                SizedBox(
                  width: 27,
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                    color: white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget sectionSettings() {
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50),
                bottomRight: Radius.circular(50)),
          ))),
          onPressed: () async {
            var sync = false;
            await LocalDataSaver.getSyncSet().then((value) {
              sync = value!;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Settings(
                          value: sync,
                        )));
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Icon(
                  Icons.settings_outlined,
                  size: 25,
                  color: white.withOpacity(0.7),
                ),
                SizedBox(
                  width: 27,
                ),
                Text(
                  "Settings",
                  style: TextStyle(
                    color: white.withOpacity(0.7),
                    fontSize: 18,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
