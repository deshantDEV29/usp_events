import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/api/api.dart';
import 'package:usp_events/model/question.dart';
import 'package:usp_events/model/quiz.dart';
import 'package:usp_events/screen/quiz/questions_screen.dart';
import 'package:usp_events/screen/quiz/score.dart';

import '../drawer/drawer_state.dart';

class QuizAttempt extends StatelessWidget {
  QuizAttempt({Key? key, required this.quizID, required this.quizAttemptID})
      : super(key: key);
  final Quiz quizID;
  final String quizAttemptID;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text(quizID.name),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('quizAttemptRoom')
                    .doc(quizAttemptID)
                    .collection('quizAttempt')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return score(size, map, context, index);
                      },
                    );
                  } else {
                    return Container(child: Text("No attempts"));
                  }
                },
              ),
            ),
            Container(
              child: MaterialButton(
                  splashColor: Colors.blue.shade900,
                  color: Colors.deepOrangeAccent.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                        color: Colors.deepOrangeAccent.shade200, width: 2.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  child: Text(
                    "Start Attempt",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => QuestionsScreen(
                          quizID: quizID,
                          quizAttemptId: quizAttemptID,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget score(
      Size size, Map<String, dynamic> map, BuildContext context, int index) {
    return map['type'] == "text"
        ? Container(
            width: size.width,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: Text(
                "Attempt $index Your final mark for this quiz  ${map['score']}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment: map['sendby'] == _auth.currentUser!.displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
          );
  }
}
