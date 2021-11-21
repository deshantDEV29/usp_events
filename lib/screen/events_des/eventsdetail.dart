import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/events.dart';
import 'package:usp_events/model/eventstitle.dart';
import 'package:usp_events/screen/live_question/SessionScreen.dart';

import '../drawer/drawer_state.dart';

class EventDetail extends StatefulWidget {
  const EventDetail({Key? key, required this.eventsTitle}) : super(key: key);
  final EventsTitle eventsTitle;

  _EventDetail createState() => _EventDetail();
}

class _EventDetail extends State<EventDetail> {
  List<Events> events = <Events>[];

  Future<List<Events>> displayEvent() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';
    //var title = widget.eventsTitle.title;

    var data = {
      'title': widget.eventsTitle.title,
    };

    var response = await CallApi().postEventData(data, 'displayDetails', token);

    var notes = <Events>[];

    if (response.statusCode == 200) {
      var datasJson = json.decode(response.body);
      for (var dataJson in datasJson) {
        notes.add(Events.fromJson(dataJson));
      }

      return notes;
    } else
      print("http error");
    return [];
  }

  @override
  void initState() {
    displayEvent().then((value) {
      setState(() {
        events.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("Event Info"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<List<Events>>(
          future: displayEvent(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                child: Center(child: CircularProgressIndicator()),
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
                          padding: EdgeInsets.symmetric(vertical: 0.0),
                          child: ListTile(
                            title: Text(
                              "${events[index].title}",
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 0.0,
                            horizontal: 10.0,
                          ),
                          child: ListTile(
                            title: Text(
                              "\" ${events[index].theme}\" ",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          child: ListTile(
                            title: Text(
                              "${events[index].eventSchedule}\n\n${events[index].eventDescription}",
                              style: TextStyle(
                                fontSize: 20.0,
                                // fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 10.0,
                            ),
                            child: ListTile(
                              title: Text(
                                "\nVenue\n${events[index].venue}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 10.0,
                            ),
                            child: ListTile(
                              title: Text(
                                "Speaker",
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                              subtitle: Text(
                                "${events[index].speaker}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30.0, horizontal: 10.0),
                          child: MaterialButton(
                            splashColor: Colors.blue.shade900,
                            color: Colors.deepOrangeAccent.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                  color: Colors.deepOrangeAccent.shade200,
                                  width: 2.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            child: Text(
                              "Join Session",
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          SessionScreen(event: events[index])));
                            },
                          ),
                        )
                      ]);
                },
                itemCount: snapshot.data!.length,
              );
            else
              return Text("impliment more");
          }),
    );
  }
}
