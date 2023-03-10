import 'dart:convert';

import 'package:app_news/constant/constantFile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  late String username, email, password;

  bool _secureText = true;

  final _key = GlobalKey<FormState>();


  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      register();
      //print('email: $email, password: $password');
    }
  }

  register() async {

     final response = await http.post(Uri.parse(BaseUrl.register),
          body: {
            "username": username,
            "email": email,
            "password": password,
          }
      );

      final data = jsonDecode(response.body);
      int value = data['value'];
      String message = data['message'];
      if (value == 1) {
        Fluttertoast.showToast(
            msg: "Registration Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.black87,
            fontSize: 16.0
        );
        setState(() {
          Navigator.pop(context);
        });
      } else {
        print(message);
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Form(
        key: _key,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'Please insert username';
                  }
                },
                onSaved: (e) => username = e!,
                decoration: InputDecoration(
                  hintText: 'Username',
                ),
              ),
          TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'Please insert username';
                  }
                },
                onSaved: (e) => email = e!,
                decoration: InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextFormField(
                validator: (e) {
                  if (e!.isEmpty) {
                    return 'Please insert password';
                  }
                },
                onSaved: (e) => password = e!,
                obscureText: _secureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: showHide,
                    icon: Icon(_secureText ? Icons.visibility_off : Icons.visibility),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  check();
                },
                child: const Text('Register'),
              ),
        ],
      )
    ),
    );
  }
}
