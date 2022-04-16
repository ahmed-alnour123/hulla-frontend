import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<Record>? records = [
  // Record(
  //     id: "1",
  //     start: '2',
  //     end: '3',
  //     sura: 1,
  //     grade: 2,
  //     date: '123456789',
  //     username: 'abualm'),
  // Record(
  //     id: "3",
  //     start: '2',
  //     end: '3',
  //     sura: 4,
  //     grade: 2,
  //     date: '2000-06-26',
  //     username: 'abualm')
];

class Record {
  String? id;
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
    {required String username,
    required String start,
    required String end}) async {
  final response = await http.Client().post(
      Uri.parse('https://hulla-firebase-old.herokuapp.com/records'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: json.encode({'username': username, 'start': start, 'end': end}));
  if (response.body != '[]' && response.statusCode == 200)
    return parseRecords(response.body);
  else if (response.body == '[]')
    return [
      Record(
          username: 'username',
          grade: 5,
          sura: 114,
          start: 'X',
          end: 'X',
          date: '        لا سجلات في هذه الفترة')
    ];
  else
    return [
      Record(
          username: 'username',
          grade: 5,
          sura: 114,
          start: 'X',
          end: 'X',
          date: 'حدثت مشكلة في الاتصال')
    ];
}

Future<Record> addNewRecord(Record record) async {
  final response = await http.Client().post(
      Uri.parse('https://hulla-firebase-old.herokuapp.com/records/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: json.encode(record.toMap()));
  String data = response.body.toString();
  record.id = data;
  return record;
}

Future<String> editRecord(Record record) async {
  final response = await http.Client().post(
      Uri.parse('https://hulla-firebase-old.herokuapp.com/records/edit'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json'
      },
      body: json.encode(record.toMap()));
  print(json.encode(record.toMap()));
  return response.body;
}

Future<bool> deleteRecord(String? recordID) async {
  try {
    final response = await http.Client().post(
        Uri.parse('https://hulla-firebase-old.herokuapp.com/records/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: json.encode({'id': recordID}));
    return response.body == 'success';
  } catch (err) {
    return false;
  }
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
