import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/events.dart';
import 'package:usp_events/model/eventstitle.dart';
import 'package:usp_events/model/session.dart';

import '../drawer/drawer_state.dart';
import 'liveQuestion.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({Key? key, required this.event}) : super(key: key);
  final Events event;

  _SessionScreen createState() => _SessionScreen();
}

class _SessionScreen extends State<SessionScreen> {
  List<Session> session = <Session>[];
  String finalusername = "";

  Future<List<Session>> displaySession() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';
    var getusername = localStorage.getString('username');
    var splitusername = getusername!.split(":");
    String getusernameatindex = splitusername.elementAt(1);
    String username = getusernameatindex.replaceAll('"', '');
    finalusername = username.replaceAll('}', '');
    print(finalusername);

    var data = {
      'id': widget.event.eventid,
    };

    var response = await CallApi().postEventData(data, 'getSessions', token);

    print(response.body);
    var notes = <Session>[];

    if (response.statusCode == 200) {
      final datasJson = json.decode(response.body)["sessions"] as List;
      return datasJson.map((js) => Session.fromJson(js)).toList();
    } else
      print("http error");
    return [];
  }

  String sessionID(int eventID, int sessionID) {
    return "$eventID$sessionID";
  }

  @override
  void initState() {
    displaySession().then((value) {
      setState(() {
        session.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("Session"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<List<Session>>(
          future: displaySession(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );

            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done)
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: ListTile(
                          leading: Icon(Icons.link),
                          title: Text(
                            "${session[index].date} at ${session[index].time} (FJT)",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                color: Colors.green),
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Text(
                            "",
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            String roomId = sessionID(
                                session[index].eventid, session[index].id);
                            print(roomId);
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => LiveQuestion(
                                  sessionId: roomId,
                                  username: finalusername,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                itemCount: snapshot.data!.length,
              );
            else
              return Text("impliment more");
          }),
    );
  }
}
