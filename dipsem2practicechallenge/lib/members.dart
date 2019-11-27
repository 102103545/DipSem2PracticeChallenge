import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Members extends StatefulWidget{
  Members(this.email);
  String email;

  @override
  State<StatefulWidget> createState() {
    return new MembersState(email);
  }
}

class MembersState extends State<Members>{
  MembersState(this.email);
  String email;

  bool loading=true;
  final databaseReference = FirebaseDatabase.instance.reference();
  Map<dynamic, dynamic> membersMap;
  Map<dynamic, dynamic> shoutsMap;
  Map<dynamic, dynamic> user;
  List<Card> memberslist;
  @override
  void initState() {   
       databaseReference.child("users").once().then((DataSnapshot snapshot){
         Map<dynamic,dynamic> userMap=snapshot.value;
         for(int i=0;i<userMap.length;i++){
           if(userMap.values.toList()[i]['email']==email){
             setState(() {
          user=userMap.values.toList()[i];
         });
           }
         }        
       });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    getMemberTotal(String email,DataSnapshot shouts){
      double total=0;
      shoutsMap=shouts.value;
      for(int i=0;i<shoutsMap.values.toList().length;i++)
        {
          if(shoutsMap.values.toList()[i]['member']==email)
          {
            total+=double.parse(shoutsMap.values.toList()[i]['cost']);
          }
        }
        return Text("Total Spent: \$"+total.toStringAsFixed(2));

    }
    showmembers(){
      databaseReference.child('/shouts/').once().then((DataSnapshot shoutsSnapshot){
        databaseReference.child('/users/').once().then((DataSnapshot snapshot){
      membersMap=snapshot.value;
      memberslist=membersMap.values.toList().where((e)=>{e['approved']=='approved'}.first).map((item)=>Card(child:Row(children:<Widget>[Text(item['name']),Image.network(item['imageurl']),Column(children: <Widget>[Text(item['email']),getMemberTotal(item['email'],shoutsSnapshot)],),]),)).toList();
      setState(() {
        loading=false;
      });
    });
      });
          
    if(loading){
      return CircularProgressIndicator();
    }
    else if(user==null)
    {
      return Text("usernull");
    }
    else if(user['approved']!='approved')
    {
      return Text("Please Wait to be approved by an admin");
    }
    else{
         return Column(children: memberslist,); 
    }
    }
    

    return Column(children: <Widget>[
      Text("Approved Members"),
      showmembers()
    ],);
  }
}