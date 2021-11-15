import 'package:flutter/material.dart';
import 'package:usp_events/model/recipient.dart';
import 'package:usp_events/screen/drawer/drawer_state.dart';

import 'conversation.dart';
import 'people_screen.dart';

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';

import '../drawer/drawer_state.dart';

class ChatScreen extends StatefulWidget {
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  List<Recipient> _recipient = <Recipient>[];
  String username = '';

  Future<List<Recipient>> getReciepients() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';
    var getuser = localStorage.getString('user');
    String turntoString = getuser.toString();
    print(turntoString);
    String splituser = turntoString.split(",") as String;
    username = splituser.substring(2);

    print(splituser);

    var response = await CallApi().getData(token, 'getConversation');

    if (response.statusCode == 200) {
      final datasJson = json.decode(response.body)["reciepients"] as List;

      return datasJson.map((js) => Recipient.fromJson(js)).toList();
    } else
      print("http error");
    return [];
  }

  String chatRoomId(String user1, String otheruser) {
    String user2 = otheruser.toString();
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  void initState() {
    getReciepients().then((value) {
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
        title: Text("Chats"),
      ),
      drawer: AppDrawer(),
      body: projectWidget(),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
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
      ),
    );
  }

  Widget projectWidget() {
    return FutureBuilder<List<Recipient>>(
      future: getReciepients(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Center(
              child: Text("Loading...."),
            ),
          );
        }
        if (snapshot.data == null)
          return Container(
            child: Center(
              child: Text("No message"),
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
                                        "${_recipient[index].name}",
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                      subtitle: Text('message'),
                                      onTap: () {
                                        // String roomId = chatRoomId(
                                        //     username, _recipient[index].name);
                                        // Navigator.push(
                                        //     context,
                                        //     new MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             Conversation(
                                        //               chatRoomId: roomId,
                                        //               userMap: {},
                                        //             )));
                                      },
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
                  ],
                ),
              ),
            ],
          );
      },
    );
  }
}
