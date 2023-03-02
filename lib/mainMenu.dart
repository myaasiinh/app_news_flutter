// ignore: file_names
import 'package:app_news/viewtabs/category.dart';
import 'package:app_news/viewtabs/home.dart';
import 'package:app_news/viewtabs/news.dart';
import 'package:app_news/viewtabs/profil.dart';
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

    
    return DefaultTabController (
      length: 4,
    child: Scaffold(
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
      body: TabBarView(
        children: <Widget> [
          Home(),
          News(),
          Category(),
          Profil(),
        ] 
        
        //Text("Username: $_username, \n Email: $_email")
      ),
      bottomNavigationBar: TabBar(
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        tabs: <Widget> [
          Tab(
            icon: Icon(Icons.home),
            text: 'Home',
          ),
          Tab(
            icon: Icon(Icons.new_releases),
            text: 'News',
          ),
          Tab(
            icon: Icon(Icons.category),
            text: 'Category',
          ),
          Tab(
            icon: Icon(Icons.perm_contact_calendar),
            text: 'Profile',
          ),
        ],
      )
    )
    );
  }
}