import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
import 'package:wap/searchedUser.dart';
import 'package:wap/profilepage.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  ScrollController controller = ScrollController();
  int _selectedIndex = 1;
  List<String> searchedUsers = [];
  List<String> id = [];
  List<String> usersName = [];
  List<String> usersUsername = [];
  List<dynamic> usersPic = [];
  bool searched = false;
  bool isLoading = false;
  dynamic pic = AssetImage('assets/images/defaultPic.png');
  String userName;
  String userUsername;

  initState() {
    super.initState();
  }

  getSearchData() async {
    searchedUsers.forEach((element) async {
      await getUsersData(element).then((value) {
        setState(() {
          id.add(element);
          usersUsername.add(userUsername);
          usersName.add(userName);
          usersPic.add(pic);
          pic = AssetImage('assets/images/defaultPic.png');
        });
      });
    });
  }

  getUsersData(String userid) async {
    if (!mounted) {
      return;
    }
    final dbGet = DatabaseService(uid: userid);
    dynamic uname = await dbGet.getUsername();
    dynamic name1 = await dbGet.getName();
    if (name1 == null) {
      name1 = await dbGet.getName2();
    }
    var temp = await DatabaseService(uid: userid).getPicture();
    if (temp != null) {
      if (!mounted) {
        return;
      }
      setState(() {
        pic = temp;
      });
    }
    setState(() {
      userName = name1;
      userUsername = uname;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
        break;
      case 1:
        {}
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
              context, MaterialPageRoute(builder: (context) => SettingsPage()));
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
          "Search",
          style: TextStyle(
            color: Colors.teal[500],
            fontFamily: 'Montserrat',
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          buildForm(),
          new SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(5),
            child: searchedUsers.isEmpty
                ? searched
                    ? Text(
                        "No results found",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                        ),
                      )
                    : SizedBox(height: 0)
                : Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Search Results",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.only(left: 70, right: 70),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        Container(
                            height: size.height * 0.9,
                            child: ListView.builder(
                              controller: controller,
                              itemCount: searchedUsers.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                    height: 100,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withAlpha(100),
                                              blurRadius: 10.0),
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(left: 15),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle),
                                              child: CircleAvatar(
                                                radius: 30,
                                                backgroundImage: usersPic
                                                            .length ==
                                                        searchedUsers.length
                                                    ? usersPic[index]
                                                    : AssetImage(
                                                        'assets/images/defaultPic.png'),
                                              )),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  .uid ==
                                                              id[index]
                                                          ? Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ProfilePage()))
                                                          : Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      PublicProfilePage(
                                                                          id[index])));
                                                    },
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            usersName.length ==
                                                                    searchedUsers
                                                                        .length
                                                                ? usersName[
                                                                    index]
                                                                : "WAP USER",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            softWrap: true,
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'Montserrat')),
                                                        Text(
                                                          usersUsername
                                                                      .length ==
                                                                  searchedUsers
                                                                      .length
                                                              ? "@" +
                                                                  usersUsername[
                                                                      index]
                                                              : "@WAP_USER",
                                                          style: const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  'Montserrat'),
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                              },
                            )),
                      ],
                    ),
                  ),
          ),
        ],
      )),
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

  Widget buildForm() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                child: Column(children: <Widget>[
                  SizedBox(height: 10),
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: _searchController,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: InputDecoration(
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.teal)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.teal)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter a name or username',
                      hintStyle: TextStyle(
                          color: Colors.black38, fontFamily: 'Montserrat'),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                      prefixIcon: Icon(Icons.search, color: Colors.teal),
                    ),
                    onEditingComplete: () async {
                      searchedUsers.clear();
                      usersName.clear();
                      usersPic.clear();
                      usersUsername.clear();
                      id.clear();
                      await retrieveUsers(_searchController.text);

                      await getSearchData().then((value) {
                        setState(() {
                          searched = true;
                        });
                      });
                    },
                  ),
                ]),
              ))
        ]);
  }

  retrieveUsers(String keyword) async {
    setState(() {
      keyword = keyword.toLowerCase();
    });

    final docSnap = FirebaseFirestore.instance
        .collection('users')
        .where('first name', isGreaterThanOrEqualTo: keyword)
        .where('first name', isLessThan: keyword + "z");
    final docSnap2 = FirebaseFirestore.instance
        .collection('users')
        .where('last name', isGreaterThanOrEqualTo: keyword)
        .where('last name', isLessThan: keyword + "z");
    final docSnap3 = FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: keyword)
        .where('username', isLessThan: keyword + "z");

    await docSnap.get().then((value) async {
      await Future.forEach(value.docs, (doc) async {
        if (!searchedUsers.contains(doc.id)) {
          searchedUsers.add(doc.id);
        }
      });
    });
    await docSnap2.get().then((value) async {
      await Future.forEach(value.docs, (doc) async {
        if (!searchedUsers.contains(doc.id)) {
          searchedUsers.add(doc.id);
        }
      });
    });
    await docSnap3.get().then((value) async {
      await Future.forEach(value.docs, (doc) async {
        if (!searchedUsers.contains(doc.id)) {
          searchedUsers.add(doc.id);
        }
      });
    });
  }
}
