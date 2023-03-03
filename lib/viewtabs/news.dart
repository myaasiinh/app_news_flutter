import 'package:app_news/viewtabs/addNews.dart';
import 'package:flutter/material.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>  AddNews(),
          ));
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Text('News'),
      ),
    );
  }
}
