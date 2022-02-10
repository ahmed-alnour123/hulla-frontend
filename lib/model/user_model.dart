import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

User? user;

late final List<User> students = [User('username', 'name', true),User('abualmun', 'munther', true)];

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
