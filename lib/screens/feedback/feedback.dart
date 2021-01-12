import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_sample/screens/home/home.dart';
import 'package:sandwich_sample/screens/orders/orders.dart';

class Feedbacks extends StatefulWidget {
  @override
  _FeedbacksState createState() => _FeedbacksState();
}

class _FeedbacksState extends State<Feedbacks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          'Feedback',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.bold,

//            fontFamily: 'OpenSans',
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      bottomNavigationBar:BottomAppBar(
//        elevation: 9.0,
//        notchMargin: 6.0,
//        shape: CircularNotchedRectangle(),
//        child: Container(
//          height: 50,
//          width: MediaQuery.of(context).size.width / 2,
//          decoration: BoxDecoration(
//              borderRadius: BorderRadius.only(
//                topLeft: Radius.circular(25.0),
//                topRight: Radius.circular(25.0),
//              )),
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Container(
//                height: 50.0,
//                width: MediaQuery.of(context).size.width / 2,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    GestureDetector(
//                      child: Icon(Icons.home),
//                      onTap: () {
//                          Navigator.pop(context);
////                              MaterialPageRoute(builder: (context) => Home()));
//
//                      },
//                    ),
//                    GestureDetector(
//                      child: Icon(Icons.chat),
//                      onTap: () {
//                        setState(() {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => Feedbacks()));
//                        });
//                      },
//                    ),
//                  ],
//                ),
//              ),
//              Container(
//                height: 50.0,
//                width: MediaQuery.of(context).size.width / 2,
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                  children: <Widget>[
//                    GestureDetector(
//                      child: Icon(Icons.settings),
//                      onTap: () {
//                        setState(() {
//                          Navigator.push(context,
//                              MaterialPageRoute(builder: (context) => Home()));
//                        });
//                      },
//                    ),
//                    GestureDetector(
//                      child: Icon(Icons.person),
//                      onTap: () {
//                        setState(() {
//                          Navigator.push(
//                              context,
//                              MaterialPageRoute(
//                                  builder: (context) => Profile()));
//                        });
//                      },
//                    ),
//                  ],
//                ),
//              )
//            ],
//          ),
//        ),
//      ),
      body: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
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
                      title: Text(snapshot.data[index]['feedback'],style: TextStyle(
                        fontWeight: FontWeight.bold,

                      ),),
                      subtitle: Text(snapshot.data[index]['username']),
                      leading: CircleAvatar(
                        child: Image(
                          image: AssetImage('assets/image/smile.png'),
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