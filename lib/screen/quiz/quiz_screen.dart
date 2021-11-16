import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/quiz.dart';
import 'package:usp_events/screen/quiz/quizAttempt.dart';

import '../drawer/drawer_state.dart';
import 'questions_screen.dart';

class QuizScreen extends StatefulWidget {
  _QuizScreen createState() => _QuizScreen();
}

class _QuizScreen extends State<QuizScreen> {
  List<Quiz> _quiz = <Quiz>[];
  int userID = 0;

  Future<List<Quiz>> getQuiz() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';
    var response = await CallApi().getData(token, 'getQuiz');
    var getuser = localStorage.getString('user');
    String userid = getuser!.substring(6, getuser.indexOf(','));
    userID = int.parse(userid);

    if (response.statusCode == 200) {
      final datasJson = json.decode(response.body)["quizzes"] as List;
      return datasJson.map((js) => Quiz.fromJson(js)).toList();
    } else
      print("http error");
    return [];
  }

  String quizAttemptId(int quizID, int userID) {
    print("$quizID$userID");
    return "$quizID$userID";
  }

  @override
  void initState() {
    getQuiz().then((value) {
      setState(() {
        _quiz.addAll(value);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("Quiz"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder<List<Quiz>>(
        future: getQuiz(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
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
                      title: Text(_quiz[index].name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center),
                      onTap: () {
                        String quizAttemptRoom =
                            quizAttemptId(_quiz[index].id, userID);
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => QuizAttempt(
                                      quizID: _quiz[index],
                                      quizAttemptID: quizAttemptRoom,
                                    )));
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
        },
      ),
    );
  }
}
