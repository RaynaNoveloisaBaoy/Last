import 'package:flutter/material.dart';
import 'package:wap/register_page1.dart';
import 'package:wap/register_page2.dart';

class RegisterAccount extends StatefulWidget {
  @override
  _RegisterAccountState createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.teal[400],
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
            margin: EdgeInsets.only(top: 40),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Image.asset(
                        'assets/images/dog.png',
                        matchTextDirection: true,
                        fit: BoxFit.fill,
                        height: 350,
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PersonalRegisterPage())),
                          color: Colors.teal[100],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text("Personal Account",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  fontFamily: 'Montserrat')),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 50,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      InstitutionRegisterPage())),
                          color: Colors.teal[100],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text("Institutional Account",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  fontFamily: 'Montserrat')),
                        ),
                      ),
                    ),
                  ]),
            ])));
  }
}
