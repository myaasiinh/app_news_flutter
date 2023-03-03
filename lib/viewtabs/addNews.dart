import 'dart:io';
import 'package:app_news/constant/constantFile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class AddNews extends StatefulWidget {
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {

  // ignore: avoid_init_to_null
  File? _imageFile;
  late String title, content, description, id_users;

  final _key = GlobalKey<FormState>();

_pilihGambar() async {
  var image = await ImagePicker().pickImage(
    source: ImageSource.gallery, maxWidth: 1000, maxHeight: 1920);
  setState(() {
    if (image != null) {
      _imageFile = File(image.path);
    } else {
      print('No image selected.');
    }
  });
}

check() {
  final form = _key.currentState;
  if (form!.validate()) {
    form.save();
    uploadData();
  }
}
uploadData() async {
  try {
    var uri = Uri.parse(BaseUrl.addnews);
    var request = http.MultipartRequest('POST', uri);
    if (_imageFile != null) {
      var stream = http.ByteStream(_imageFile!.openRead());
      var length = await _imageFile!.length();
      request.files.add(http.MultipartFile(
          'image', stream, length,
          filename: path.basename(_imageFile!.path)));
    }
    request.fields['title'] = title;
    request.fields['content'] = content;
    request.fields['description'] = description;
    request.fields['id_users'] = id_users;
    var response = await request.send();
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'News added successfully!');
      print('Image Uploaded');
      setState(() {
        Navigator.pop(context);
      });
    } else {
      Fluttertoast.showToast(msg: 'Failed to add news');
      print('Image Failed');
    }
  } catch (e) {
    debugPrint('Error $e');
  }
}

    getPref() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        id_users = preferences.getString('id_users')!;
      });
    }

    @override
    void initState() {
      super.initState();
      getPref();
    }


  @override
  Widget build(BuildContext context) {

    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('./image/placeholder.jpg'),
    // ignore: prefer_typing_uninitialized_variables
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Add News'),
      ),
      body: Form(
        key: _key,
            child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            Container(
              width: double.infinity,
              child: InkWell(
                onTap: () {
                  _pilihGambar();
                },
                child: _imageFile == null
                    ? placeholder
                    : Image.file(
                        _imageFile!,
                        width: double.infinity,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          TextFormField(
                onSaved: (e) => title = e!,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            TextFormField(
                onSaved: (e) => content = e!,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            TextFormField(
                onSaved: (e) => description = e!,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            MaterialButton(
              color: Colors.blue,
              child: Text(
                'Submit Add News',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                check();
              },
            ),
          ],
        ),
      )
    );
  }
}
