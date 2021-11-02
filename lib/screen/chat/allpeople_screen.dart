import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/people.dart';
import 'package:usp_events/model/question.dart';
import 'package:usp_events/model/quiz.dart';
import 'package:usp_events/screen/quiz/score.dart';

import '../drawer/drawer_state.dart';
import 'chat.dart';
import 'people_screen.dart';

class AllPeople_screen extends StatefulWidget {
  _AllPeople_screen createState() => _AllPeople_screen();
}

class _AllPeople_screen extends State<AllPeople_screen> {
  List<People> _Allpeople = <People>[];

  Future<List<People>> getActiveUsers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';

    var response = await CallApi().getData(token, 'displayAllUsers');
    print(response.body);

    if (response.statusCode == 200) {
      final datasJson = json.decode(response.body)["users"] as List;
      return datasJson.map((js) => People.fromJson(js)).toList();
    } else
      print("http error");
    return [];
  }

  @override
  void initState() {
    getActiveUsers().then((value) {
      setState(() {
        _Allpeople.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("People"),
      ),
      drawer: AppDrawer(),
      body: projectWidget(),
    );
  }

  Widget projectWidget() {
    return FutureBuilder<List<People>>(
      future: getActiveUsers(),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return Container(
            child: Center(
              child: Text("Loading..."),
            ),
          );

        // if (snapshot.hasError)
        //   return Text(snapshot.error.toString());
        // // else
        else
          return Row(
            children: [
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 30.0),
                      child: ListTile(
                        leading: Column(
                          children: <Widget>[
                            MaterialButton(
                              splashColor: Colors.blue.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Colors.deepOrangeAccent.shade200,
                                    width: 2.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "Active",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PeopleScreen();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AllPeople_screen();
                                    },
                                  ),
                                );
                              },
                              color: Colors.deepOrangeAccent.shade200,
                              splashColor: Colors.blue.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Colors.deepOrangeAccent.shade200,
                                    width: 2.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                "People",
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
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 3.0,
                            ),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0.0),
                                      child: ListTile(
                                        leading: Icon(Icons.person_rounded),
                                        shape: Border(
                                          bottom: BorderSide(
                                              width: 0.5, color: Colors.grey),
                                        ),
                                        title: Text(
                                          "${_Allpeople[index].name}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Column(
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ChatScreen();
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.chat_bubble_rounded),
                                  Text("Chats")
                                ],
                              ),
                            ),
                          ],
                        ),
                        trailing: Column(
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PeopleScreen();
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                // Replace with a Row for horizontal icon + text
                                children: <Widget>[
                                  Icon(Icons.people_alt_rounded),
                                  Text("People")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
      },
    );
  }
}
