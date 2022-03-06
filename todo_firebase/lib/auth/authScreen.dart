import 'package:flutter/material.dart';
import 'package:todo_firebase/auth/authForm.dart';
class authscreen extends StatefulWidget {
  const authscreen({Key? key}) : super(key: key);

  @override
  _authscreenState createState() => _authscreenState();
}

class _authscreenState extends State<authscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('aunthentication'),
      ),
      body: authform(),
    );
  }
}
