import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<Record>? records = [
  Record(
      id: "1",
      start: '2',
      end: '3',
      sura: 1,
      grade: 2,
      date: '123456789',
      username: 'abualm'),Record(
      id: "3",
      start: '2',
      end: '3',
      sura: 4,
      grade: 2,
      date: '2000-06-26',
      username: 'abualm')
];

class Record {
  final String? id;
  final String username;
  final int grade;
  final int sura;
  final String start;
  final String end;
  final String date;

  Record(
      {this.id,
      required this.username,
      required this.grade,
      required this.sura,
      required this.start,
      required this.end,
      required this.date});

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

Future<List<Record>> fetchRecords(
    {required String username, required String start, required String end}) async {
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

Future<bool> deleteRecord(String? recordID) async {
  final response = await http.Client().post(Uri.parse(''),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({'id': recordID}));
  return response.body == 'success';
}

String dateFormat(DateTime? date) {
  return DateFormat('yyyy-MM-dd').format(date!);
}

String intToSura(int? index) {
  switch (index) {
    case 1:
      return 'alfatiha';

      break;
    default:
      return 'ERROR';
  }
}

String intToGrade(int? grade) {
  switch (grade) {
    case 1:
      return 'Good';

      break;
    default:
      return 'ERROR';
  }
}
