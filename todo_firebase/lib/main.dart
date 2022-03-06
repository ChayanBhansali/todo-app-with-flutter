import 'package:flutter/material.dart';
import 'package:todo_firebase/auth/authScreen.dart';
import 'package:todo_firebase/screens/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, usersnapshot) {
        if (usersnapshot.hasData) {
          return home();
        } else {
          return authscreen();
        }
      },
    ),
  ));
}

