import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Future extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new FutureState();
  }
}

class FutureState extends State<Future>{
  final databaseReference = FirebaseDatabase.instance.reference();
  Map<dynamic, dynamic> map;
  bool loading=true;
  DateFormat dateFormat = DateFormat("MMMM d y");
  DateFormat timeFormat=DateFormat("h:mm a");
  @override
  void initState() {
    // TODO: implement initState
    databaseReference.child("shouts/").once().then((DataSnapshot snapshot){
    setState(() {
      map=snapshot.value;
      loading=false;
    });  
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Text('Future Page'),
      showShouts()
    ],);
    
  }

  showShouts(){
    if(loading){
      return Center(child: CircularProgressIndicator());
    }
    else if(map!=null&&map.values!=null){
      databaseReference.child("/shouts/").once().then((DataSnapshot snapshot) {
      map = snapshot.value;
      });    
     return Column(children: map.values.toList().where((e)=>{DateTime.parse(e['date']).isAfter(DateTime.now())}.first).map((item)=>
     Card(child: Column(children: <Widget>[
       Text("Date: "+dateFormat.format(DateTime.parse(item['date']))),
       Text("Time: "+timeFormat.format(DateTime.parse(item['date']))),
       Text("Venue: "+item['venue'].toString())
     ],),)
     
     ).toList());
    }
    
  }

}

//.where((e)=>{DateTime.parse(e['date'])>DateTime.now()}).
