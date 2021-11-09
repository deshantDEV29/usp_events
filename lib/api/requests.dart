import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usp_events/model/chats.dart';
import 'package:usp_events/model/recipient.dart';
import 'dart:convert';
import 'dart:async';
import 'api.dart';

List<Chats> chats = <Chats>[];
late final Recipient recipient;

Future<List<Chats>> displayEvent() async {
  SharedPreferences localStorage = await SharedPreferences.getInstance();
  var getToken = localStorage.getString('token');
  var token = 'Bearer $getToken';
  //var title = widget.eventsTitle.title;

  var data = {
    'userid_2': recipient.id,
  };

  var response = await CallApi().postEventData(data, 'getMessage', token);

  var notes = <Chats>[];

  if (response.statusCode == 200) {
    var datasJson = json.decode(response.body);
    for (var dataJson in datasJson) {
      notes.add(Chats.fromJson(dataJson));
    }

    return notes;
  } else
    print("http error");
  return [];
}

Stream<List<Chats>> getNumbers(Duration refreshTime) async* {
  while (true) {
    await Future.delayed(refreshTime);
    yield await displayEvent();
  }
}
