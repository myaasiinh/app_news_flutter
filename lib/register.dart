import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

     final response = await http.post(Uri.parse("http://192.168.1.3/appnew/register.php"),
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