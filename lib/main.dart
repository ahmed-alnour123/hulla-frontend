// ignore_for_file: prefer_const_constructors

import 'dart:js';

import 'package:flutter/material.dart';
import 'package:hulla/model/user_model.dart';
import 'package:hulla/view/login_screen.dart';

import 'model/records_model.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'home',
    routes: {'login': (context) => LoginScreen(), 'home': (context) => Home()},
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User selectedStudent = students[0];
  String str = '';
  bool _loading = false;
  DateTime selectedDate = DateTime.now();
  DateTimeRange? dateTimeRange;
  Future<DateTimeRange?> _selectDate(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        currentDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(str),
        ),
        body: Stack(children: [
          Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DropdownButton<User>(
                        value: selectedStudent,
                        items: students.map((User value) {
                          return DropdownMenuItem<User>(
                            value: value,
                            child: Text(value.name),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            selectedStudent = _!;
                          });
                        },
                      ),
                      IconButton(
                          onPressed: () async {
                            dateTimeRange = await _selectDate(context);
                          },
                          icon: Icon(Icons.date_range)),
                      ElevatedButton(
                          onPressed: () {
                            if (dateTimeRange != null) {
                              //require data
                              setState(() {
                                str =
                                    "${dateFormat(dateTimeRange?.start)}  ${dateTimeRange?.end.toString()} wana wana tsundere ${selectedStudent.name}";
                              });
                            }
                          },
                          child: Text('Generate'))
                    ],
                  )),
              Divider(
                height: 10,
                thickness: 2,
              ),
              Expanded(
                  flex: 8,
                  child: ListView.builder(
                      itemCount: records?.length,
                      itemBuilder: ((context, index) {
                        return Card(
                            child: ListTile(
                          subtitle: Text(
                              " ${intToGrade(records?[index].grade)} - (${records?[index].end}) <=(${records?[index].start}) ${intToSura(records?[index].sura)} - ${records?[index].date}"),
                          trailing: Row(
                            children: [
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.edit)),
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.delete))
                            ],
                          ),
                        ));
                      })))
            ],
          ),
          if (_loading)
            Opacity(
                opacity: .2,
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.grey,
                )),
          if (_loading) Center(child: CircularProgressIndicator())
        ]));
  }
}
