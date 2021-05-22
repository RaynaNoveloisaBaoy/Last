import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wap/database.dart';
import 'package:wap/setUpProfile.dart';

class PersonalRegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<PersonalRegisterPage> {
  TextEditingController _newfirstnameController = TextEditingController();
  TextEditingController _newlastnameController = TextEditingController();
  TextEditingController _newusernameController = TextEditingController();
  TextEditingController _newemailController = TextEditingController();
  TextEditingController _newpasswordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  bool accepted = false;
  bool usernameTaken = false;
  bool emailTaken = false;
  String pssword;
  String errorMsg;
  final _key = GlobalKey<FormState>();

  _registerUser() async {
    final docSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: _newusernameController.text);
    await docSnap.get().then((value) async {
      await Future.forEach(value.docs, (doc) async {
        setState(() {
          usernameTaken = true;
        });
      });
    });
    _userRegister(usernameTaken);
    setState(() {
      usernameTaken = false;
    });
  }

  _userRegister(bool usernameTaken) async {
    if (usernameTaken == false) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _newemailController.text,
                password: _newpasswordController.text);
        User user = userCredential.user;
        await DatabaseService(uid: user.uid).updateUser1(
            _newusernameController.text,
            _newemailController.text,
            _newfirstnameController.text,
            _newlastnameController.text);
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SetupProfilePage(),
            ));
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(
                "Registration Error",
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(
              "Registration Error",
              textAlign: TextAlign.center,
            ),
            content: Text(
              "Username is already taken",
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.teal[100],
        centerTitle: true,
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
            'Register an Account',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Fredoka One',
                fontSize: 30,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          buildForm(),
          SizedBox(height: 20),
          readTC(),
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
                    await _registerUser();
                  }
                },
                color: Colors.teal[100],
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Text("Register",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        fontFamily: 'Montserrat')),
              ),
            ),
          ),
        ]),
      ),
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
                  //FIRST NAME
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "First name is required";
                    } else if (value.length > 64) {
                      return "Character limit reached (64 characters)";
                    } else {
                      return null;
                    }
                  },
                  controller: _newfirstnameController,
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
                    hintText: 'First Name',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //LAST NAME
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Last Name is required";
                    } else if (value.length > 32) {
                      return "Character limit reached (32 characters)";
                    } else {
                      return null;
                    }
                  },
                  controller: _newlastnameController,
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
                    hintText: 'Last Name',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //USERNAME
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Username is required";
                    } else if (value.length > 32) {
                      return "Character limit reached (32 characters)";
                    } else {
                      return null;
                    }
                  },
                  controller: _newusernameController,
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
                    prefixIcon:
                        Icon(Icons.alternate_email, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //EMAIL
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Email is required";
                    } else if (emailTaken) {
                      return "Email is already used";
                    } else {
                      return errorMsg;
                    }
                  },
                  controller: _newemailController,
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
                    hintText: 'Email',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //PASSWORD
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 6) {
                      return "Password should be at least 6 characters";
                    } else if (value.length > 32) {
                      return "Character limit reached (32 characters)";
                    } else {
                      return null;
                    }
                  },
                  controller: _newpasswordController,
                  obscureText: true,
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
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  //CONFIRM PASSWORD
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Password is required";
                    } else if (_newpasswordController.text !=
                        _confirmpasswordController.text) {
                      return "Password does not match";
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  controller: _confirmpasswordController,
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
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                        color: Colors.black38, fontFamily: 'Montserrat'),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                  ),
                ),
              ]),
            )),
      ],
    );
  }

  Widget readTC() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('By clicking Register, you accept the ',
            style: TextStyle(fontFamily: 'Montserrat')),
        TextButton(
            onPressed: () {
              createTC(context);
              //TermsAndConditions();
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TermsAndConditions(),
                  ));*/
            },
            style: TextButton.styleFrom(primary: Colors.white),
            child: Text('Terms and Conditions of WAP App',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    decoration: TextDecoration.underline)))
      ],
    );
  }
}

createTC(BuildContext context) {
  final ScrollController _scrollController = ScrollController();

  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        insetPadding: EdgeInsets.all(10),
        child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text("Terms and Conditions",
                          style: TextStyle(
                              fontFamily: 'Fredoka One',
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Expanded(
                        child: Scrollbar(
                          isAlwaysShown: true,
                          controller: _scrollController,
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                return Card(
                                    child: ListTile(
                                  title: Text(
                                      "These terms and conditions set forth the general terms and conditions of your use of the We Adopt Pets mobile application or WAP App and any of its related products and services. By accessing and using the Mobile Application and Services, you acknowledge that you have read, understood, and agree to be bound by the terms of this Agreement. If you do not agree with the terms of this Agreement, you must not accept this Agreement and may not access and use the WAP App and Services. You acknowledge that this Agreement is a contract between you and the Operator, even though it is electronic and is not physically signed by you, and it governs your use of the Mobile Application and Services. \n",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: 'Montserrat'),
                                      textAlign: TextAlign.justify),
                                  subtitle: Column(
                                    children: <Widget>[
                                      Text(
                                        "ACCOUNTS AND MEMBERSHIP",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "If you create an account in the WAP App, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account and any other actions taken in connection with it. We may, but have no obligation to, monitor and review new accounts before you may sign in and start using the Services. Providing false contact information of any kind may cause the termination of your account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security. We will not be liable for any acts or omissions by you, including any damages of any kind incurred because of such acts or omissions. We may suspend, disable, or delete your account (or any part thereof) if we determine that you have violated any provision of this agreement or that your conduct or content would damage our reputation and goodwill. If we delete your account for the foregoing reasons, you may not re-register for our Services. We may block your email address and Internet protocol address to prevent further registration. \n",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "USER CONTENT",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "We do not own any data, information or content that you submit in the WAP App in the course of using the Service. You shall have sole responsibility for the accuracy, quality, integrity, legality, reliability, appropriateness, and intellectual property ownership or right to use of all submitted Content. We may monitor and review the Content in the WAP App submitted or created using our Services by you. You grant us permission to access, copy, distribute, store, transmit, reformat, display and perform the Content of your user account solely as required for the purpose of providing the Services to you. Without limiting any of those representations or warranties, we have the right, though not the obligation, to, in our own sole discretion, refuse or remove any Content that, in our reasonable opinion, violates any of our policies or is in any way harmful or objectionable. Unless specifically permitted by you, your use of the WAP App and Services does not grant us the license to use, reproduce, adapt, modify, publish or distribute the Content created by you or stored in your user account for commercial, marketing or any similar purpose. \n",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "BACKUPS",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "We perform regular backups of the Content and will do our best to ensure completeness and accuracy of these backups. In the event of the hardware failure or data loss we will restore backups automatically to minimize the impact and downtime. \n",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "PROHIBITED USES",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "In addition to other terms as set forth in the Agreement, you are prohibited from using the Mobile Application and Services or Content: (a) for any unlawful purpose; (b) to solicit others to perform or participate in any unlawful acts; (c) to violate any international, federal, provincial or state regulations, rules, laws, or local ordinances; (d) to infringe upon or violate our intellectual property rights or the intellectual property rights of others; (e) to harass, abuse, insult, harm, defame, slander, disparage, intimidate, or discriminate based on gender, sexual orientation, religion, ethnicity, race, age, national origin, or disability; (f) to submit false or misleading information; (g) to upload or transmit viruses or any other type of malicious code that will or may be used in any way that will affect the functionality or operation of the Mobile Application and Services, third-party products and services, or the Internet; (h) to spam, phish, pharm, pretext, spider, crawl, or scrape; (i) for any obscene or immoral purpose; or (j) to interfere with or circumvent the security features of the Mobile Application and Services. We reserve the right to end your use of the WAP App  and Services for violating any of the prohibited uses. \n",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "INTELLECTUAL PROPERTY RIGHTS",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Intellectual Property Rights means all present and future rights conferred by statute, common law or equity in or in relation to any copyright and related rights, trademarks, designs, patents, inventions, goodwill and the right to sue for passing off, rights to inventions, rights to use, and all other intellectual property rights, in each case whether registered or unregistered and including all applications and rights to apply for and be granted, rights to claim priority from, such rights and all similar or equivalent rights or forms of protection and any other results of intellectual activity which subsist or will subsist now or in the future in any part of the world. This Agreement does not transfer to you any intellectual property owned by the Operator or third parties, and all rights, titles, and interests in and to such property will remain solely with the Operator. All trademarks, service marks, graphics and logos used in connection with the Mobile Application and Services, are trademarks or registered trademarks of the Operator or its licensors. Other trademarks, service marks, graphics and logos used in connection with the WAP App and Services may be the trademarks of other third parties. Your use of the Mobile Application and Services grants you no right or license to reproduce or otherwise use any of the Operator or third party trademarks. \n",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "LIMITATION OF LIABILITY",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "To the fullest extent permitted by applicable law, in no event will the Operator, its affiliates, or licensors be liable to any person for any indirect, incidental, special, punitive, cover or consequential damages (including, without limitation, damages for use of content) however caused, under any theory of liability, including, without limitation, contract, tort, warranty, breach of statutory duty, negligence or otherwise, even if the liable party has been advised as to the possibility of such damages or could have foreseen such damages. The limitations and exclusions also apply if this remedy does not fully compensate you for any losses or fails of its essential purpose. \n",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "CHANGES AND AMMENDMENTS",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "We reserve the right to modify this Agreement or its terms relating to the WAP App and Services at any time, effective upon posting of an updated version of this Agreement in the WAP App. When we do, we will send you an email to notify you. Continued use of the WAP App and Services after any such changes shall constitute your consent to such changes. \n",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "CONTACT US",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "If you would like to contact us to understand more about this Agreement or wish to contact us concerning any matter relating to it, you may send an email to weadoptpets@gmail.com. \n\nThis document was last updated on March 22, 2021.",
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                            fontFamily: 'Montserrat'),
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ));
                              }),
                        ),
                      ),
                      SizedBox(height: 10),
                      MaterialButton(
                          color: Colors.teal[100],
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          child: Text("Done",
                              style: TextStyle(fontFamily: 'Montserrat')),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
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
