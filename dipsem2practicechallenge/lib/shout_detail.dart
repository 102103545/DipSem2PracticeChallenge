import 'package:flutter/material.dart';

class ShoutDetail extends StatefulWidget{
  ShoutDetail(this.id);
  String id;
  @override
  State<StatefulWidget> createState() {
    return new ShoutDetailState(id);
  }
}

class ShoutDetailState extends State<ShoutDetail>{
  ShoutDetailState(this.id);
  String id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shout Detail"),),
      body: Column(
        children: <Widget>[
          Text("Shout Detail PAge Coming Soon"),
          Text(id)
        ],
      ),
    );
  }
}