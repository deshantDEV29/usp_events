import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/screen/drawer/drawer_state.dart';

class PollScreen extends StatefulWidget {
  static const String routeName = '/pollPage';

  const PollScreen({Key? key}) : super(key: key);

  @override
  State<PollScreen> createState() => _pollPageState();
}

Future<Poll> fetchPoll() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var getToken = localStorage.getString('token');
  var token = 'Bearer $getToken';
  var response = await CallApi().getData(token, 'getpolllist');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Poll.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Poll {
  final int id;
  final String question;
  final String option1;
  final String option2;

  Poll(
      {required this.id,
      required this.question,
      required this.option1,
      required this.option2});

  factory Poll.fromJson(Map<String, dynamic> json) {
    return Poll(
        id: json['id'],
        question: json['question'],
        option1: json['option1'],
        option2: json['option2']);
  }
}

enum OptionCharacter { option_1, option_2 }

class _pollPageState extends State<PollScreen> {
  late Future<Poll> futurePoll;
  OptionCharacter? _character = OptionCharacter.option_1;

  @override
  void initState() {
    super.initState();
    futurePoll = fetchPoll();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("Poll Page"),
      ),
      drawer: AppDrawer(),
      body: Center(
          child: FutureBuilder<Poll>(
        future: futurePoll,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Card(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      height: 220,
                      color: Colors.white,
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data!.id.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.question,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Column(children: [
                                    ListTile(
                                      title: Text(snapshot.data!.option1),
                                      leading: Radio<OptionCharacter>(
                                        value: OptionCharacter.option_1,
                                        groupValue: _character,
                                        onChanged: (OptionCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(snapshot.data!.option2),
                                      leading: Radio<OptionCharacter>(
                                        value: OptionCharacter.option_2,
                                        groupValue: _character,
                                        onChanged: (OptionCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                      ),
                                    ),
                                  ]),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(8.0),
                                      primary: Colors.blue,
                                      textStyle: const TextStyle(fontSize: 20),
                                    ),
                                    onPressed: () {},
                                    child: const Text('Vote'),
                                  ),
                                ],
                              ),
                            ),
                            flex: 8,
                          ),
                        ],
                      ),
                    ),
                    elevation: 10,
                    margin: EdgeInsets.all(20),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white)),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(
                      height: 16.0,
                    ));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      )),
    );
  }
}
