import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/eventstitle.dart';
import 'package:usp_events/model/faq.dart';

import '../drawer/drawer_state.dart';

class FAQScreen extends StatefulWidget {
  _FAQScreen createState() => _FAQScreen();
}

class _FAQScreen extends State<FAQScreen> {
  List<FAQ> _faq = <FAQ>[];

  Future<List<FAQ>> displayFAQ() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';
    var response = await CallApi().getData(token, 'displayFAQ');
    if (response.statusCode == 200) {
      final datasJson = json.decode(response.body)["FAQ"] as List;
      return datasJson.map((js) => FAQ.fromJson(js)).toList();
    } else
      print("http error");
    return [];
  }

  @override
  void initState() {
    displayFAQ().then((value) {
      setState(() {
        _faq.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("FAQ"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<List<FAQ>>(
          future: displayFAQ(),
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
                        title: Text(_faq[index].question,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.justify),
                        subtitle: Text(
                          _faq[index].answer,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey.shade700),
                        ),
                      ),
                    ),
                    color: Colors.tealAccent.shade100,
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
