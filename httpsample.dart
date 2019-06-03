//import 'dart:async' as prefix0;
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PostList {
  final List<Post> posts;
  PostList({this.posts});
  factory PostList.fromjson(List<dynamic> parsedJson) {
    List<Post> posts = new List<Post>();
    posts = parsedJson.map((i) => Post.fromjson(i)).toList();
    return PostList(posts: posts);
  }
}

class Post {
  final String id;
  final String name;
  final String notes;
  final bool done;
  Post({this.id, this.name, this.notes, this.done});
  factory Post.fromjson(Map<String, dynamic> json) {
    return Post(
        done: json['done'],
        id: json['id'].toString(),
        name: json['name'].toString(),
        notes: json['notes'].toString());
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['notes'] = notes;
    map['id'] = id;
    map['done'] = done.toString();
    return map;
  }
}

Future<Post> createPost(String url, {Map body}) async {
  Map<String, String> requestHeaders = {
       'Content-type': 'application/json',
       'Accept': 'application/json',
     };

  return http.post(url, body: json.encode(body),headers: requestHeaders).then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null)
      throw new Exception("there is no data....!");
    return Post.fromjson(json.decode(response.body));
  });
}

Future<PostList> fetch() async {
  final response = await http.get("http://192.168.42.253:5000/api/todo",
      headers: {HttpHeaders.authorizationHeader: "Basic .....!not"});
  if (response.statusCode == 200) {
    return PostList.fromjson(json.decode(response.body));
  } else {
    throw Exception("There is no data");
  }
}

class HTTPReq extends StatelessWidget {
  final Future<PostList> post;
  HTTPReq({Key key, this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HTTPChange(post: post),
    );
  }
}

class HTTPChange extends StatefulWidget {
  final Future<PostList> post;
  HTTPChange({Key key, this.post}) : super(key: key);
  @override
  HTTTPChangeState createState() => HTTTPChangeState(post);
}

class HTTTPChangeState extends State<HTTPChange> {
  final Future<PostList> post;
   List<String> x=[""];
  HTTTPChangeState(this.post);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        new Container(
            child: FutureBuilder<PostList>(
          future: post,
          builder: (context, snap) {
            if (snap.hasData) {
              for(int i=0;i<snap.data.posts.length;i++)
                    x.add(snap.data.posts[i].name);
                    return Text(x.toString());
            } else {
              return Text("${snap.error}");
            }
          },
        )),
        new RaisedButton(
          child: Text("enter"),
          onPressed: () async {
            Post newPost =
                new Post(id: 'onid', name: "Ram", notes: "hgfg", done: true);
                //var one=json.encode(newPost);
            Post p = await createPost("http://192.168.42.253:5000/api/todo",
                body: newPost.toMap());
                print(p);
               // fetch();
          },
          
        )
      ],
    ));
  }
}
