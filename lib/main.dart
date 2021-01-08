import 'package:flutter/material.dart';
import 'authentication.dart';
import 'package:blog_app/mapping.dart';

void main(List<String> args) {
  runApp(BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: ThemeData(primaryColor: Colors.teal),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
