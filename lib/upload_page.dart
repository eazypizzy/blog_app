import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'home_page.dart';
import 'dart:io';

import 'package:intl/intl.dart';

class UploadPostPage extends StatefulWidget {
  State createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  File sampleImage;
  String url;
  final _formKey = GlobalKey<FormState>();
  String _description;

  bool validateAndSave() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadPost() async {
    if (validateAndSave()) {
      StorageReference reference =
          FirebaseStorage.instance.ref().child('Blog Images');
      var postTime = DateTime.now();
      StorageUploadTask task =
          reference.child(postTime.toString() + 'jpg ').putFile(sampleImage);
      var imageUrl = await (await task.onComplete).ref.getDownloadURL();
      url = imageUrl.toString();
    }
    saveToDb(url);
  }

  void saveToDb(String url) {
    var dbTimekey = DateTime.now();
    var formatDate = DateFormat('MM, d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaaa');

    String date = formatDate.format(dbTimekey);
    String time = formatTime.format(dbTimekey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var blogdata = {
      'image': url,
      'description': _description,
      'date': date,
      'time': time
    };
    returnToHomePage();
    ref.child('Blog Posts').push().set(blogdata);
  }

  void returnToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }

  Future getImage() async {
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
        centerTitle: true,
      ),
      body: new Center(
        child: sampleImage == null ? Text('select an image') : enableUpload(),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          onPressed: getImage,
          tooltip: 'Add Image',
          child: Icon(Icons.add_a_photo)),
    );
  }

  Widget enableUpload() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(children: <Widget>[
          Image.file(sampleImage, width: 660, height: 330),
          SizedBox(height: 15),
          SizedBox(
              height: 30,
              child: TextFormField(
                decoration: InputDecoration(labelText: 'Blog Description'),
                validator: (value) {
                  return value.isEmpty ? 'description cannot be empty' : null;
                },
                onSaved: (value) {
                  _description = value;
                },
              )),
          SizedBox(height: 15),
          RaisedButton(
            elevation: 10,
            onPressed: uploadPost,
            child: Text('Add Post'),
            color: Colors.teal,
            textColor: Colors.white,
          )
        ]),
      ),
    );
  }
}
