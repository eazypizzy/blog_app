import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'upload_page.dart';
import 'post.dart';

class HomePage extends StatefulWidget {
  final Authentication auth;
  final VoidCallback onSignedOut;

  const HomePage({Key key, this.auth, this.onSignedOut}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> postList = [];

  @override
  void initState() {
    super.initState();
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child('Blog Posts');
    reference.once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var data = snapshot.value;
      postList.clear();
      for (var key in keys) {
        Post post = new Post(
          data[key]['image'],
          data[key]['description'],
          data[key]['date'],
          data[key]['time'],
        );

        postList.add(post);
      }
      setState(() {
        print(postList.length);
      });
    });
  }

  void logout() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
      print('user successfully signed out');
    } catch (e) {
      print('Error is ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: new Container(
          // margin: const EdgeInsets.only(left: 70, right: 70),
          child: postList.length == 0
              ? Text('No Blog Posts')
              : new ListView.builder(
                  itemCount: postList.length,
                  itemBuilder: (_, index) {
                    return postUI(
                        postList[index].image,
                        postList[index].description,
                        postList[index].date,
                        postList[index].time);
                  })),
      bottomNavigationBar: BottomAppBar(
        color: Colors.teal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              iconSize: 30,
              color: Colors.white,
              splashColor: Colors.greenAccent,
              icon: Icon(Icons.departure_board),
              onPressed: logout,
            ),
            IconButton(
              color: Colors.white,
              splashColor: Colors.greenAccent,
              iconSize: 30,
              icon: Icon(Icons.cloud_upload),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UploadPostPage();
                }));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget postUI(String image, String description, String date, String time) {
    return Card(
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Container(
        padding: EdgeInsets.all(14),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(date,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center),
                  Text(time,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center)
                ],
              )),
              SizedBox(height: 10),
              Image.network(image, fit: BoxFit.cover),
              SizedBox(height: 10),
              Text(description,
                  style: Theme.of(context).textTheme.subtitle1,
                  textAlign: TextAlign.center),
            ]),
      ),
    );
  }
}
