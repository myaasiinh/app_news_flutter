// ignore: file_names
import 'dart:io';
import 'package:app_news/constant/constantFile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';


class AddNews extends StatefulWidget {
  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {

      // ignore: avoid_init_to_null
    File? _imageFile;
    late String title, content, description, id_users;

    final _key = GlobalKey<FormState>();
    bool isUploading = false;

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

    check() async {
      final form = _key.currentState;
      if (form!.validate()) {
        form.save();
        await getPref(); // <-- update the id_users value here
        uploadData();
      }
        }
    uploadData() async {
      try {
        var formData;
        if (_imageFile != null) {
          formData = FormData.fromMap({
            'image': await MultipartFile.fromFile(_imageFile!.path),
            'title': title,
            'content': content,
            'description': description,
            'id_users': id_users,
          });
        } else {
          formData = FormData.fromMap({
            'title': title,
            'content': content,
            'description': description,
            'id_users': id_users,
          });
        }

        setState(() {
          isUploading = true;
        });

        var response = await Dio().post(BaseUrl.addnews, data: formData);

        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: 'News added successfully!');
          print('Image Uploaded');
          setState(() {
            isUploading = false;
            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(msg: 'Failed to add news');
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
                  onPressed: isUploading
                      ? null
                      : () {
                          if (!isUploading) {
                            isUploading = true;
                            setState(() {}); // to re-build the UI and disable the button
                            check();
                          }
                        },
                  disabledColor: Colors.grey,
                  disabledTextColor: Colors.white,
                  disabledElevation: 0,
                )

              // to disable the button while uploading
          ],
        ),
      )
    );
  }
}

