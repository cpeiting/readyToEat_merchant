import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_sample/screens/orders/orderDetails.dart';

class OrderPendingPage extends StatefulWidget {
  @override
  _OrderPendingPageState createState() => _OrderPendingPageState();
}

class _OrderPendingPageState extends State<OrderPendingPage> {
  Future<List<QueryDocumentSnapshot>> getOrders() async {
    String restaurantId = FirebaseAuth.instance.currentUser.uid;

    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("orders")
        .where('restaurantID', isEqualTo: restaurantId)
        .where('status', isEqualTo: 'orderPlaced')
        .get();
    return qn.docs;
  }

  navigateToDetail(String orderDocId, String userContactNumber) async {
     bool result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetails(
                  orderDocId: orderDocId,
                  userContactNumber: userContactNumber,
                )));
    if(result){
      // refresh the page after user closed detail page
      setState(() {

      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getOrders(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length, //number of item
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    title: Text(snapshot.data[index]['userID']),
                    onTap: () async {
                      String orderDocId = snapshot.data[index].id;
                      String userPhoneNum = snapshot.data[index]['userPhone'];
                      await navigateToDetail(orderDocId,userPhoneNum);
                    },
                  ),
                );
              });
        }
      },
    );
  }
}
