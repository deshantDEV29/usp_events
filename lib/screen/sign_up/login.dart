import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';

import '../events_des/homepage.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

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
                padding: EdgeInsets.all(40.0),
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
                      height: 400.0,
                      width: 380.0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 25.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 25.0,
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
                          TextField(
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
                                Icons.vpn_key,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 15.0,
                            ),
                            child: MaterialButton(
                              onPressed: _isLoading ? null : _login,
                              minWidth: 250.0,
                              splashColor: Colors.blue.shade900,
                              color: Colors.blue,
                              padding: EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Text(
                                _isLoading ? 'Logging...' : 'Login',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Signup();
                                  },
                                ),
                              );
                            },
                            minWidth: 250.0,
                            child: Text(
                              "Click to Signup",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
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

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    var data = {
      'email': emailController.text,
      'password': passwordController.text
    };

    var res = await CallApi().postData(data, 'login');
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      _showMsg(body['message']);
      print(body['message']);
    }

    setState(() {
      _isLoading = false;
    });
    //print(body);
  }
}
