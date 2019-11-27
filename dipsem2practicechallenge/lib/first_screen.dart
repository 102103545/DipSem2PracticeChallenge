

import 'package:dipsem2practicechallenge/new_shout.dart';
import 'package:dipsem2practicechallenge/sign_in.dart';
import 'package:flutter/material.dart';


import 'login_page.dart';
import 'past.dart';
import 'future.dart';

class FirstScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState(){
    return _FirstScreenState();
  }
}


class _FirstScreenState extends State<FirstScreen> {
  int _currentIndex = 0;
  DateTime shoutDate;
  
  // List<Widget> _children=[
  //   Past(email),
  //   Future(email)
  // ];

  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView( child:
      Column(
        children:[
        Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue[100], Colors.blue[400]],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  imageUrl,
                ),
                radius: 60,
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 10),
              Text(
                'NAME',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                name,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'EMAIL',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
              Text(
                email,
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () {
                  signOutGoogle();
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {return LoginPage();}), ModalRoute.withName('/'));
                },
                color: Colors.deepPurple,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
              SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
      [Past(email),Future(email)][_currentIndex]
      
      ])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.plus_one),
          tooltip: "Translate legislation",
          onPressed: () async {
            var result=await Navigator.push(context,MaterialPageRoute<void>(builder: (context) => NewShout()),);    
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_back),
                  title: Text('Past')
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.arrow_forward),
                  title: Text('Future')
                  )
              ],),
    );
  }




    void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}