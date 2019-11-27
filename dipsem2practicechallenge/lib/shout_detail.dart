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
  Map<dynamic, dynamic> membersMap;
  bool loading=true;
  bool formloading=true;
  DateFormat dateFormat = DateFormat("MMMM d y");
  DateFormat timeFormat=DateFormat("h:mm a");
  String shoutDate="unset shoutDate";
  String shoutVenue="unset shoutVenue";
  String shoutID="unset shoutID";
  String shoutMember="N/A";
  String shoutCost="N/A";
  TextEditingController shoutCostController=TextEditingController();
  final formKey=GlobalKey<FormState>();
  List<DropdownMenuItem> memberslist;
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
    databaseReference.child('users').once().then((DataSnapshot snapshot){
      membersMap=snapshot.value;
      memberslist=membersMap.values.toList().map((item)=>DropdownMenuItem(child:Text(item['name']))).toList();
      setState(() {
        formloading=false;
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
  if(formloading)
  {return CircularProgressIndicator();}
  else{
  return Form(key:formKey,
  child: Column(children: <Widget>[
    TextFormField(
      //autovalidate: true,
      //initialValue: shoutCost,
      //onTap: (){print("tapped");},
      decoration: InputDecoration(labelText: 'Cost',icon: Icon(Icons.attach_money),hintText: shoutCost),
      keyboardType: TextInputType.phone,
      validator: (value){
        if(value.isEmpty)
        {return "please Enter a Cost";}
        if(int.tryParse(value)==null)
        {return "please enter a numeric cost";}
        setState(() {
          shoutCost=value;
        });
      },
    ),
    DropdownFormField<String>(
      validator:(value){
        if(value==null)
        {
          return "Please Select Member";
        }
      },
      onSaved:(value){
        setState(() {
          shoutMember=value;
        });
      },
      decoration:InputDecoration(
        icon: Icon(Icons.verified_user),
        labelText: 'Member',  
      ),
      initialValue: null,
      items:memberslist
    ),
    RaisedButton(
      child: Text("Submit"),
      onPressed: (){formKey.currentState.validate();},
    )
  ],),);}
}

}


class DropdownFormField<T> extends FormField<T> {
  DropdownFormField({
    Key key,
    InputDecoration decoration,
    T initialValue,
    List<DropdownMenuItem<T>> items,
    bool autovalidate = false,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          autovalidate: autovalidate,
          initialValue: items.contains(initialValue) ? initialValue : null,
          builder: (FormFieldState<T> field) {
            final InputDecoration effectiveDecoration = (decoration ?? const InputDecoration())
                .applyDefaults(Theme.of(field.context).inputDecorationTheme);

            return InputDecorator(
              decoration:
                  effectiveDecoration.copyWith(errorText: field.hasError ? field.errorText : null),
              isEmpty: field.value == '' || field.value == null,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<T>(
                  value: field.value,
                  isDense: true,
                  onChanged: field.didChange,
                  items: items.toList(),
                ),
              ),
            );
          },
        );
}