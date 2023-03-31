import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class NotesImpNames {
  static final String id = "id";
  static final String uniqueId = "uniqueId";
  static final String pin = "pin";
  static final String title = "title";
  static final String content = "content";
  static final String createdTime = "createdTime";
  static final String TableName = "Notes";

  static final List<String> values = [
    id,
    pin,
    title,
    content,
    createdTime,
    uniqueId
  ];
}

class Note {
  final int? id;
  final String uniqueId;
  final bool pin;
  final String title;
  final String content;
  final DateTime createdTime;

  Note({
    this.id,
    required this.uniqueId,
    required this.pin,
    required this.title,
    required this.content,
    required this.createdTime,
  });

  Note copy({
    int? id,
    String? uniqueId,
    bool? pin,
    String? title,
    String? content,
    DateTime? createdTime,
  }) {
    return Note(
        id: id ?? this.id,
        uniqueId: uniqueId ?? this.uniqueId,
        pin: pin ?? this.pin,
        title: title ?? this.title,
        content: content ?? this.content,
        createdTime: createdTime ?? this.createdTime);
  }

  static Note fromJson(Map<String, Object?> json) {
    print(json);
    print(json[NotesImpNames.uniqueId]);
    return Note(
        id: json[NotesImpNames.id] as int?,
        uniqueId: json[NotesImpNames.uniqueId] as String,
        pin: json[NotesImpNames.pin] == 1,
        title: json[NotesImpNames.title] as String,
        content: json[NotesImpNames.content] as String,
        createdTime: DateTime.parse(json[NotesImpNames.createdTime] as String));
  }

  Map<String, Object?> toJson() {
    return {
      NotesImpNames.id: id,
      NotesImpNames.uniqueId: uniqueId,
      NotesImpNames.pin: pin,
      NotesImpNames.title: title,
      NotesImpNames.content: content,
      NotesImpNames.createdTime: createdTime.toString(),
    };
  }
}
