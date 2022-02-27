import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hulla/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();
  bool _loading = false;
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
            centerTitle: true,
            title: Text("حلة الأبرار"),
            backgroundColor: Color(0xff015b1f)),
        body: Container(
           decoration: BoxDecoration(
              image: DecorationImage(
                  repeat: ImageRepeat.repeat,
                  opacity: .15,
                  image: AssetImage("assets/background.jpg"))),
       
          child: Stack(alignment: Alignment.center, children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                    height: 160,
                    width: 160,
                    image: AssetImage("assets/hulla-icon.png")),
                const SizedBox(
                  height: 60,
                ),
                Center(
                  child: Container(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "username", border: OutlineInputBorder()),
                      controller: controller,
                    ),
                    width: 260,
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[900])),
                        onPressed: () async {
                          final username = controller.text;
                          setState(() {
                            _loading = true;
                          });
                          user = await loginStudent(username);

                          print(username);

                          if (user?.username != 'ERROR') {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${user!.name} logged in!')));
                            Navigator.popAndPushNamed(context, '/home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(user!.name)));
                          }
                          setState(() {
                            _loading = false;
                          });
                        },
                        child: const Text('Login as student')),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[900])),
                        onPressed: () async {
                          final username = controller.text;
                          setState(() {
                            _loading = true;
                          });

                          user = await loginTeacher(username);

                          if (user.username != 'ERROR') {
                            print('aaaaaaaaaaaaaaaaaaaaaaaa');
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${user.name} logged in!')));
                            Navigator.popAndPushNamed(context, '/home');
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(content: Text(user.name)));
                          }
                          setState(() {
                            _loading = false;
                          });
                        },
                        child: const Text('Login as admin'))
                  ],
                )
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
        ));
  }
}
