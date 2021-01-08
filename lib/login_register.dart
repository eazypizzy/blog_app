import 'package:flutter/material.dart';
import 'authentication.dart';
import 'dialog_box.dart';

class LoginRegisterPage extends StatefulWidget {
  final Authentication auth;
  final VoidCallback onSignedIn;

  LoginRegisterPage({this.auth, this.onSignedIn});

  @override
  State<StatefulWidget> createState() => _LoginRegisterState();
}

enum FormType { login, register }

class _LoginRegisterState extends State<LoginRegisterPage> {
  var dialogBox = DialogBox();
  final formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login;
  String _email = '';
  String _password = '';

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) {
          await widget.auth.signIn(_email, _password);
          dialogBox.information(context, 'Hooray!', 'Sign in successful');
        } else {
          await widget.auth.signUp(_email, _password);
          dialogBox.information(context, 'Hooray!', 'Sign up successful');
        }
        widget.onSignedIn();
      } catch (e) {
        dialogBox.information(context, 'Error', e.toString());
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  //Design
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
      ),
      body: new Container(
        margin: EdgeInsets.all(15),
        child: new Form(
            key: formKey,
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: inputs() + buttons())),
      ),
    );
  }

  List<Widget> inputs() {
    return [
      SizedBox(height: 10),
      logo(),
      SizedBox(height: 70),
      SizedBox(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              return (value.isEmpty) ? 'Email is required!' : null;
            },
            onSaved: (value) {
              _email = value;
            },
          )),
      SizedBox(height: 10),
      SizedBox(
          height: 50,
          child: TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) {
                return (value.isEmpty) ? 'Password is required!' : null;
              },
              onSaved: (value) {
                _password = value;
              }))
    ];
  }

  Widget logo() {
    return Hero(
        tag: 'logo',
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 75.0,
          child: Image.asset('images/app_logo.png'),
        ));
  }

  List<Widget> buttons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          onPressed: validateAndSubmit,
          child: Text(
            'Sign in',
            style: TextStyle(fontSize: 20),
          ),
          textColor: Colors.white,
          color: Colors.teal,
        ),
        RaisedButton(
            onPressed: moveToRegister,
            child: Text(
              'not have an account? click here to sign up ',
              style: TextStyle(fontSize: 15),
            ),
            textColor: Colors.white)
      ];
    } else {
      return [
        RaisedButton(
          onPressed: validateAndSubmit,
          child: Text(
            'Sign up',
            style: TextStyle(fontSize: 20),
          ),
          textColor: Colors.white,
          color: Colors.teal,
        ),
        RaisedButton(
            onPressed: moveToLogin,
            child: Text(
              'Already have an account? click here to sign in',
              style: TextStyle(fontSize: 15),
            ),
            textColor: Colors.white)
      ];
    }
  }
}
