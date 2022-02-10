import 'package:flutter/material.dart';
import 'package:hulla/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController? controller;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: [
          Column(
            children: [
              const Text('data'),
              const SizedBox(
                height: 60,
              ),
              TextField(
                controller: controller,
              ),
              ElevatedButton(
                  onPressed: () async {
                    // try login
                    final username = controller!.text;
                    _loading = true;
                    user = await login(username);
                    _loading = false;
                    if (user?.username != 'ERROR') {
                      Navigator.popAndPushNamed(context, 'home');
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(user!.name)));
                    }
                  },
                  child: const Text('Login'))
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
