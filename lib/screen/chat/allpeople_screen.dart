import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/people.dart';
import 'package:usp_events/model/recipient.dart';

import '../drawer/drawer_state.dart';
import 'chat.dart';
import 'conversation.dart';
import 'people_screen.dart';

class AllPeoplescreen extends StatefulWidget {
  _AllPeoplescreen createState() => _AllPeoplescreen();
}

class _AllPeoplescreen extends State<AllPeoplescreen> {
  List<Recipient> _recipient = <Recipient>[];
  int userID = 0;
  String finalusername = '';

  Future<List<Recipient>> getAllUsers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    print(getToken);
    var token = 'Bearer $getToken';

    var getuser = localStorage.getString('user');
    var getusername = localStorage.getString('username');
    var splitusername = getusername!.split(":");
    String getusernameatindex = splitusername.elementAt(1);
    String username = getusernameatindex.replaceAll('"', '');
    finalusername = username.replaceAll('}', '');
    print(finalusername);

    //userID = getuser!.substring(6, getuser.indexOf(',')) as int;
    print(userID);
    print("hello");

    String userid = getuser!.substring(6, getuser.indexOf(','));
    userID = int.parse(userid);

    var response = await CallApi().getData(token, 'displayAllUsers');
    print(response.body);

    if (response.statusCode == 200) {
      final datasJson = json.decode(response.body)["users"] as List;
      return datasJson.map((js) => Recipient.fromJson(js)).toList();
    } else
      print("http error"); 
    return [];
  }

  String chatRoomId(int user1, int user2) {
    if (user1 > user2) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  void initState() {
    getAllUsers().then((value) {
      setState(() {
        _recipient.addAll(value);
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
    return FutureBuilder<List<Recipient>>(
      future: getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return Container(
            child: Center(
              child: Text("Loading..."),
            ),
          );
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
                                      return AllPeoplescreen();
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
                                      onTap: () {
                                        String roomId = chatRoomId(
                                            userID, _recipient[index].id);
                                        print(roomId);
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) => Conversation(
                                              chatRoomId: roomId,
                                              recipient: _recipient[index].name,
                                              username: finalusername,
                                            ),
                                          ),
                                        );
                                      },
                                      leading: Icon(Icons.person_rounded),
                                      shape: Border(
                                        bottom: BorderSide(
                                            width: 0.5, color: Colors.grey),
                                      ),
                                      title: Text(
                                        "${_recipient[index].name}",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ),
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
