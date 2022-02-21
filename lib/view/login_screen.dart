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
        appBar: AppBar(),
        body: Stack(alignment: Alignment.center, children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'سجل الدخول باستخدام اسم المستخدم',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 60,
              ),
              Center(
                child: Container(
                  child: TextField(
                    controller: controller,
                  ),
                  width: 160,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final username = controller.text;
                        ((setState) {
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
                        ((setState) {
                          _loading = false;
                        });
                      },
                      child: const Text('Login as student')),
                  const SizedBox(
                    width: 16,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final username = controller.text;
                        ((setState) {
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
                        ((setState) {
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
          if (_loading) const Center(child: CircularProgressIndicator())
        ]));
  }
}
