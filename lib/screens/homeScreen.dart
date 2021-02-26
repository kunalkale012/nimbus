

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // ignore: deprecated_member_use
        child: RaisedButton(
          onPressed: (){
            FirebaseAuth.instance.signOut();
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
