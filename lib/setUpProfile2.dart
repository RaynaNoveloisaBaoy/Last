import 'package:firebase_auth/firebase_auth.dart';
import 'package:wap/profilepage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wap/database.dart';
import 'package:file_picker/file_picker.dart';

class SetupProfilePage2 extends StatefulWidget {
  @override
  _SetupProfilePageState2 createState() => _SetupProfilePageState2();
}

class _SetupProfilePageState2 extends State<SetupProfilePage2> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  var fileName = "Upload Profile Picture";
  var fileName2 = "Upload Certificate PDF";

  var _imageFile;
  var _pdfFile;
  PickedFile image;
  FilePickerResult pdf;

  uploadImage(BuildContext context) async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _imageFile = new File(image.path);
        fileName = auth.currentUser.uid;
      }
    });
  }

  uploadFile(BuildContext context) async {
    pdf = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    setState(() {
      if (pdf != null) {
        _pdfFile = File(pdf.files.single.path);
        _pdfFile = _pdfFile.readAsBytesSync();
        fileName2 = pdf.files.first.name;
      }
    });
  }

  updateFile() async {
    fileName2 = auth.currentUser.uid;
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Certificates/$fileName2");
    final UploadTask uploadTask = storageReference.putData(_pdfFile);
  }

  updatePicture() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Profile Pictures/$fileName");
    final UploadTask uploadTask = storageReference.putFile(_imageFile);
  }

  Future updateProfile(BuildContext context) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    if (_imageFile != null) {
      await updatePicture();
    }
    if (_pdfFile != null) {
      await updateFile();
    }
    await DatabaseService(uid: user.uid).updateUserInfo1(
        _nicknameController.text,
        _addressController.text,
        _phoneNumberController.text,
        _descriptionController.text);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('We Adopt Pets'),
        actions: [
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
              height: 60,
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(children: <Widget>[
          Text(
            'Set Up Profile',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Fredoka One',
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          buildForm(context),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 100),
            child: Container(
              padding: EdgeInsets.only(top: 3, left: 3),
              child: MaterialButton(
                minWidth: double.infinity,
                height: 50,
                onPressed: () async {
                  if (_key.currentState.validate()) {
                    updateProfile(context);
                  }
                },
                color: Colors.teal[100],
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Text("Submit",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'Montserrat')),
              ),
            ),
          ),
          TextButton(
              onPressed: () async {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()));
              },
              child: Text("Skip",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      decoration: TextDecoration.underline)))
        ]),
      ),
    );
  }

  @override
  Widget buildForm(BuildContext context) {
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return "This field is required";
                    } else {
                      return null;
                    }
                  },
                  controller: _nicknameController,
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
                    hintText: 'Nickname',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.person_rounded, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "This field is required";
                    } else {
                      return null;
                    }
                  },
                  controller: _addressController,
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
                    hintText: 'Address',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.home_rounded, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    return validateMobile(value);
                  },
                  controller: _phoneNumberController,
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
                    hintText: 'Contact Number',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon:
                        Icon(Icons.contact_phone_rounded, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  maxLines: 2,
                  maxLength: 60,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "This field is required";
                    } else {
                      return null;
                    }
                  },
                  controller: _descriptionController,
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
                    hintText: 'Description',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.article, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          await uploadImage(context);
                        },
                        child: Container(
                            padding: EdgeInsets.only(right: 15),
                            alignment: Alignment.bottomLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: _imageFile != null
                                  ? Image.file(
                                      _imageFile,
                                      matchTextDirection: true,
                                      fit: BoxFit.fill,
                                      height: 45,
                                    )
                                  : Image.asset(
                                      'assets/images/photo.png',
                                      matchTextDirection: true,
                                      fit: BoxFit.fill,
                                      height: 45,
                                    ),
                            )),
                      ),
                      SizedBox(
                          width: 160,
                          child: Text(fileName,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat'))),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        onPressed: () async {
                          await uploadFile(context);
                        },
                        child: Container(
                            padding: EdgeInsets.only(right: 15),
                            alignment: Alignment.bottomLeft,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/pdf.png',
                                matchTextDirection: true,
                                fit: BoxFit.fill,
                                height: 45,
                              ),
                            )),
                      ),
                      SizedBox(
                          width: 165,
                          child: Text(fileName2,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat')))
                    ]),
              ]),
            )),
      ],
    );
  }
}

String validateMobile(String value) {
  String patttern = r'(^09[0-9]{9}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid 11 digit mobile number';
  }
  return null;
}
