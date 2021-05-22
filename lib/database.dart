import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recase/recase.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userslist =
      FirebaseFirestore.instance.collection('users');

  Future updateUser1(
      String username, String email, String fname, String lname) async {
    return await userslist.doc(uid).set({
      'username': username,
      'email': email,
      'first name': fname.toLowerCase(),
      'last name': lname.toLowerCase(),
    });
  }

  Future updateUser2(String username, String email, String iname) async {
    return await userslist.doc(uid).set({
      'username': username,
      'email': email,
      'institution name': iname.toLowerCase()
    });
  }

  Future updateUserInfo1(
      String nickname, String address, String cNum, String bio) async {
    return await userslist.doc(uid).update({
      'nickname': nickname.toLowerCase(),
      'address': address.toLowerCase(),
      'contact number': cNum,
      'bio': bio,
    });
  }

  Future updateProfile1(String first, String last, String bio, String nickname,
      String address, String cNum) async {
    final ud = userslist.doc(uid);
    if (first.isEmpty == false) {
      await ud.update({'first name': first.toLowerCase()});
    }
    if (last.isEmpty == false) {
      await ud.update({'last name': last.toLowerCase()});
    }
    if (bio.isEmpty == false) {
      await ud.update({'bio': bio});
    }
    if (nickname.isEmpty == false) {
      await ud.update({'nickname': nickname.toLowerCase()});
    }
    if (address.isEmpty == false) {
      await ud.update({'address': address});
    }
    if (cNum.isEmpty == false) {
      await ud.update({'contact number': cNum});
    }
  }

  addFollowing(String profileID) async {
    final ud = await userslist.doc(uid).update({
      'following': FieldValue.arrayUnion([profileID])
    });
  }

  removeFollowing(String profileID) async {
    var val = [];
    val.add(profileID);
    final ud = await userslist
        .doc(uid)
        .update({'following': FieldValue.arrayRemove(val)});
  }

  Stream<QuerySnapshot> get users {
    return userslist.snapshots();
  }

  Future getUsername() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("username");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getName() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();

      return ReCase(un.get("first name") + " " + un.get("last name")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getFName() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("first name")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getName2() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("institution name")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getBio() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("bio");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getNickname() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return ReCase(un.get("nickname")).titleCase;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getAddress() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("address");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getContact() async {
    try {
      DocumentSnapshot un = await userslist.doc(uid).get();
      return un.get("contact number");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  getPicture() async {
    try {
      final storageReference = await FirebaseStorage.instance
          .ref()
          .child("Profile Pictures/$uid")
          .getData();
      return MemoryImage(storageReference);
    } catch (e) {
      return null;
    }
  }

  //for first name and last name : return [firstname, lastname];
}

Future<bool> isUsernameAvailable(String username) async {
  final CollectionReference userslist =
      FirebaseFirestore.instance.collection('users');
  userslist.get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      if (doc["username"] == username) {
        return false;
      }
    });
  });
  return true;
}
