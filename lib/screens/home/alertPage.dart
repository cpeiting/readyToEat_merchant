import 'package:flutter/material.dart';

class AlertPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 70),
            child: Text(
              "Start Preparing Order",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 74.0, top: 20),
            child: Container(
              child: Text("Make Sure Order is ready by 11AM",
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          RaisedButton(
            color: Colors.white,
            child: Text(
              "Got It",
            ),
            onPressed: () {
              onPressed:
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
