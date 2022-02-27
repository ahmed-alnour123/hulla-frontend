// ignore_for_file: prefer_const_constructors

// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hulla/model/user_model.dart';
import 'package:hulla/view/login_screen.dart';

import 'package:hulla/model/funcs.dart';
import 'package:hulla/model/quran.dart';
import 'package:hulla/model/records_model.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {'/': (context) => LoginScreen(), '/home': (context) => Home()},
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void showSnack(String s) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  Student selectedStudent = students[0];
  String str = '';
  bool _loading = false;
  DateTimeRange? dateTimeRange;
  String _sora = 'الكهف';
  String _date = '';
  String _grade = 'ممتاز';
  int _start = 0;
  int _end = 0;
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();

  void setSora(Function setState, value) {
    setState(() {
      _sora = value;
    });
  }

  void setDate(Function setState, value) {
    setState(() {
      _date = value;
    });
  }

  void setGrade(Function setState, value) {
    setState(() {
      _grade = value;
    });
  }

  void addRecord(value) {
    setState(() {
      records?.add(value);
    });
  }

  void refreshEditRecord(Record value, int index) {
    setState(() {
      records?[index] = (value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(
              height: 16,
              width: 16,
              image: AssetImage("assets/hulla-icon-white.png")),
        ),
        backgroundColor: Color(0xff015b1f),
        centerTitle: true,
        title: Text('${user?.name}'),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                repeat: ImageRepeat.repeat,
                opacity: .15,
                image: AssetImage("assets/background.jpg"))),
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 18, 0),
                child: DropdownButton<Student>(
                  hint: Text('اختر الطالب'),
                  value: selectedStudent,
                  items: students.map((Student value) {
                    
                    return DropdownMenuItem<Student>(
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
              ),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green[900])),
                          onPressed: () async {
                            if (dateTimeRange != null) {
                              //require data
                              setState(() {
                                _loading = true;
                              });
                              if (dateTimeRange?.start != null &&
                                  dateTimeRange?.end != null) {
                                final _records = await fetchRecords(
                                    username: selectedStudent.username,
                                    start: dateFormat(dateTimeRange?.start)
                                        .toString(),
                                    end: dateFormat(dateTimeRange?.end)
                                        .toString());
                                setState(() {
                                  _loading = false;

                                  records = _records;
                                  print(records?[0].id);
                                });
                              }
                            } else {
                              showSnack('حدد الفترة الزمنية لعرض السجلات');
                            }
                          },
                          child: Text('بحث')),
                      SizedBox(
                        width: 36,
                      ),
                      IconButton(
                          iconSize: 36,
                          onPressed: () async {
                            dateTimeRange = await selectDateRange(context);
                          },
                          icon: Icon(Icons.date_range)),
                      Text(
                        ":حدد الفترة المراد البحث فيها ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 18,
                      )
                    ],
                  )),
              Divider(
                indent: 26,
                endIndent: 26,
                height: 10,
                thickness: 2,
              ),
              Expanded(
                  flex: 8,
                  child: ListView.builder(
                      itemCount: records!.length,
                      itemBuilder: ((context, index) {
                        return Card(
                            child: ListTile(
                          title: Text(
                            '${records?[index].date.substring(5).replaceFirst('-', '/')} ',
                            textAlign: TextAlign.end,
                          ),
                          subtitle: Text(
                            " ${sowar[records![index].sura]}     (${records?[index].start}) => (${records?[index].end})       ${grades[records![index].grade]}        ",
                            style: TextStyle(color: Colors.black),
                          ),
                          trailing: (isAdmin)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (context,
                                                        StateSetter setState) {
                                                  return AlertDialog(
                                                    content: Container(
                                                      height: 360,
                                                      width: 80,
                                                      child: ListView(
                                                        children: [
                                                          Text(
                                                            'تعديل سجل',
                                                            textAlign:
                                                                TextAlign.end,
                                                          ),
                                                          Wrap(
                                                              alignment:
                                                                  WrapAlignment
                                                                      .end,
                                                              children: [
                                                                DropdownButton<
                                                                    String>(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerRight,
                                                                  hint: Text(
                                                                      'اختر السورة'),
                                                                  value: _sora,
                                                                  items: sowar
                                                                      .map((String
                                                                          value) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      alignment:
                                                                          Alignment
                                                                              .centerRight,
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (_) {
                                                                    setSora(
                                                                        setState,
                                                                        _);
                                                                  },
                                                                ),
                                                              ]),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () async {
                                                                    final _chosedDate =
                                                                        await selectDate(
                                                                            context);
                                                                    setDate(
                                                                        setState,
                                                                        dateFormat(
                                                                            _chosedDate));
                                                                  },
                                                                  icon: Icon(Icons
                                                                      .date_range)),
                                                              Text(_date)
                                                            ],
                                                          ),
                                                          TextField(
                                                            textAlign:
                                                                TextAlign.end,
                                                            controller:
                                                                _startController,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        ':من'),
                                                          ),
                                                          TextField(
                                                            textAlign:
                                                                TextAlign.end,
                                                            controller:
                                                                _endController,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        ':إلى'),
                                                          ),
                                                          SizedBox(
                                                            height: 16,
                                                          ),
                                                          DropdownButton<
                                                              String>(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            hint:
                                                                Text('التقدير'),
                                                            value: _grade,
                                                            items: grades.map(
                                                                (String value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList(),
                                                            onChanged: (_) {
                                                              setGrade(
                                                                  setState, _);
                                                            },
                                                          ),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_date !=
                                                                        null &&
                                                                    _startController
                                                                            .text !=
                                                                        null &&
                                                                    _endController
                                                                            .text !=
                                                                        null &&
                                                                    _grade !=
                                                                        null &&
                                                                    _sora !=
                                                                        null) {
                                                                  final record = Record(
                                                                      id: records?[index]
                                                                          .id,
                                                                      username:
                                                                          selectedStudent
                                                                              .username,
                                                                      date:
                                                                          _date,
                                                                      start: _startController
                                                                          .text,
                                                                      end: _endController
                                                                          .text,
                                                                      grade: grades
                                                                          .indexOf(
                                                                              _grade),
                                                                      sura: sowar
                                                                          .indexOf(
                                                                              _sora));
                                                                  print(record
                                                                      .id);
                                                                  String
                                                                      response =
                                                                      await editRecord(
                                                                          record);
                                                                  if (response ==
                                                                      'success') {
                                                                    refreshEditRecord(
                                                                        record,
                                                                        index);
                                                                  } else {
                                                                    showSnack(
                                                                        response);
                                                                  }
                                                                } else {
                                                                  showSnack(
                                                                      "fill all the elements.");
                                                                }
                                                              },
                                                              child: Text(
                                                                  'احفظ التعديلات'))
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              });
                                        },
                                        icon: Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            _loading = true;
                                          });
                                          bool isDeleted = await deleteRecord(
                                              records![index].id);
                                          setState(() {
                                            _loading = false;
                                          });

                                          if (isDeleted) {
                                            setState(() {
                                              records?.removeAt(index);
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'connection problem.')));
                                          }
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                )
                              : null,
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
        ]),
      ),
      floatingActionButton: (isAdmin)
          ? FloatingActionButton(
              backgroundColor: Colors.green[700],
              child: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                          builder: (context, StateSetter setState) {
                        return AlertDialog(
                          content: Container(
                            height: 360,
                            width: 80,
                            child: ListView(
                              children: [
                                Text(
                                  'إضافة سجل جديد',
                                  textAlign: TextAlign.end,
                                ),
                                Wrap(alignment: WrapAlignment.end, children: [
                                  DropdownButton<String>(
                                    alignment: Alignment.centerRight,
                                    hint: Text('اختر السورة'),
                                    value: _sora,
                                    items: sowar.map((String value) {
                                      return DropdownMenuItem<String>(
                                        alignment: Alignment.centerRight,
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (_) {
                                      setSora(setState, _);
                                    },
                                  ),
                                ]),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          final _chosedDate =
                                              await selectDate(context);
                                          setDate(setState,
                                              dateFormat(_chosedDate));
                                        },
                                        icon: Icon(Icons.date_range)),
                                    Text(_date)
                                  ],
                                ),
                                TextField(
                                  textAlign: TextAlign.end,
                                  controller: _startController,
                                  decoration: InputDecoration(hintText: ':من'),
                                ),
                                TextField(
                                  textAlign: TextAlign.end,
                                  controller: _endController,
                                  decoration: InputDecoration(hintText: ':إلى'),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                DropdownButton<String>(
                                  alignment: Alignment.centerRight,
                                  hint: Text('التقدير'),
                                  value: _grade,
                                  items: grades.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (_) {
                                    setGrade(setState, _);
                                  },
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (_date != null &&
                                          _startController.text != null &&
                                          _endController.text != null &&
                                          _grade != null &&
                                          _sora != null) {
                                        final record = await addNewRecord(
                                            Record(
                                                username:
                                                    selectedStudent.username,
                                                date: (_date != null)
                                                    ? _date
                                                    : "2022/2/15",
                                                start: _startController.text,
                                                end: _endController.text,
                                                grade: grades.indexOf(_grade),
                                                sura: sowar.indexOf(_sora)));

                                        addRecord(record);
                                      } else {
                                        showSnack("fill all the elements.");
                                      }
                                    },
                                    child: Text('أضف السجل'))
                              ],
                            ),
                          ),
                        );
                      });
                    });
              })
          : null,
    );
  }
}
