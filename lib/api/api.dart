import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'http://10.0.2.2:8000/api/';

  postData(data, apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  getData(token, apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.get(fullUrl, headers: authSetHeaders(token));
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  logoutPostData(token, apiUrl) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.post(fullUrl, headers: authSetHeaders(token));
  }

  postEventData(data, apiUrl, token) async {
    var fullUrl = Uri.parse(_url + apiUrl);
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: authSetHeaders(token));
  }

  //  postQuizData(data, apiUrl, token) async {
  //   var fullUrl = Uri.parse(_url + apiUrl);
  //   return await http.post(fullUrl,
  //       body: jsonEncode(data), headers: authSetHeaders(token));
  // }

  authSetHeaders(token) => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}
