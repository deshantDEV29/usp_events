import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: import_of_legacy_library_into_null_safe
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/chats.dart';
import 'package:usp_events/model/recipient.dart';

import '../drawer/drawer_state.dart';

class Conversation extends StatefulWidget {
  const Conversation({Key? key, required this.recipient}) : super(key: key);
  final Recipient recipient;

  _Conversation createState() => _Conversation();
}

class _Conversation extends State<Conversation> {
  List<Chats> chats = <Chats>[];
  TextEditingController messageController = TextEditingController();

  Future<List<Chats>> displayChat() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';
    //var title = widget.eventsTitle.title;

    var data = {
      'userid_2': widget.recipient.id,
    };

    var response = await CallApi().postEventData(data, 'getMessage', token);

    var notes = <Chats>[];

    if (response.statusCode == 200) {
      var datasJson = json.decode(response.body);
      for (var dataJson in datasJson) {
        notes.add(Chats.fromJson(dataJson));
      }

      return notes;
    } else
      print("http error");
    return [];
  }

  @override
  void initState() {
    displayChat().then((value) {
      setState(() {
        chats.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text(widget.recipient.name),
      ),
      //drawer: AppDrawer(),
      body: FutureBuilder<List<Chats>>(
        future: displayChat(),
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
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 0.0,
                              ),
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0.0),
                                        child: Container(
                                          padding: EdgeInsets.only(
                                              left: 14,
                                              right: 14,
                                              top: 10,
                                              bottom: 10),
                                          child: Align(
                                            alignment:
                                                (chats[index].recieverid ==
                                                        widget.recipient.id
                                                    ? Alignment.topRight
                                                    : Alignment.topLeft),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color:
                                                    (chats[index].recieverid ==
                                                            widget.recipient.id
                                                        ? Colors.grey.shade200
                                                        : Colors.blue[200]),
                                              ),
                                              padding: EdgeInsets.all(16),
                                              child: Text(
                                                chats[index].message,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
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
                            vertical: 15.0, horizontal: 0.0),
                        child: ListTile(
                          leading: Column(
                            children: <Widget>[
                              Container(
                                  width: 280.0,
                                  child: TextField(
                                    autocorrect: false,
                                    autofocus: false,
                                    obscureText: false,
                                    style: TextStyle(fontSize: 20.0),
                                    controller: messageController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      hintText: "message",
                                      filled: true,
                                      fillColor: Colors.grey.shade200,
                                      contentPadding: EdgeInsets.all(15.0),
                                    ),
                                  ))
                            ],
                          ),
                          trailing: Column(
                            children: <Widget>[
                              Container(
                                width: 50.0,
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.white, width: 2.0),
                                  ),
                                  onPressed: sendMessage,
                                  child: Icon(Icons.send),
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
      ),
    );
  }

  void sendMessage() async {
    var data = {
      'reciever_id': widget.recipient.id,
      'message': messageController.text
    };

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';

    var res = await CallApi().postEventData(data, 'sendmessage', token);
    var body = json.decode(res.body);
    print(body);

    if (res.statusCode == 200) {
      print(body['message']);
    } else {
      print(body['message']);
    }
    messageController.clear();
  }
}
