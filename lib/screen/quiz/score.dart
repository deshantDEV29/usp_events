import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/question.dart';
import 'package:usp_events/model/quiz.dart';
import 'package:usp_events/screen/quiz/quiz_screen.dart';

import '../drawer/drawer_state.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({
    Key? key,
    required this.quizID,
    required this.score,
  }) : super(key: key);
  final int quizID;
  final double score;

  _ScoreScreen createState() => _ScoreScreen();
}

class _ScoreScreen extends State<ScoreScreen> {
  List<Question> _question = <Question>[];
  int quizid = 0;

  Future<List<Question>> getQuestion() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';

    var data = {
      'id': widget.quizID,
    };
    quizid = widget.quizID;

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
        title: Text("Review"),
      ),
      drawer: AppDrawer(),
      body: projectWidget(),
    );
  }

  Widget projectWidget() {
    return FutureBuilder<List<Question>>(
      future: getQuestion(),
      builder: (context, snapshot) {
        if (snapshot.data == null)
          return Container(
            child: Center(
              child: Text("Loading..."),
            ),
          );

        // if (snapshot.hasError)
        //   return Text(snapshot.error.toString());
        // // else
        else
          return Row(
            children: [
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                      ),
                      child: ListTile(
                        title: Text(
                          "Score: ${widget.score.round()} %",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 15.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.tealAccent.shade100,
                                ),
                                color: Colors.tealAccent.shade100,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0.0),
                                      child: ListTile(
                                        title: Text(
                                          "${index + 1})  ${_question[index].question}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 0.0),
                                      child: ListTile(
                                        title: Text(
                                          "Answer: ${_question[index].answer}",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
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
                        vertical: 15.0,
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => QuizScreen()));
                        },
                        minWidth: 250.0,
                        splashColor: Colors.blue.shade900,
                        color: Colors.deepOrangeAccent.shade200,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(
                                color: Colors.deepOrangeAccent.shade200,
                                width: 2.0)),
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: Text(
                          'Finish Review',
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
      },
    );
  }
}
