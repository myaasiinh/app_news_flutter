import 'dart:convert';
import 'package:app_news/constant/constantFile.dart';
import 'package:app_news/constant/newsModel.dart';
import 'package:app_news/viewtabs/addNews.dart';
import 'package:app_news/viewtabs/editNews.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {

  // ignore: deprecated_member_use
  final list = <NewsModel>[];
  var loading = false;
  
  Future<void> _getNews() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(BaseUrl.getnews));
    if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    data.forEach((api) {
    final ab = NewsModel(
           idNews: api['id_news'],
           image: api['image'],
           title: api['title'],
           content: api['content'],
           description: api['description'],
           dateNews: api['date_news'],
           idUsers: api['id_users'],
           username: api['username'],
         );
         list.add(ab);
       });
       setState(() {
         loading = false;
       });
     }
  }

  _deleteNews(String id_news) async {
    final response = await http.post(Uri.parse(BaseUrl.deletenews), body: {
      "id_news": id_news,
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        _getNews();
      });
    } else {
      print(pesan);
    }
  }

  Future<void> _deleteNewsDialog(String id_news) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete News'),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _deleteNews(id_news);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _getNews();
  }

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
      body: RefreshIndicator(
        onRefresh: () async {
          _getNews();
        },
        child: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                            Image.network(BaseUrl.getnewsimage + x.image, 
                        width: 150, height: 120,
                        fit: BoxFit.fill,),
                        const SizedBox(width: 10,),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(x.title!, style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10,),
                                Text(x.description!, style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10,),
                                  Text(x.dateNews!, style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10,),
                                    Text(x.username!, style: const TextStyle(
                                      fontSize: 14, fontWeight: FontWeight.bold),
                                      ),
                            ],
                          )
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>  EditNews(newsModel: x, reload: _getNews),
                            ));
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                             _deleteNewsDialog(x.idNews!);
                          },
                          icon: const Icon(Icons.delete), )
                        
                          ],                        
                          ),
                          const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                );  
              }
          ),

      )
    );             
  }
}
