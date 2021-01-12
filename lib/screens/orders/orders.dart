import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_sample/screens/orders/orderDetails.dart';
import 'package:sandwich_sample/screens/orders/widget/oderPendingPage.dart';
import 'package:sandwich_sample/screens/orders/widget/orderAcceptedPage.dart';
import 'package:sandwich_sample/screens/orders/widget/orderCompletedPage.dart';
import 'package:sandwich_sample/screens/orders/widget/orderRejectedPage.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change
              // your color here
            ),
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Accepted'),
                Tab(text: 'Completed'),
                Tab(text: 'Rejected'),
              ],
              labelColor: Colors.blueGrey,
            ),
            title: Text(
              'My Orders',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
//            fontFamily: 'OpenSans',
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
          ),
          body: TabBarView(
            children: [
              OrderPendingPage(),
              OrderAcceptedPage(),
              OrderCompletedPage(),
              OrderRejectedPage(),
            ],
          ),
        ),
      ),
    );
  }

//  Future<List<QueryDocumentSnapshot>> getOrders() async {
//    String restaurantId = FirebaseAuth.instance.currentUser.uid;
//
//    QuerySnapshot qn = await FirebaseFirestore.instance
//        .collection("orders")
//        .where('restaurantID', isEqualTo: restaurantId)
//        .get();
//    return qn.docs;
//  }
//
//  navigateToDetail(String orderDocId) {
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) => OrderDetails(
//              orderDocId: orderDocId,
//                )));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//        appBar: AppBar(
//          title: Text('Orders'),
//        ),
//        body: FutureBuilder<List<QueryDocumentSnapshot>>(
//          future: getOrders(),
//          builder: (_, snapshot) {
//            if (snapshot.connectionState == ConnectionState.waiting) {
//              return Center(
//                child: Text('Loading'),
//              );
//            } else {
//              return ListView.builder(
//                  shrinkWrap: true,
//                  itemCount: snapshot.data.length, //number of item
//                  itemBuilder: (_, index) {
//                    return Card(
//                      child: ListTile(
//                        title: Text(snapshot.data[index]['userID']),
//                        onTap: () {
//                          String orderDocId = snapshot.data[index].id;
//                          navigateToDetail(orderDocId);
//                        },
//                      ),
//                    );
//                  });
//            }
//          },
//        ));
//  }
}
