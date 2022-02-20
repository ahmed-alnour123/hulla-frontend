import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

dynamic user;

List<Student> students = [
  Student('asas', 'التكروني'),
  Student('username', 'منذر حافظ')
];

class Teacher {
  final String username;
  final String name;
  final bool isAdmin;

  Teacher(this.username, this.name, this.isAdmin);
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(json['username'], json['name'], json['isAdmin']);
  }
}

class Student {
  final String username;
  final String name;

  Student(this.username, this.name);
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      json['username'],
      json['name'],
    );
  }
}

List<Student> parseUsers(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Student>((json) => Student.fromJson(json)).toList();
}

Future<Student> loginStudent(String username) async {
  try {
    final response = await http.Client().post(Uri.parse(''),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'username': username}));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      students = [Student.fromJson(data)];
      return Student(username, data['name']);
    } else
      return Student('ERROR', 'Wrong username');
  } catch (err) {
    return Student('ERROR', 'connection problem');
  }
}

Future<Teacher> loginTeacher(String username) async {
  try {
    final response = await http.Client().post(Uri.parse(''),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({'username': username}));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      students = parseUsers(data['studentlist']);
      return Teacher(username, data['name'], data["isAdmin"]);
    } else {
      return Teacher('ERROR', 'Wrong username', false);
    }
  } catch (err) {
    return Teacher('ERROR', 'connection problem', false);
  }
}
