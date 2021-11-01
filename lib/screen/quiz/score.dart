import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/question.dart';
import 'package:usp_events/model/quiz.dart';

import '../drawer/drawer_state.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key, required this.quizID}) : super(key: key);
  final Question quizID;

  _ScoreScreen createState() => _ScoreScreen();
}

class _ScoreScreen extends State<ScoreScreen> {
  List<Question> _question = <Question>[];
  int score = 0;
  String userAnswer = "";

  Future<List<Question>> getQuestion() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';
    //var title = widget.eventsTitle.title;

    var data = {
      'id': widget.quizID.id,
    };

    var response = await CallApi().postEventData(data, 'getQuestions', token);

    if (response.statusCode == 200) {
      final datasJson = json.decode(response.body)["questions"] as List;
      return datasJson.map((js) => Question.fromJson(js)).toList();
    } else
      print("http error");
    return [];
  }

  @override
  void initState() {
    getQuestion().then((value) {
      setState(() {
        _question.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
       // title: Text(),
      ),
      drawer: AppDrawer(),
     
    );
  }

}
