import 'package:flutter/material.dart';
import 'package:usp_events/screen/drawer/drawer_state.dart';

class LiveQuestion extends StatefulWidget {
  _LiveQuestionState createState() => _LiveQuestionState();
}

class _LiveQuestionState extends State<LiveQuestion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("Live Question Session"),
      ),
      drawer: AppDrawer(),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (BuildContext context, int idx) {
              return Card(
                elevation: 2.0,
                color: Colors.amber.shade200,
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: ListTile(
                    leading: Icon(Icons.mic),
                    title: new Center(
                      child: new Text(
                        "Session " + idx.toString(),
                        style: new TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25.0,
                            color: Colors.black),
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
