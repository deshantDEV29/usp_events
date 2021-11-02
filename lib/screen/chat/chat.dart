import 'package:flutter/material.dart';
import 'package:usp_events/screen/drawer/drawer_state.dart';

import 'people_screen.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("Chats"),
      ),
      drawer: AppDrawer(),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 15.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.tealAccent.shade100,
                            ),
                            color: Colors.tealAccent.shade100,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 0.0),
                                child: ListTile(
                                  title: Text(
                                    "chat",
                                    style: TextStyle(
                                      fontSize: 30.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
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
      ),
    );
  }
}
