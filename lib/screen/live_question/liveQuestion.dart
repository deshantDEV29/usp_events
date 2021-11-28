// ignore: import_of_legacy_library_into_null_safe
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LiveQuestion extends StatelessWidget {
  //final Map<String, dynamic> userMap;
  final String sessionId;
  final String username;

  LiveQuestion({
    required this.sessionId,
    required this.username,
  });

  DateTime now = DateTime.now();

  final TextEditingController _question = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void onSendQuestion() async {
    if (_question.text.isNotEmpty) {
      Map<String, dynamic> questions = {
        "sendby": username,
        "message": _question.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };

      _question.clear();
      await _firestore
          .collection('liveQuestionRoom')
          .doc(sessionId)
          .collection('questions')
          .add(questions);
    } else {
      print("Ask a Question");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text('Live Session'), //StreamBuilder<DocumentSnapshot>(
        //   stream: _firestore.collection("users").doc(username).snapshots(),
        //   builder: (context, snapshot) {
        //     if (snapshot.data != null) {
        //       return Container(
        //         child: Column(
        //           children: [
        //             Text(recipient),
        //             Text(
        //               snapshot.data!['status'],
        //               style: TextStyle(fontSize: 14),
        //             ),
        //           ],
        //         ),
        //       );
        //     } else {
        //       return Container();
        //     }
        //   },
        // ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('liveQuestionRoom')
                    .doc(sessionId)
                    .collection('questions')
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
                        return messages(size, map, context);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextField(
                        controller: _question,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {}, // => getImage(),
                              icon: Icon(Icons.photo),
                            ),
                            hintText: "Send Message",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.send), onPressed: onSendQuestion),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
    return map['type'] == "text"
        ? Container(
            width: size.width,
            // alignment: map['sendby'] == username
            //     ? Alignment.centerRight
            //     : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.blue,
              ),
              child: ListTile(
                leading: Icon(Icons.person_rounded),
                title: Text(
                  '${map['sendby']}\n${(map['time'] as Timestamp).toDate().toString().substring(11, 16)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                subtitle: Text('${map['message']}'),
              ),
            ),
          )
        : Container(
            height: size.height / 2.5,
            width: size.width,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            alignment:
                map['sendby'] ? Alignment.centerRight : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ShowImage(
                    imageUrl: map['message'],
                  ),
                ),
              ),
              child: Container(
                height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
                alignment: map['message'] != "" ? null : Alignment.center,
                child: map['message'] != ""
                    ? Image.network(
                        map['message'],
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
              ),
            ),
          );
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
