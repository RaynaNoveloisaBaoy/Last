import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/editprofile.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/searchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  String un = "WAP USER";
  String thisname = "WAP USER";
  String bio = " ";
  String address = "The user has not set this yet.";
  String contact = "The user has not set this yet.";
  String nickname = "The user has not set this yet.";
  dynamic pic = AssetImage('assets/images/defaultPic.png');
  ScrollController controller = ScrollController();
  bool isLoading = true;
  List<bool> _isChecked;

  initState() {
    super.initState();
    if (!mounted) {
      return;
    }
    getUserData().then((value) {
      setState(() {
        isLoading = false;
      });
    }, onError: (msg) {});
  }

  getUserData() async {
    if (!mounted) {
      return;
    }
    final User user = auth.currentUser;
    final dbGet = DatabaseService(uid: user.uid);
    dynamic uname = await dbGet.getUsername();
    dynamic name1 = await dbGet.getName();
    if (name1 == null) {
      name1 = await dbGet.getName2();
      thisname = name1;
    } else {
      thisname = name1;
    }
    dynamic bio1 = await dbGet.getBio();

    if (bio1 != null) {
      dynamic nickname1 = await dbGet.getNickname();
      dynamic address1 = await dbGet.getAddress();
      dynamic contact1 = await dbGet.getContact();
      setState(() {
        bio = bio1;
        nickname = nickname1;
        address = address1;
        contact = contact1;
      });
    }
    setState(() {
      un = uname;
    });

    var temp = await DatabaseService(uid: user.uid).getPicture();
    if (temp != null) {
      if (!mounted) {
        return;
      }
      setState(() {
        pic = temp;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        {}
        break;
      case 1:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
        }
        break;
      case 2:
        {}
        break;
      case 3:
        {}
        break;
      case 4:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Text(
          "Home",
          style: TextStyle(
            color: Colors.teal[500],
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      body: isLoading
          ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[900]),
              backgroundColor: Colors.white,
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.teal,
        showUnselectedLabels: true,
      ),
    );
  }
}
