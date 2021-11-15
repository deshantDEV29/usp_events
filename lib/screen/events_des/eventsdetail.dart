import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/events.dart';
import 'package:usp_events/model/eventstitle.dart';

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
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 10.0),
                            child: ListTile(
                              shape: Border(
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.grey),
                              ),
                              title: Text(
                                "Event Schedule",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                "${events[index].eventSchedule}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
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
                              shape: Border(
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.grey),
                              ),
                              title: Text(
                                "Venue",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                "${events[index].venue}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
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
                              shape: Border(
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.grey),
                              ),
                              title: Text(
                                "Theme",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                "\" ${events[index].theme}\" ",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
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
                              shape: Border(
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.grey),
                              ),
                              title: Text(
                                "Speaker",
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                "${events[index].speaker}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 10.0),
                          child: ListTile(
                            title: Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.fade,
                            ),
                            subtitle: Text(
                              "${events[index].eventDescription}",
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.fade,
                            ),
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
