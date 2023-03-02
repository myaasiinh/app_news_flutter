import 'package:flutter/material.dart';

class AddNews extends StatefulWidget {
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextFormField(
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Content',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ),
        MaterialButton(
          color: Colors.blue,
          child: Text(
            'Submit Add News',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {},
        ),
      ],
    )
    );
  }
}
