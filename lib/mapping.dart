import 'package:flutter/material.dart';
import 'login_register.dart';
import 'home_page.dart';
import 'authentication.dart';

class MappingPage extends StatefulWidget {
  MappingPage({this.auth});

  final Authentication auth;
  @override
  State<StatefulWidget> createState() => _MappingPageState();
}

enum AuthStatus { signedIn, notSignedIn }

class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    try {
      widget.auth.getCurrentUser().then((firebaseUserId) {
        setState(() {
          authStatus = (firebaseUserId == null)
              ? AuthStatus.notSignedIn
              : AuthStatus.signedIn;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.signedIn:
        return HomePage(auth: widget.auth, onSignedOut: _signedOut);
        break;
      case AuthStatus.notSignedIn:
        return LoginRegisterPage(auth: widget.auth, onSignedIn: _signedIn);
    }
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }
}
