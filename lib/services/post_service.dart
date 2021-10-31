import 'dart:convert';

import 'package:http/http.dart' as http;

class PostService {
  String baseUrl = "http://jsonplaceholder.typicode.com/posts";

  // returns a list of all posts as per my API
  // may use this in a futurebuilder
  Future<List> getPosts() async {
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        // return a decoded body
        //print(response.body);
        return jsonDecode(response.body);
      } else {
        // server error
        return Future.error("Server Error !");
      }
    } catch (socketException) {
      // fetching error
      // may be timeout, no internet or dns not resolved
      return Future.error("Error Fetching Data !");
    }
  }

  Future<String> createPost(Map<String, dynamic> data) async {
    try {
      var response =
          await http.post(Uri.parse(baseUrl), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json',
      });
      if (response.statusCode == 201) {
        // return a decoded body
        print(response.body);
        return "success";
      } else {
        // server error
        print(response.body);
        return "err";
      }
    } catch (socketException) {
      // fetching error
      // may be timeout, no internet or dns not resolved
      return "err";
    }
  }
}
