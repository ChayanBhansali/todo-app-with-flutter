import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class authform extends StatefulWidget {
  const authform({Key? key}) : super(key: key);

  @override
  _authformState createState() => _authformState();
}

class _authformState extends State<authform> {
  final _formkey = GlobalKey<FormState>();
 var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false ;

  startauthentication() {
    final validity = _formkey.currentState?.validate();
    FocusScope.of(context).unfocus();

    if (validity!) {
      _formkey.currentState?.save();
      submitform(_email, _password, _username);
    }
  }
submitform(String email , String password, String username)async{
final auth = FirebaseAuth.instance;

try{
  if(isLoginPage){
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email,
        password: _password,

    );
  }else{
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
    );
    String? uid = userCredential.user?.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'username': username, 'email': email});
  }
}catch(e){
  print(e);
}
  }



  @override
  Widget build(BuildContext context) {
    return Container(

      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10,right: 10,top: 10),
            child: Form(key: _formkey ,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(!isLoginPage)
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('username'),
                    validator: (value) {
                      if (value?.isEmpty ?? false){
                        return 'incorrect username';
                      }else {
                        return null;
                      };
                    },
                    onSaved: (value){
                      _username = value.toString();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide()
                      ),
                      labelText: "Enter username",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value?.isEmpty ?? false ){
                        return 'Incorrect email';
                      }else {
                          return null;
                        };
                      },

                    onSaved: (value){
                      _email = value.toString();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                        borderSide: new BorderSide()
                      ),
                      labelText: "Enter email",
                    ),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value?.isEmpty ?? false ){
                        return 'incorrect password';
                      }else {
                        return null;
                      };
                    },
                    onSaved: (value){
                      _password = value.toString();
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide()
                      ),
                      labelText: "Enter password",
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                      height: 70,
                      width: double.infinity,
                      padding: EdgeInsets.all(5.0),
                      child: RaisedButton(onPressed: (){
                        startauthentication();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                        color: Colors.blue[400],
                        child: isLoginPage? Text('Login') : Text('Sign Up'),
                    ),

                  ),
                  SizedBox(height: 10,),
                  Container(child: TextButton(onPressed: () {
                    setState(() {
                      isLoginPage = !isLoginPage;
                    });
                  },child: isLoginPage? Text('Not a member?') : Text('Already a member?'),),)
                ],
              ) ,),
          )
        ],
      ),
    );
  }
}
