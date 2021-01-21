import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_auth/authServices/userAuth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider_auth/screens/signup.dart';
import 'package:flutter/widgets.dart';

import 'loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // final provAuth = ProviderAuth.instance();

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
                        }
                        return 'Provide a valid email';
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
                          return 'Provide a valid password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8.0),
                      child: FlatButton(
                        onPressed: () async {
                          assert(_formKey.currentState.validate() == true);
                          if (!await _user.signin(
                              email: _email.text.trim(),
                              password: _password.text))
                            Fluttertoast.showToast(msg: _user.error.toString());
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(fontSize: 20),
                        ),
                      )),
                  InkWell(
                    child: Text('Dont have an account'),
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Signup()));
                    },
                  )
                ],
              ),
            ),
    );
  }
}
