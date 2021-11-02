import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/screen/chat/chat.dart';
import 'package:usp_events/screen/events_des/homepage.dart';
import 'package:usp_events/screen/live_question/live_question.dart';
import 'package:usp_events/screen/quiz/quiz_screen.dart';
import 'package:usp_events/screen/sign_up/login.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  void getUsername() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var data = localStorage.getString('user');
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountEmail: Text('@User'),
            accountName: Text('user'),
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
            leading: Icon(Icons.mic),
            title: const Text('Live Question Session'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LiveQuestion();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.save),
            title: const Text('Saved'),
            onTap: getUsername,
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
            leading: Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {},
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
