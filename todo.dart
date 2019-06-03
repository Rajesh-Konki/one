import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
// Data(this.name,this.notes,this.done);

class Post {
  String id;
  String name;
  String notes;
  bool done;
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
    map['done'] = done;
    return map;
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

class Todo extends StatefulWidget {
  @override
  TodoState createState() => TodoState();
}

class TodoState extends State<Todo> {
  final _formkey = GlobalKey<FormState>();
  String name="", id, notes;
  bool done;

  bool change = false;
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFB4C56C).withOpacity(0.5),
        title: Row(
          children: <Widget>[
            //new Image.asset("asset\images\homeicon.png"),
            new Text("Todo")
          ],
        ),
      ),
      body: textAdd(),
      backgroundColor: Color.fromRGBO(96, 96, 96, 5.0),
    );
  }

  Widget textAdd() {
    Post post;

    return Form(
        key: _formkey,
        child: new Column(
          // mainAxisAlignment:MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: new TextFormField(
                  onSaved: (String val) {
                    id = val;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                      hintText: '',
                      labelText: 'id',
                      prefixIcon: Icon(
                        Icons.note,
                        color: Colors.white10,
                      ))),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: new TextFormField(
                cursorColor: Colors.white70,
                style: TextStyle(color: Colors.white70),
                validator: (value) {
                  if (value.isEmpty)
                    return "enter task name";
                  else
                    return null;
                },
                onSaved: (val) {
                  name = val;
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.all(Radius.circular(5.5)),
                    ),
                    //hintText: 'task Name',
                    labelText: 'Task Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white10,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: new TextFormField(
                  onSaved: (String val) {
                    notes = val;
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(2.5)),
                      ),
                      hintText: '',
                      labelText: 'Notes',
                      prefixIcon: Icon(
                        Icons.note,
                        color: Colors.white10,
                      ))),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Text("Done", style: TextStyle(color: Colors.white70)),
                  new Switch(
                      value: change,
                      onChanged: (bool value) {
                        setState(() {
                          change = value;
                          done = change;
                        });
                      })
                ],
              ),
            ),
            new Column(
              children: <Widget>[
                new RaisedButton(
                  child: new Text("Save",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.start),
                  onPressed: () => (context) {
                        post.id = id;
                        post.name = name;
                        post.notes = notes;
                        post.done = done;
                        Navigator.pop(context, post.name);
                        // if (_formkey.currentState.validate()) {
                        //   _formkey.currentState.save();

                        //   //  await createPost("http://192.168.42.253:5000/api/todo",
                        //   //       body: post.toMap());
                          
                        // } else {
                        //   throw Exception("............................................");
                        // }
                      },
                ),
                new RaisedButton(
                  child:
                      new Text("Delete", style: TextStyle(color: Colors.white)),
                  onPressed: null,
                ),
                new RaisedButton(
                  child:
                      new Text("Cancel", style: TextStyle(color: Colors.white)),
                  onPressed: null,
                ),
                new RaisedButton(
                  child:
                      new Text("Speak", style: TextStyle(color: Colors.white)),
                  onPressed: null,
                )
              ],
            )
          ],
        ));
  }
}
