import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/methods/method.dart';
import 'package:usp_events/screen/FAQ/faq.dart';
import 'package:usp_events/screen/chat/chat.dart';
import 'package:usp_events/screen/events_des/homepage.dart';
import 'package:usp_events/screen/poll/pollScreen.dart';
import 'package:usp_events/screen/quiz/quiz_screen.dart';
import 'package:usp_events/screen/sign_up/login.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String finalusername = '';
  String finalemail = '';
  var firebaseUser = FirebaseAuth.instance.currentUser!;
  final FirebaseFirestore database = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    var userData = currentUserData;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountEmail: Text(userData.userEmail),
            accountName: Text(userData.userName),
            decoration: BoxDecoration(
              color: Colors.cyan,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage("assets/images/user.png"),
              backgroundColor: Colors.grey,
            ),
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: const Text('Events'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Homepage();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.chat_bubble),
            title: const Text('Chat'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ChatScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.quiz_rounded),
            title: const Text('Quiz'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return QuizScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.poll),
            title: const Text('Poll'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PollScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: const Text('FAQ'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return FAQScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: logout,
          ),
        ],
      ),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString('token');
    var token = 'Bearer $data';
    print(token);
    logOut();

    var res = await CallApi().logoutPostData(token, 'logout');
    var body = json.decode(res.body);
    print(body);

    if (body['success'] == true) {
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Login()));
    }
  }
}
