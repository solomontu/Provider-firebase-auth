import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_auth/authServices/userAuth.dart';

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _logout = Provider.of<ProviderAuth>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 40,
          ),
        ),
        RaisedButton(
          onPressed: () async {
            await _logout.sigout();
          },
          child: Text('Logout'),
        )
      ],
    );
  }
}
