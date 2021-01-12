import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandwich_sample/screens/common/ready_confirmation_dialog.dart';
import 'package:sandwich_sample/screens/home/alertPage.dart';
import 'package:sandwich_sample/screens/menu/menuList.dart';
import 'package:sandwich_sample/screens/updateMenu/updateMenu.dart';
import 'package:sandwich_sample/services/auth.dart';
import 'package:sandwich_sample/screens/orders/orders.dart';
import 'package:sandwich_sample/screens/feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService _auth = AuthService();

  int currentTab = 0;
  final tabs = [
    Home(),
    MenuList(),
    Feedback(),
    Orders(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text(
          'Reservation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
//            fontFamily: 'OpenSans',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('Logout')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => updateMenu()));
          });
        },
        backgroundColor: Color(0xFFF17532),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 9.0,
        notchMargin: 6.0,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.book),
                    GestureDetector(
                      child: Icon(Icons.chat),
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Feedbacks()));
                        });
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 50.0,
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(Icons.fastfood),
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuList()));
                        });
                      },
                    ),
                    GestureDetector(
                      child: Icon(Icons.assignment),
                      onTap: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Orders()));
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: ListPage(),
    );
  }
}

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  Future _data;

  Future getFeedback() async {
    QuerySnapshot qn =
        await FirebaseFirestore.instance.collection("feedback").get();
//    print("pt"+qn.docs.toString());
    return qn.docs;
  }

//  @override
//  void initState() {
//    super.initState();
//
//    _data = getFeedback();
//  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getFeedback(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Loading'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length, //number of item
                itemBuilder: (_, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data[index]['username']),
                      subtitle: Text(snapshot.data[index]['feedback']),
                      leading: CircleAvatar(
                        child: Image(
                          image: AssetImage('assets/image/feedback.jpg'),
                        ),
                      ),
//                title: Text('sdfnadjv'),
//                      onTap: () => ,
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  Future getBookings() async {
    String restaurantId = FirebaseAuth.instance.currentUser.uid;
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("bookings")
        .where('restaurantId', isEqualTo: 'kadTQ2c7fuaVfhSYL6B8oNPtGmz1')
        .get();
    return qn.docs;
  }
  int pax = 0;

  navigateToDetail(cId, DocumentSnapshot post, bookingDateTime, valueGuest) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  cId: cId,
                  customers: post,
                  bookingDateTime: bookingDateTime,
                  valueGuest: valueGuest,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getBookings(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Text('Loading'),
            );
          } else {
            return ListView.builder(
                itemCount: snapshot.data.length, //number of item
                itemBuilder: (_, index) {
                  String cid = snapshot.data[index].id;
//                  var bookingDate = dateFormat
//                      .format(snapshot.data[index]['selectedDate'].toDate());

                  var bookingDate = DateFormat('dd  MMM  yyyy')
                      .format(snapshot.data[index]['selectedDate'].toDate());

                  var bookingTime = DateFormat('hh:mm:a')
                      .format(snapshot.data[index]['selectedDate'].toDate());

                  String valueGuest = snapshot.data[index]['valueGuests'];
                  String user = snapshot.data[index]['name'];
                  String status = snapshot.data[index]['status'];

                   pax =
                      int.parse(valueGuest.replaceAll(RegExp('[^0-9]'), ''));

                  return GestureDetector(
                    onTap: () {
                        navigateToDetail(cid, snapshot.data[index],
                            bookingDate, valueGuest);
                      },
                    child: Stack(children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: 25, right: 25, top: 5, bottom: 5),
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 45,
                              left: 10,
                              child: Card(
                                elevation: 1,
                                color: Color(0xFFF17532),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: Container( width: 300, height: 300),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 16),
                                child: Text(
                                  user,
                                  style: TextStyle(color: Colors.black87),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                  bookingDate,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: 'OpenSans'),
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, left: 10),
                                child: Container(
                                  padding: EdgeInsets.only(top: 5, right: 50,left: 5,bottom: 5),
                                  color: Colors.green,
                                  child: Text(
                                    status,
                                    style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      color: Colors.white,),
                                  ),
                                )
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: EdgeInsets.only( top: 10,right: 10),
                                child: Text(
                                  bookingTime,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15,
                                    fontFamily: 'OpenSans',
                                  ),
                                ),
                              ),
                            ),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: 16, bottom: 10, left: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: seatWidget(),
                                  ),
                                ))
                          ],
                        ),
                      )
                    ]),
                  );

//                  return Card(
//                    child: ListTile(
//                      title: Text(snapshot.data[index]['name']),
//                      subtitle: Text(
//                          dateFormat.format(
//                              snapshot.data[index]['selectedDate'].toDate()),
//                          style: TextStyle(color: Colors.green)),
//                      trailing: Text(
//                        snapshot.data[index]['valueGuests'],
//                        style: TextStyle(color: Colors.red),
//                      ),
//                      onTap: () {
//                        navigateToDetail(cid, snapshot.data[index],
//                            bookingDate, valueGuest);
//                      },
//                    ),
//                  );
                });
          }
        },
      ),
    );
  }

  List<Widget> seatWidget() {

    List<Widget> places = [];
    for(int i = 0 ; i < pax ; i++){
      places.add( Icon(
        Icons.event_seat,
        color: Colors.white,
      ));
    }
    return places;

  }
}

class DetailPage extends StatefulWidget {
  final String cId;
  final DocumentSnapshot customers;
  final String bookingDateTime;
  final String valueGuest;

  DetailPage({this.customers, this.bookingDateTime, this.valueGuest, this.cId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _counter = 15;
  Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        if (_counter > 15) {
          _counter--;
        } else {
          _timer.cancel();
        }
      });
    });
  }

  Future<void> whenAccept(String status) async {
    var cID = widget.cId;

    return await FirebaseFirestore.instance
        .collection('bookings')
        .doc(cID)
        .update({
      'status': status,
    });
  }

  Future<void> whenReject(String status) async {
    var cID = widget.cId;

    return await FirebaseFirestore.instance
        .collection('bookings')
        .doc(cID)
        .update({
      'status': status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          )),
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              RaisedButton(
                  color: Colors.green,
                  child: Container(
                      width: 250,
                      height: 45,
                      child: Center(
                          child: Text("Accept",
                              style: TextStyle(
                                color: Colors.white,
                              )))),
                  onPressed: () {
                    String status = "accept";
                    whenAccept(status);
                  }),
              SizedBox(height: 10),
              RaisedButton(
                  color: Colors.red,
                  child: Container(
                      width: 250,
                      height: 40,
                      child: Center(
                          child: Text("Reject",
                              style: TextStyle(
                                color: Colors.white,
                              )))),
                  onPressed: () {
                    String status = "reject";
                    whenReject(status);
                  }),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Having issues with this order?",
                  style: TextStyle(
                    color: Colors.black45,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
              Text(
                "0167755053",
                style: TextStyle(
                    fontFamily: 'OpenSans',
                    color: Colors.brown,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),

        title: SizedBox(
          width: 220,
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  "Pickup #" + widget.customers["name"],
                  style: TextStyle(
                    color: Colors.brown,
                    fontSize: 16,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Waiting for confirmation",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontFamily: 'OpenSans',
                  ),
                ),
              ),
            ],
          ),
        ),

//        title: Text(widget.post["name"]),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 40, 20, 0),
              child: Container(
                height: 45,
                padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                color: Colors.brown[400],
                child: Center(
                  child: Text(
                    'Pending',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
//           Text(widget.customers["placed"]),,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.customers["name"],
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Placed: ${widget.bookingDateTime}",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "No of Pax: ${widget.valueGuest}",
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(height: 50),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//void createAlertDialog(BuildContext context) {
//  showModalBottomSheet(context: context, builder: (BuildContext bc))
//}
