import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

dynamic user;
bool isAdmin = false;
List<Student> students = [Student('username', 'name')];

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
    final response = await http.Client()
        .post(Uri.parse('https://hulla-firebase.herokuapp.com/login/students'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode({'username': username}));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      students = [Student.fromJson(data)];
      isAdmin = false;
      return Student(username, data['name']);
    } else {
      return Student('ERROR', 'Wrong username');
    }
  } catch (err) {
    return Student('ERROR', "connection problem");
  }
}

Future<Teacher> loginTeacher(String username) async {
  try {
    final response = await http.Client().post(
        Uri.parse('https://hulla-firebase.herokuapp.com/login/teachers'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body: json.encode({'username': username}));
    print(response.body);
    if (response.body[0] == '{') {
      final data = jsonDecode(response.body);

      
      if (!data['studentsList'].isEmpty) {
        students = data['studentsList']
            .map<Student>((s) => Student(s['username'], s['name']))
            .toList();
      }
      isAdmin = true;
      return Teacher(username, data['name'], data["isAdmin"]);
    } else {
      return Teacher('ERROR', 'Wrong username', false);
    }
  } catch (err) {
    return Teacher('ERROR', err.toString(), false);
  }
}
