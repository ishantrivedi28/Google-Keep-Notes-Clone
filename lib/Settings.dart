import 'package:flutter/material.dart';
import 'package:google_keep_notes/colors.dart';
import 'package:google_keep_notes/services/localdb.dart';

class Settings extends StatefulWidget {
  bool value;
  Settings({super.key, required this.value});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcolor,
      appBar: AppBar(
        backgroundColor: bgcolor,
        elevation: 0.0,
        title: Text("Settings"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(children: [
          Row(
            children: [
              Text(
                "Sync",
                style: TextStyle(color: white, fontSize: 18),
              ),
              Spacer(),
              Transform.scale(
                scale: 1.3,
                child: Switch.adaptive(
                    value: widget.value,
                    onChanged: (val) async {
                      await LocalDataSaver.saveSyncSet(val);
                      setState(() {
                        widget.value = val;
                      });
                    }),
              )
            ],
          )
        ]),
      ),
    );
  }
}
