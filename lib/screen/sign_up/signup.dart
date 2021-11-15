import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/methods/method.dart';

import '../events_des/homepage.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.cyan.shade600,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Image.asset(
                  'assets/images/USP2.png',
                  height: 200.0,
                  width: 250.0,
                ),
              ),
              Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                      height: 450.0,
                      width: 380.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 15.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ////////////////// NAME //////////////////////
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: TextField(
                              autocorrect: false,
                              autofocus: false,
                              style: TextStyle(fontSize: 20.0),
                              controller: nameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Name",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: EdgeInsets.all(15.0),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          ///////////////  Email  /////////////////
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: TextField(
                              autocorrect: false,
                              autofocus: false,
                              style: TextStyle(fontSize: 20.0),
                              controller: emailController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Email",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: EdgeInsets.all(15.0),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          //////////////  Phone /////////////////
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: TextField(
                              autocorrect: false,
                              autofocus: false,
                              style: TextStyle(fontSize: 20.0),
                              controller: phoneController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Phone",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: EdgeInsets.all(15.0),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),

                          ////////////////  Password  //////////////des
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: TextField(
                              autocorrect: false,
                              autofocus: false,
                              obscureText: true,
                              style: TextStyle(fontSize: 20.0),
                              controller: passwordController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Password",
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: EdgeInsets.all(15.0),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.0,
                            ),
                            child: MaterialButton(
                              minWidth: 250.0,
                              splashColor: Colors.blue.shade900,
                              color: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Text(
                                _isLoading ? 'Creating...' : 'Register',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: _isLoading ? null : _handleLogin,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                MaterialButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Login();
                                        },
                                      ),
                                    );
                                  },
                                  minWidth: 20.0,
                                  child: Text(
                                    "click to Login",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleLogin() async {
    createAccount(
      nameController.text,
      emailController.text,
      passwordController.text,
    );
    setState(() {
      _isLoading = true;
    });

    var data = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'password': passwordController.text,
    };

    var res = await CallApi().postData(data, 'register');
    var body = json.decode(res.body);

    if (res.statusCode == 201) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Homepage()));
    }

    setState(() {
      _isLoading = false;
    });
  }
}
