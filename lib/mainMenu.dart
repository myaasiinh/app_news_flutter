// ignore: file_names
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainMenu extends StatefulWidget {
  
  final VoidCallback signOut;

  // ignore: prefer_const_constructors_in_immutables
  MainMenu({required this.signOut});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  // ignore: unused_field
  String? _username, _email;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _username = preferences.getString("username");
      _email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text('Main Menu'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Username: $_username, \n Email: $_email"
        )
      ),
    );
  }
}