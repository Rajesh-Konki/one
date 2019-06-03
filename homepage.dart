import 'package:flutter/material.dart';
import 'todo.dart';
//import 'saveditems.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

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

Future<PostList> fetch() async {
  final response = await http.get(
    "http://192.168.42.253:5000/api/todo",
  );
  if (response.statusCode == 200) {
    return PostList.fromjson(json.decode(response.body));
  } else {
    throw Exception("There is no data");
  }
}

Future<Post> createPost(String url, {Map body}) async {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  return http
      .post(url, body: json.encode(body), headers: requestHeaders)
      .then((http.Response response) {
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null)
      throw new Exception("there is no data....!");
    return Post.fromjson(json.decode(response.body));
  });
}

class HomePage extends StatefulWidget {
  final Future<PostList> post;
  HomePage({Key key, this.post}) : super(key: key);

  @override
  HomepageState createState() => HomepageState(post);
}

class HomepageState extends State<HomePage> {
  final Future<PostList> post;
  List<String> x = [""];
  HomepageState(this.post);
  String result;
  int len = 0;
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        bottomOpacity: 100,
        title: Row(
          children: <Widget>[
            //new Image.asset("asset\images\homeicon.png"),
            new Text("Todo"),
            new IconButton(
                //alignment: Alignment(250,0),
                icon: new Icon(
                  Icons.add,
                  size: 30,
                ),
                color: Colors.white,
                onPressed: () => waitForResult())
          ],
        ),
        // backgroundColor: Colors.blueAccent,
      ),
      body: makeListView(),
    );
  }

  Future<void> waitForResult() async {
    result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Todo()));
    print(result);
    items.add(result);
  }

  Widget makeListView() {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Text(items[index]);
        });
  }
  // String getName(){
  //   new FutureBuilder<PostList>(
  //      future: post,
  //      builder:(context,snap){
  //        if(snap.hasData){
  //          return snap.data.posts.;
  //        }
  //      } ,
  //   );
  // }
  //  return FutureBuilder<PostList>(
  //       future: post,
  //       builder: (context, snap) {
  //         if (snap.hasData) {
  //           for (int i = 0; i < snap.data.posts.length; i++)
  //             x.add(snap.data.posts[i].name);
  //           return Text(x.toString());
  //         } else {
  //           return Text("${snap.error}");
  //         }
  //       },
  //     );

  // bool change=false;

}
