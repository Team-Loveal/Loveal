import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:lovealapp/services/auth.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:lovealapp/pages/login.dart';
import "package:lovealapp/services/auth.dart";

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final AuthService _auth = AuthService();

  //text field state
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.fromLTRB(20, 60, 20, 5),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.fromLTRB(20, 0, 15, 20),
                    child: Text('Please sign up to find your match',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
                Container(
                    height: 55,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextField(
                      onChanged:(val) {
                        setState(() => email = val);
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(MdiIcons.email),
                          labelText: 'Email',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                Container(
                    height: 55,
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextField(
                      onChanged:(val) {
                        setState(() => password = val);
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(MdiIcons.key),
                          labelText: 'Password',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(170, 10, 20, 0),
                    child: RaisedButton(
                        onPressed: () async {
                          print(email);
                          print(password);
                        },
                        textColor: Colors.white,
                        color: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(
                          children: <Widget>[
                            Text('SIGN UP  ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Icon(MdiIcons.arrowRight, size: 18)
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ))),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0, 80, 0, 10),
                    child: Text('Sign up with',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ))),
                Container(
                    child: Row(
                  children: <Widget>[
                    RawMaterialButton(
                      //TEST WITH ANON SIGN UP
                      onPressed: () async {
                        print(Text("CLICKED"));
                        dynamic result = await _auth.signInAnon();
                        if(result == null) {
                          print('error signing in');
                        } else {
                          print("signed in");
                          print(result.uid);
                        }
                      },
                      fillColor: Colors.white,
                      child: Icon(
                        MdiIcons.facebook,
                        size: 40,
                        color: Color.fromARGB(255, 66, 103, 178),
                      ),
                      shape: CircleBorder(),
                    ),
                    RawMaterialButton(
                      onPressed: () {},
                      fillColor: Colors.white,
                      child: Icon(
                        MdiIcons.google,
                        size: 40,
                        color: Color.fromARGB(255, 234, 67, 53),
                      ),
                      shape: CircleBorder(),
                    ),
                    RawMaterialButton(
                      onPressed: () {},
                      fillColor: Colors.white,
                      child: Icon(
                        MdiIcons.twitter,
                        size: 40,
                        color: Color.fromARGB(255, 29, 161, 242),
                      ),
                      shape: CircleBorder(),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                )),
                Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Text("Already have an account?",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        FlatButton(
                            onPressed: () => {
                              Navigator.of(context).pushNamed('/login')
                            },
                            textColor: Colors.pink,
                            child: Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            )),
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    )),
              ],
            )));
  }
}
