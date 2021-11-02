import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/people.dart';

import '../drawer/drawer_state.dart';
import 'allpeople_screen.dart';
import 'chat.dart';

class PeopleScreen extends StatefulWidget {
  _PeopleScreen createState() => _PeopleScreen();
}

class _PeopleScreen extends State<PeopleScreen> {
  List<People> _people = <People>[];

  Future<List<People>> getActiveUsers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';

    var response = await CallApi().getData(token, 'displayActiveUsers');

    if (response.statusCode == 200) {
      final datasJson =
          json.decode(response.body)["personal_access_tokens"] as List;
      return datasJson.map((js) => People.fromJson(js)).toList();
    } else
      print("http error");
    return [];
  }

  @override
  void initState() {
    getActiveUsers().then((value) {
      setState(() {
        _people.addAll(value);
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
                              color: Colors.deepOrangeAccent.shade200,
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
                                          "${_people[index].name}",
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
