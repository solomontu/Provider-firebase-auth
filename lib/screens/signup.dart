import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider_auth/authServices/userAuth.dart';
import 'package:provider_auth/screens/myHome.dart';

import 'loading.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final provAuth = ProviderAuth();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<ProviderAuth>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: _user.status == Status.authenticating
          ? Loading()
          : Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _email,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value.isNotEmpty) {
                          return null;
                        } else {
                          return 'Provide a valid email';
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8.0),
                    child: TextFormField(
                      controller: _password,
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Provide password';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8.0),
                      child: FlatButton(
                        onPressed: () async {
                          assert(_formKey.currentState.validate());

                          if (!await _user.signup(
                              email: _email.text.trim(),
                              password: _password.text)) {
                            Fluttertoast.showToast(msg: _user.error.toString());
                          }
                          if (_user.error == null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHome()));
                          }
                        },
                        child: Text(
                          'Signup',
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                  InkWell(
                    child: Text(
                      'Back',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      // _user.status = Status.unAuthenticated;
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
    );
  }
}
