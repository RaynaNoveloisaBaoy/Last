import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wap/searchedUser.dart';
import 'package:wap/profilepage.dart';
import 'package:wap/splash_screen.dart';

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  AssetImage pic = AssetImage('assets/images/wap_logo.png');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return somethingWentWrong(snapshot);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  User user = snapshot.data;
                  if (user == null) {
                    return Splash();
                  } else {
                    return ProfilePage();
                  }
                }
                return loading(pic);
              });
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return loading(pic);
      },
    );
  }
}

somethingWentWrong(snapshot) {
  return Scaffold(body: Center(child: Text("Error: ${snapshot.error}")));
}

loading(AssetImage pic) {
  return Scaffold(
      backgroundColor: Colors.teal[200],
      body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        SizedBox(
          height: 200,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 75,
            backgroundImage: pic,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "CONNECTING TO THE APP",
          style: TextStyle(color: Colors.white),
        )
      ])));
}
