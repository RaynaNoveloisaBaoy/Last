import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wap/profilepage.dart';
import 'package:wap/register_account.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool _secureText = true;
  final _key = GlobalKey<FormState>();
  String email = "none";
  bool userExist = false;

  searchUser() async {
    final docSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: _usernameController.text);
    await docSnap.get().then((value) async {
      await Future.forEach(value.docs, (doc) async {
        setState(() {
          userExist = true;
          email = doc['email'];
        });
      });
    });
    print(userExist);
    if (userExist == true) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email, password: _passwordController.text);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePage(),
            ));
      } catch (e) {
        if (!mounted) {
          return;
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                "Login Error",
                textAlign: TextAlign.center,
              ),
              content: new Text(
                e.message,
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                MaterialButton(
                  child: new Text("OK"),
                  color: Colors.teal[100],
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Login Error",
              textAlign: TextAlign.center,
            ),
            content: Text(
              "Username not found",
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              MaterialButton(
                child: new Text("OK"),
                color: Colors.teal[100],
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.teal[400],
        body: Container(
          margin: EdgeInsets.only(top: 60),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.teal[200],
                      ),
                      child: Image.asset(
                        'assets/images/wap_logo.png',
                        matchTextDirection: true,
                        fit: BoxFit.fill,
                        height: 150,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Login to WAP APP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Fredoka One'),
                    ),
                  ]),
                  SizedBox(height: 50),
                  buildForm(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 50,
                        onPressed: () {
                          if (_key.currentState.validate()) {
                            searchUser();
                          }
                        },
                        color: Colors.teal[100],
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        child: Text('Login',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                fontFamily: 'Montserrat')),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child: Text(
                            "Forgot Password",
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline),
                          ),
                          onPressed: () {
                            createPopUp(context);
                          }),
                      SizedBox(height: 15),
                      Text(
                        "New to WAP App?",
                        style: TextStyle(fontFamily: 'Montserrat'),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(primary: Colors.white),
                          child: Text('Create an Account',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  decoration: TextDecoration.underline)),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterAccount(),
                              )))
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  createPopUp(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email is required";
                            } else {
                              return null;
                            }
                          },
                          controller: _emailController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide:
                                    BorderSide(color: Colors.teal[200])),
                            fillColor: Colors.teal[300],
                            filled: true,
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                                color: Colors.teal[100],
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text("Send reset link",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                                onPressed: () {
                                  createConfirm(context);
                                }),
                            MaterialButton(
                                color: Colors.teal[100],
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text("Cancel",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -50,
                    child: CircleAvatar(
                      backgroundColor: Colors.teal[200],
                      radius: 50,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image.asset('assets/images/confused.png')),
                    ))
              ]),
        );
      },
      barrierDismissible: true,
    );
  }

  createConfirm(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text(
                            "A password reset link is already sent to your email.",
                            style: TextStyle(fontFamily: 'Montserrat')),
                        SizedBox(height: 20),
                        MaterialButton(
                            color: Colors.teal[100],
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            child: Text("Done",
                                style: TextStyle(fontFamily: 'Montserrat')),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -50,
                    child: CircleAvatar(
                      backgroundColor: Colors.teal[200],
                      radius: 50,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image.asset('assets/images/wap_logo.png')),
                    ))
              ]),
        );
      },
      barrierDismissible: true,
    );
  }

  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Form(
              key: _key,
              child: Column(children: <Widget>[
                TextFormField(
                  //USERNAME
                  //Include invalid username in validator
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Username is required";
                    } else {
                      return null;
                    }
                  },
                  controller: _usernameController,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.teal[200])),
                    fillColor: Colors.teal[300],
                    filled: true,
                    hintText: 'Username',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //PASSWORD
                  //Include invalid password in validator
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 6) {
                      return "Password should be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                  controller: _passwordController,
                  obscureText: _secureText,
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.teal[200])),
                      fillColor: Colors.teal[300],
                      filled: true,
                      hintText: 'Password',
                      hintStyle: TextStyle(
                          color: Colors.black38, fontFamily: 'Montserrat'),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      suffixIcon: IconButton(
                        color: Colors.white,
                        icon: Icon(
                            _secureText ? Icons.remove_red_eye : Icons.lock),
                        onPressed: () {
                          setState(() {
                            _secureText = !_secureText;
                          });
                        },
                      )),
                ),
              ]),
            )),
      ],
    );
  }
}
