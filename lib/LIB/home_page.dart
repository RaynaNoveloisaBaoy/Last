import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recase/recase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/addPost.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/editprofile.dart';
import 'package:wap/profilepage.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/searchPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  String un = "WAP USER";
  String thisname = "WAP USER";

  dynamic pic = AssetImage('assets/images/defaultPic.png');

  ScrollController controller = ScrollController();
  bool isLoading = true;
  List<bool> _isChecked;
  List<String> userID = [];
  List<dynamic> userPics = [];
  List<MemoryImage> userPosts = [];
  List<String> userCaptions = [];

  initState() {
    super.initState();
    if (!mounted) {
      return;
    }
    final dbGet = DatabaseService(uid: auth.currentUser.uid);
    dbGet.getFollowing().then((value) async {
      await Future.forEach(value, (id) async {
        if (!userID.contains(id)) {
          userID.add(id);
        }
      });
    });
    String name = auth.currentUser.uid;
    String name2 = "1";
    final storageReference = FirebaseStorage.instance
        .ref()
        .child("Posts/$name/$name2")
        .listAll()
        .then((value) => {userPics.add(value)});
    print(userPics.length);
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
    dbGet.getFollowingPosts(user.uid).then((value) async {
      await Future.forEach(value, (id) async {
        if (!userPosts.contains(id)) {
          userPosts.add(id.image);
          print(userPosts.length);
          if (id.caption != null) {
            userCaptions.add(id.caption);
          }
        }
      });
    });

    print(userCaptions.length);
    dynamic name1 = await dbGet.getName();
    if (name1 == null) {
      name1 = await dbGet.getName2();
      thisname = name1;
    } else {
      thisname = name1;
    }

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
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProfilePage()));
        }
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddPostPage()));
        },
        child: Image.asset('assets/images/postButton.png'),
      ),
      body: isLoading
          ? LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal[900]),
              backgroundColor: Colors.white,
            )
          : ListView(
              children: [
                Container(
                    height: size.height * 0.8,
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: controller,
                      itemCount: 2, //userPosts.length
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    new Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(5),
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: pic,
                                          ),
                                        ),
                                        Text(
                                          thisname,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 10, bottom: 10, left: 5),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "HAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHAHA",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(5),
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(image: pic),
                                            color: Colors.teal,
                                            shape: BoxShape.rectangle),
                                        child: Image.asset(
                                            'assets/images/post.jpeg'),
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: ImageIcon(
                                              // alignment: Alignment.topLeft,
                                              AssetImage(
                                                  'assets/images/heart.png'),
                                              color: Colors.teal,
                                            ),
                                          ),
                                          /*  IconButton(
                                              // alignment: Alignment.topLeft,
                                              icon: Icon(
                                                Icons.comment,
                                                color: Colors.teal,
                                              ),
                                              onPressed: () {}),*/
                                          IconButton(
                                              // alignment: Alignment.topLeft,
                                              icon: Icon(
                                                Icons.bookmark,
                                                color: Colors.teal,
                                              ),
                                              onPressed: () {}),
                                        ]),
                                    Divider(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
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

  addPost() {}
}
