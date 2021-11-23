import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/methods/method.dart';
import 'package:usp_events/model/eventstitle.dart';

import '../drawer/drawer_state.dart';
import 'eventsdetail.dart';

class Homepage extends StatefulWidget {
  _Homepage createState() => _Homepage();
}

class _Homepage extends State<Homepage> {
  List<EventsTitle> _events = <EventsTitle>[];

  Future<List<EventsTitle>> displayDetails() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';
    var response = await CallApi().getData(token, 'displayEvents');
    if (response.statusCode == 200) {
      final datasJson = json.decode(response.body)["events"] as List;
      return datasJson.map((js) => EventsTitle.fromJson(js)).toList();
    } else
      print("http error");
    return [];
  }

  @override
  void initState() {
    displayDetails().then((value) {
      setState(() {
        _events.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("Events"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<List<EventsTitle>>(
          future: displayDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: 340.0,
                                height: 10.0,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                // CircularProgressIndicator()
                itemCount: 7,
              );

            if (snapshot.hasError)
              return Text(snapshot.error.toString());
            else if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done)
              return ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(_events[index].title,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center),
                        subtitle: Text(
                          _events[index].eventSchedule,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => EventDetail(
                                      eventsTitle: _events[index])));
                        },
                      ),
                    ),
                    color: Colors.amber.shade300,
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
