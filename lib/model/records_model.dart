import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class Record {
  final int? id;
  final String? username;
  final String? grade;
  final int? sura;
  final int? start;
  final int? end;
  final String? date;

  Record(
      {this.id,
      this.username,
      this.grade,
      this.sura,
      this.start,
      this.end,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'grade': grade,
      'sura': sura,
      'start': start,
      'end': end,
      'date': date
    };
  }

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
        id: json['id'],
        username: json['username'],
        grade: json['grade'],
        sura: json['sura'],
        start: json['start'],
        end: json['end'],
        date: json['date']);
  }
}

List<Record> parseRecords(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Record>((json) => Record.fromJson(json)).toList();
}

Future<List<Record>> fetchPosts(
    {required String username, required int start, required int end}) async {
  final response = await http.Client().post(Uri.parse(''),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'username': username, 'start': start, 'end': end}));

  return parseRecords(response.body);
}

Future<Record> addRecord(Record record) async {
  final response = await http.Client().post(Uri.parse(''),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(record.toMap()));
  return Record.fromJson(jsonDecode(response.body));
}

Future<Record> editRecord(Record record) async {
  final response = await http.Client().post(Uri.parse(''),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(record.toMap()));
  return Record.fromJson(jsonDecode(response.body));
}

Future<bool> deleteRecord(int recordID) async {
  final response = await http.Client().post(Uri.parse(''),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'id': recordID}));
  return response.body == 'success';
}

class User {
  final String username;
  final String name;
  final bool isAdmin;

  User(this.username, this.name, this.isAdmin);
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['username'],
      json['name'],
      json['admin'] == 1,
    );
  }
}

Future<User> login(String username) async {
  try {
    final response = await http.Client().post(Uri.parse(''),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'username': username}));
    if (response.statusCode == 200)
      return User.fromJson(jsonDecode(response.body));
    else
      return User('ERROR', 'Wrong username', false);
  } catch (err) {
    return User('ERROR', 'connection problem', false);
  }
}
