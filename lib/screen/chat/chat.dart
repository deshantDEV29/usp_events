import 'package:flutter/material.dart';
import 'package:usp_events/screen/drawer/drawer_state.dart';

class Chat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan.shade600,
        title: Text("Chats"),
      ),
      drawer: AppDrawer(),
    );
  }
}
