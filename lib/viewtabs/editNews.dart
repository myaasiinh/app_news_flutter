import 'dart:io';

import 'package:app_news/constant/constantFile.dart';
import 'package:app_news/constant/newsModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditNews extends StatefulWidget {

  final VoidCallback reload;
  final NewsModel newsModel;
  const EditNews({required this.newsModel, required this.reload});

  @override
  _EditNewsState createState() => _EditNewsState();
}

class _EditNewsState extends State<EditNews> {

  final _key = GlobalKey<FormState>();
  

  File? _imageFile;
  late String title, content, description, id_users;
  late TextEditingController txtTitle, txtContent, txtDescription;
  bool isUploading = false;


  _getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id_users = prefs.getString('id_users')!;
    });
    txtTitle = TextEditingController(text: widget.newsModel.title);
    txtContent = TextEditingController(text: widget.newsModel.content);
    txtDescription = TextEditingController(text: widget.newsModel.description);
  }

  _check() async {
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      await _getPref();
      _editNews();
      }
  }

   void _editNews() async {
      try {
        var formData;
        if (_imageFile != null) {
          formData = FormData.fromMap({
            'image': await MultipartFile.fromFile(_imageFile!.path),
            'title': title,
            'content': content,
            'description': description,
            'id_users': id_users,
            'id_news': widget.newsModel.idNews,

          });
        } else {
          formData = FormData.fromMap({
            'title': title,
            'content': content,
            'description': description,
            'id_users': id_users,
            'id_news': widget.newsModel.idNews,
          });
        }

        setState(() {
          isUploading = true;
        });

        var response = await Dio().post(BaseUrl.editnews, data: formData);

        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: 'News Edit successfully!');
          print('Image Uploaded');
          setState(() {
            isUploading = false;
            widget.reload();
            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(msg: 'Failed to edit news');
          print('Image Failed');
          setState(() {
            isUploading = false;
          });
        }
      } catch (e) {
        debugPrint('Error $e');
        setState(() {
          isUploading = false;
        });
      }
    }




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

    @override
    void initState() {
      super.initState();
      _getPref();
      txtTitle = TextEditingController(text: widget.newsModel.title);
      txtContent = TextEditingController(text: widget.newsModel.content);
      txtDescription = TextEditingController(text: widget.newsModel.description);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit News'),
      ),
      body: Form(
        key: _key,
        child: ListView(
        padding: EdgeInsets.all(15),
        children: <Widget>[
          Container(
            width: double.infinity,
            child: InkWell(
              onTap: () {
                _pilihGambar();
              },
              child:  _imageFile == null
                ? Image.network(
                    BaseUrl.getnewsimage + widget.newsModel.image,
          ) : Image.file(_imageFile!, fit: BoxFit.fill),
          
            )),
          TextFormField(
            onSaved: (e) => title = e!,
            controller: txtTitle,
            decoration: InputDecoration(
              hintText: 'Title',
              labelText: 'Title',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          TextFormField(
            onSaved: (e) => content = e!,
            controller: txtContent,
            decoration: InputDecoration(
              hintText: 'Content',
              labelText: 'Content',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          TextFormField(
            onSaved: (e) => description = e!,
            controller: txtDescription,
            decoration: InputDecoration(
              hintText: 'Description',
              labelText: 'Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
             _check();
            },
            child: Text('Submit'),
            color: Colors.blue,
          ),
        ],
      ),
      )
    );
  }
}



