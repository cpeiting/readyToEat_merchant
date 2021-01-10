import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_sample/screens/orders/orderDetails.dart';



class OrderRejectedPage extends StatefulWidget {
  @override
  _OrderRejectedPageState createState() => _OrderRejectedPageState();
}

class _OrderRejectedPageState extends State<OrderRejectedPage> {


  Future<List<QueryDocumentSnapshot>> getOrders() async {
    String restaurantId = FirebaseAuth.instance.currentUser.uid;

    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("orders")
        .where('restaurantID', isEqualTo: restaurantId)
        .where('status', isEqualTo: 'rejected')
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
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
                  ),
                );
              });
        }
      },
    );
  }
}

