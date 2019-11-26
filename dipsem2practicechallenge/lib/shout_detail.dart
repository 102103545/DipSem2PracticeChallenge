import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

final databaseReference = FirebaseDatabase.instance.reference();
  Map<dynamic, dynamic> map;
  bool loading=true;
  DateFormat dateFormat = DateFormat("MMMM d y");
  DateFormat timeFormat=DateFormat("h:mm a");
  String shoutDate="unset shoutDate";
  String shoutVenue="unset shoutVenue";
  String shoutID="unset shoutID";
  String shoutMember="N/A";
  String shoutCost="N/A";
  TextEditingController shoutCostController=TextEditingController();
  final formKey=GlobalKey<FormState>();
  @override
  void initState() {
    databaseReference.child("shouts/"+id).once().then((DataSnapshot snapshot){
    setState(() {
      map=snapshot.value;
      shoutDate=map['date'];
      shoutVenue=map['venue'];
      shoutID=map['id'];
      if(map['cost']!=null)
      {shoutCost=map['cost'];}
      if(map['member']!=null)
      {shoutMember=map['member'];}
      loading=false;
    });  
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Shout Detail"),),
      body: Column(children:<Widget>[
        showShoutDetail(),
        showShoutForm()
        ]
    ));
  }

showShoutDetail(){
  if(loading){
    return Center(child:CircularProgressIndicator());
  }
  else{
  return Center(child:Column(
        children: <Widget>[
          Text("Date:",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
          Text(dateFormat.format(DateTime.parse(shoutDate))),
          Text("Time:",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
          Text(timeFormat.format(DateTime.parse(shoutDate))),
          Text("Venue:",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),),
          Text(shoutVenue)
        ],
      ));
  }
}

showShoutForm(){
  return Form(key:formKey,
  child: Column(children: <Widget>[
    TextFormField(
      //initialValue: shoutCost,
      //onTap: (){print("tapped");},
      decoration: InputDecoration(labelText: 'Cost',icon: Icon(Icons.attach_money),hintText: shoutCost),
      keyboardType: TextInputType.phone,
      validator: (value){
        if(value.isEmpty)
        {return "please Enter a Cost";}
        if(int.tryParse(value)==null)
        {return "please enter a numeric cost";}
      },
    ),
    RaisedButton(
      child: Text("Submit"),
      onPressed: (){formKey.currentState.validate();},
    )
  ],),);
}

}