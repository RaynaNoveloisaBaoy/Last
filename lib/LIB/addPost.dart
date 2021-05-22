import 'package:firebase_auth/firebase_auth.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wap/database.dart';
import 'package:firebase_core/firebase_core.dart';

class AddPostPage extends StatefulWidget {
  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  TextEditingController _captionController = TextEditingController();
  bool imageSelected = false;
  bool isShowSticker = false;
  int postNum;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  String fileName;
  var _imageFile;
  PickedFile image;
  String thisname = "WAP USER";
  dynamic pic = AssetImage('assets/images/defaultPic.png');

  initState() {
    super.initState();
    if (!mounted) {
      return;
    }
    getUserData();
    final dbGet = DatabaseService(uid: auth.currentUser.uid);
    dbGet.getUserPostsCount().then((value) {
      setState(() {
        postNum = value + 1;
      });
    });
  }

  getUserData() async {
    if (!mounted) {
      return;
    }
    final User user = auth.currentUser;
    final dbGet = DatabaseService(uid: user.uid);
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

  getImageGallery() async {
    PickedFile image = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _imageFile = new File(image.path);
        fileName = auth.currentUser.uid;
        imageSelected = true;
      }
    });
  }

  getImageCamera() async {
    PickedFile image = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _imageFile = new File(image.path);
        fileName = auth.currentUser.uid;
        imageSelected = true;
      }
    });
  }

  updatePicture() async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child("Posts/$fileName/$postNum");
    final UploadTask uploadTask = storageReference.putFile(_imageFile);
  }

  Future updateProfile() async {
    final dbGet = DatabaseService(uid: auth.currentUser.uid);
    User user = auth.currentUser;
    if (_imageFile != null) {
      await updatePicture().then({dbGet.addPost(_captionController.text)});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal[100],
          centerTitle: true,
          automaticallyImplyLeading: true,
          elevation: 1,
          title: Text(
            "Add Post",
            style: TextStyle(
              color: Colors.teal[500],
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        body: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Column(children: [
                    new Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, top: 10, right: 5),
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
                  ]),
                ),
                buildForm(),
                _imageFile != null
                    ? Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        child: Image.file(
                          _imageFile,
                          matchTextDirection: true,
                          fit: BoxFit.fill,
                        ))
                    : SizedBox(
                        height: 1,
                      ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          icon: Icon(
                            Icons.photo,
                            color: Colors.teal,
                          ),
                          onPressed: () async {
                            await getImageGallery();
                          }),
                      IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.teal,
                          ),
                          onPressed: () async {
                            await getImageCamera();
                          }),
                      IconButton(
                          icon: Icon(Icons.tag_faces, color: Colors.teal),
                          onPressed: () {
                            setState(() {
                              isShowSticker = !isShowSticker;
                            });
                          })
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: MaterialButton(
                        onPressed: () async {
                          updateProfile();
                          Navigator.pop(context);
                        },
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        color: Colors.teal[400],
                        child: Center(
                          child: Text(
                            'Upload Post',
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            (isShowSticker
                ? Padding(
                    padding: EdgeInsets.only(top: 175), child: buildSticker())
                : Container()),
          ],
        ));
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
                    maxLength: 60,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    autofocus: true,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.words,
                    controller: _captionController,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                    decoration: InputDecoration(
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.teal)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.teal)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Care for a caption?',
                      hintStyle: TextStyle(
                          color: Colors.black38, fontFamily: 'Montserrat'),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    ),
                  ),
                ]),
              ))
        ]);
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        setState(() {
          _captionController.text = _captionController.text + emoji.emoji;
          _captionController.selection = TextSelection.fromPosition(
              TextPosition(offset: _captionController.text.length));
        });
      },
    );
  }
}
