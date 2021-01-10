import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_sample/screens/orders/orderDetails.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Future<List<QueryDocumentSnapshot>> getOrders() async {
    String restaurantId = FirebaseAuth.instance.currentUser.uid;

//    print('res ID$restaurantId');

    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("orders")
        .where('restaurantID', isEqualTo: restaurantId)
        .get();
    return qn.docs;
  }

  navigateToDetail(String orderDocId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetails(
              orderDocId: orderDocId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: FutureBuilder<List<QueryDocumentSnapshot>>(
          future: getOrders(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading'),
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length, //number of item
                  itemBuilder: (_, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data[index]['userID']),
                        onTap: () {
                          String orderDocId = snapshot.data[index].id;
                          navigateToDetail(orderDocId);
                        },
                      ),
                    );
                  });
            }
          },
        ));
  }
}


