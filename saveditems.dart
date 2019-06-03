import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class SavedItems extends StatefulWidget {
  final String result;
  SavedItems(this.result);
  @override
  SavedItemsState createState() => SavedItemsState();
}

class SavedItemsState extends State<SavedItems> {
  String name = '';
  String notes = '';
  final _formkey=GlobalKey<FormState>();
  
  
  bool change = false;
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFB4C56C).withOpacity(0.5),
        title: Row(
          children: <Widget>[
            new Image.asset("asset\images\homeicon.png"),
            new Text("Todo")
          ],
        ),
      ),
      body: textAdd(),
      backgroundColor: Color.fromRGBO(96, 96, 96, 5.0),
    );
  }

  Widget textAdd() {

    saveAndPass(){
      if(_formkey.currentState.validate()){
        _formkey.currentState.save();
        Navigator.pop(context,name);
      }
      else{
        Navigator.pop(context ,name);
      }
    }
    
    return Form(
      key: _formkey,
      child: new Column(
      // mainAxisAlignment:MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: new TextFormField(
            cursorColor: Colors.white70,
            style: TextStyle(color: Colors.white70),
            validator: (value){
                  if(value.isEmpty)
                   return "enter task name";
                   else return null;
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
                labelText:'task name',
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
              onPressed: () =>saveAndPass(),
               
            ),
            new RaisedButton(
              child: new Text("Delete", style: TextStyle(color: Colors.white)),
              onPressed: null,
            ),
            new RaisedButton(
              child: new Text("Cancel", style: TextStyle(color: Colors.white)),
              onPressed: null,
            ),
            new RaisedButton(
              child: new Text("Speak", style: TextStyle(color: Colors.white)),
              onPressed: null,
            )
          ],
        )
      ],
    ));
  }
}
