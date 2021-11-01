import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/question.dart';
import 'package:usp_events/model/quiz.dart';
import 'package:usp_events/screen/quiz/score.dart';

import '../drawer/drawer_state.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({Key? key, required this.quizID}) : super(key: key);
  final Quiz quizID;

  _Questions createState() => _Questions();
}

class _Questions extends State<QuestionsScreen> {
  List<Question> _question = <Question>[];
  String userAnswer = "";
  int Quiz_id = 0;

  Future<List<Question>> getQuestion() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var getToken = localStorage.getString('token');
    var token = 'Bearer $getToken';

    var data = {
      'id': widget.quizID.id,
    };
    Quiz_id = widget.quizID.id;

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
        title: Text(widget.quizID.name),
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
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 0.0, horizontal: 10.0),
                                    child: RadioListTile(
                                      value: _question[index].option_1,
                                      groupValue: _question[index]
                                          .response, //selectedUser,
                                      title: Text(_question[index].option_1),
                                      onChanged: (value) {
                                        this.setState(
                                          () {
                                            _question[index].setResponse =
                                                value as String;
                                          },
                                        );
                                      },
                                      // selected: selectedUser == user,
                                      activeColor: Colors.green,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0.0,
                                      horizontal: 10.0,
                                    ),
                                    child: RadioListTile(
                                      value: _question[index].option_2,
                                      groupValue: _question[index]
                                          .response, //selectedUser,
                                      title: Text(_question[index].option_2),
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            _question[index].setResponse =
                                                value as String;
                                          },
                                        );
                                      },
                                      // selected: selectedUser == user,
                                      activeColor: Colors.green,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0.0,
                                      horizontal: 10.0,
                                    ),
                                    child: RadioListTile(
                                      value: _question[index].option_3,
                                      groupValue: _question[index]
                                          .response, //selectedUser,
                                      title: Text(_question[index].option_3),
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            _question[index].setResponse =
                                                value as String;
                                          },
                                        );
                                      },
                                      // selected: selectedUser == user,
                                      activeColor: Colors.green,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0.0,
                                      horizontal: 10.0,
                                    ),
                                    child: RadioListTile(
                                      value: _question[index].option_4,
                                      groupValue: _question[index]
                                          .response, //selectedUser,
                                      title: Text(_question[index].option_4),
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            _question[index].setResponse =
                                                value as String;
                                          },
                                        );
                                      },
                                      // selected: selectedUser == user,
                                      activeColor: Colors.green,
                                    ),
                                  ),
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
                        onPressed: _submit,
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
                          'Finish',
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

  void _submit() async {
    setState(() {
      //_isLoading = true;
    });
    int score = 0;
    int total = _question.length;

    for (var dataJson in _question) {
      print(dataJson.response);
      if (dataJson.response == dataJson.answer) {
        score++;
        print('correct');
      } else {
        print('incorrect');
      }
    }
    double finalscore = (score / total) * 100;
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) =>
                ScoreScreen(quizID: Quiz_id, score: finalscore)));
    print(finalscore);
  }
}
