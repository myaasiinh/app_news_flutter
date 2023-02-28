import 'dart:convert';
import 'package:app_news/mainMenu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



void main() {

  runApp(
      MaterialApp(
        home: Login(),
        debugShowCheckedModeBanner: false,
      ));

}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

enum LoginStatus { notSignIn, signIn }

class _LoginState extends State<Login> {

  LoginStatus _loginStatus = LoginStatus.notSignIn;

  late String email, password;
  final _key =  GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      login();
      //print('email: $email, password: $password');
    }
  }

  login() async {

    final response = await http.post(Uri.parse("http://192.168.1.3/appnew/login.php"),
        body: {
          "email": email,
          "password": password,
        }
    );

    final data = jsonDecode(response.body);
    print(data);

    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value);
      });
      print(message);
    } else {
      print(message);
    }

  }

  savePref(int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt('value', value);
      // ignore: deprecated_member_use
      preferences.commit();
    });
  }

  var value;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt('value');
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {

    switch(_loginStatus) {
      case LoginStatus.notSignIn:

    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16),
            children: <Widget> [
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
                child: Text('Login'),
              ),
            ],
          ),
        )
    );
     break;
      case LoginStatus.signIn:
        return MainMenu();  
    }
  }
}
