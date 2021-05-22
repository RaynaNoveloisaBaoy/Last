import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/database.dart';
import 'package:flutter/material.dart';
import 'package:wap/editprofile.dart';
import 'package:wap/settingsPage.dart';
import 'package:wap/home_page.dart';
import 'package:wap/searchPage.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedIndex = 0;
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _selectedIndex = 2;
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

  //sample data of pet profiles
  var PET_LIST = [
    {
      "name": "SAMPLE_1",
      "breed": "Breed",
      "age": "Age",
      "image": "defaultPic.png"
    },
    {
      "name": "SAMPLE_2",
      "breed": "Breed",
      "age": "Age",
      "image": "defaultPic.png"
    },
    {
      "name": "SAMPLE_3",
      "breed": "Breed",
      "age": "Age",
      "image": "defaultPic.png"
    },
    {
      "name": "SAMPLE_4",
      "breed": "Breed",
      "age": "Age",
      "image": "defaultPic.png"
    }
  ];

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
    _isChecked = List<bool>.filled(PET_LIST.length, false, growable: true);
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
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
        }
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
          "Profile",
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
                    children: [
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 28, top: 7),
                            child: CircleAvatar(
                              radius: 40, backgroundImage: pic, //GET FROM DB
                              child: GestureDetector(
                                onTap: () async {
                                  await expandPhoto();
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: (size.width - 50) * 0.7,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        thisname,
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 1),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              //GET FROM DB
                                              '@' + un,
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontFamily: 'Montserrat',
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, bottom: 5),
                        child: Text(
                          bio,
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfile()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    color: Colors.teal[50],
                    child: Center(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'Montserrat',
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 0.5,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: (size.width * 0.33),
                        child: IconButton(
                          icon: const Icon(
                            Icons.grid_on_rounded,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            print("Display Posts"); //FROM DB
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: (size.width * 0.33),
                        child: IconButton(
                          icon: const Icon(
                            Icons.pets_rounded,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            print("Display Pet List"); //FROM DB
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                        ),
                      ),
                      Container(
                        width: (size.width * 0.33),
                        child: IconButton(
                          icon: const Icon(
                            Icons.account_box_rounded,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            print("Display About Me"); //FROM DB
                            setState(() {
                              selectedIndex = 2;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Column(children: [
                  Row(
                    children: [
                      Container(
                          height: 3,
                          width: (size.width * 0.33),
                          decoration: BoxDecoration(
                              color: selectedIndex == 0
                                  ? Colors.teal[800]
                                  : Colors.transparent)),
                      Container(
                          height: 3,
                          width: (size.width * 0.33),
                          decoration: BoxDecoration(
                              color: selectedIndex == 1
                                  ? Colors.teal[800]
                                  : Colors.transparent)),
                      Container(
                          height: 3,
                          width: (size.width * 0.33),
                          decoration: BoxDecoration(
                              color: selectedIndex == 2
                                  ? Colors.teal[800]
                                  : Colors.transparent))
                    ],
                  ),
                  Container(
                    height: 0.5,
                    width: size.width,
                    decoration: BoxDecoration(color: Colors.teal),
                  ),
                ]),
                SizedBox(height: 10),
                IndexedStack(
                  index: selectedIndex,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 60, right: 50, top: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Posts Available",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 30)),
                        ],
                      ),
                    ),
                    getPetList(size),
                    getAboutMe(),
                  ],
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

  getAboutMe() {
    return Wrap(
      direction: Axis.horizontal,
      spacing: 3,
      runSpacing: 3,
      children: [
        Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 70, right: 70),
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("About Me",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[50]
                          //decoration: TextDecoration.underline
                          )),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.teal),
                          child: Icon(Icons.person_outline_rounded,
                              color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Nickname",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                //Get nickname of user
                Text(
                  nickname,
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.teal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.teal),
                          child:
                              Icon(Icons.home_outlined, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Address",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                //Get address of user
                Text(
                  address,
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.teal),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                          height: 60,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.teal),
                          child: Icon(Icons.mail_outline_rounded,
                              color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        "Contact Details",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
                //Get contact details of user
                Text(
                  contact,
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                SizedBox(height: 10),
                Divider(color: Colors.teal)
              ],
            ))
      ],
    );
  }

  getPetList(size) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 70, right: 70),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.teal,
                borderRadius: BorderRadius.circular(10)),
            child: Text("My Pet List",
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[50]
                    //decoration: TextDecoration.underline
                    )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      if (PET_LIST.length > 0) {
                        _isChecked = List<bool>.filled(PET_LIST.length, true,
                            growable: true);
                      }
                    });
                  },
                  child: Text("Select All",
                      style: TextStyle(
                          color: Colors.teal,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline))),
              IconButton(
                  icon: Icon(Icons.add, color: Colors.teal),
                  onPressed: () {
                    print("Add pet profile");
                  }),
            ],
          ),
          Container(
              height: size.height * 0.41,
              //color: Colors.teal,
              child: ListView.builder(
                controller: controller,
                itemCount: PET_LIST.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                      height: 120,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withAlpha(100),
                                blurRadius: 10.0),
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Checkbox(
                                activeColor: Colors.teal,
                                checkColor: Colors.white,
                                value: _isChecked[index],
                                onChanged: (bool value) {
                                  setState(() {
                                    _isChecked[index] = value;
                                  });
                                }),
                            Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Image.asset(
                                "assets/images/${PET_LIST[index]["image"]}",
                                height: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(PET_LIST[index]["name"],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat')),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          PET_LIST[index]["breed"],
                                          style: const TextStyle(
                                              //fontSize: 17,
                                              color: Colors.grey,
                                              fontFamily: 'Montserrat'),
                                        ),
                                        Text(
                                          PET_LIST[index]["age"],
                                          style: const TextStyle(
                                              //fontSize: 17,
                                              color: Colors.grey,
                                              fontFamily: 'Montserrat'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                },
              )),
          SizedBox(height: 5),
          Padding(
              padding: const EdgeInsets.only(right: 50, left: 50),
              child: Container(
                width: 100,
                alignment: Alignment.center,
                height: size.height * 0.045,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.teal[100]),
                child: IconButton(
                    alignment: Alignment.center,
                    icon: Icon(Icons.delete_outline, color: Colors.black),
                    onPressed: () async {
                      List<int> selectedIndex = [];
                      int elementNum = 0;
                      _isChecked.forEach((element) {
                        elementNum += 1;
                        if (element == true) {
                          selectedIndex.add(elementNum);
                        }
                      });

                      if (selectedIndex.isNotEmpty) {
                        await showDialogDelete(selectedIndex);
                      }
                    }),
              )),
        ],
      ),
    );
  }

  showDialogDelete(List<int> selectedIndex) {
    bool flag;
    showDialog(
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
                  height: MediaQuery.of(context).size.height / 4.7,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 50),
                        Text(
                            "Do you really want to delete the selected pet profile/s?",
                            style: TextStyle(fontFamily: 'Montserrat')),
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
                                child: Text("Delete",
                                    style: TextStyle(fontFamily: 'Montserrat')),
                                onPressed: () {
                                  print(selectedIndex);

                                  setState(() {
                                    if (selectedIndex.length ==
                                        PET_LIST.length) {
                                      _isChecked.clear();
                                      PET_LIST.clear();
                                    } else {
                                      selectedIndex.forEach((element) {
                                        _isChecked.removeAt(element - 1);
                                        PET_LIST.removeAt(element - 1);
                                      });
                                    }
                                  });
                                  Navigator.pop(context);
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
                      backgroundColor: Colors.transparent,
                      radius: 50,
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          child: Image.asset('assets/images/haha.png')),
                    ))
              ]),
        );
      },
      barrierDismissible: true,
    );
    return flag;
  }

  expandPhoto() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Image(
                    fit: BoxFit.fill,
                    image: pic,
                  ),
                ),
                Positioned(
                  top: -25,
                  right: -20,
                  child: IconButton(
                    alignment: Alignment.center,
                    color: Colors.teal,
                    iconSize: 40,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel_outlined,
                      color: Colors.black,
                    ),
                  ),
                )
              ]),
        );
      },
      barrierDismissible: true,
    );
  }
}
