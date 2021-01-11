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


  Future<List<QueryDocumentSnapshot>> getOrderItems(String oderId) async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("orders")
        .doc(oderId)
        .collection("items")
        .get();
    return qn.docs;
  }


  Widget build(BuildContext context) {
    return FutureBuilder<List<QueryDocumentSnapshot>>(
      future: getOrders(),
      builder: (_, documentSnapshot) {
        if (documentSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text('Loading'),
          );
        } else {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: documentSnapshot.data.length, //number of item
              itemBuilder: (_, index) {
                String orderDocId = documentSnapshot.data[index].id;

                return Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                  child: Card(
                    color: Colors.white70,
                    child: ListView(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      shrinkWrap: true,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                documentSnapshot.data[index]['username'],
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 20),
                              ),
                              Text(documentSnapshot.data[index]['userPhone'],
                                  style: TextStyle(
                                      color: Colors.black45, fontSize: 13))
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 6),
                          child: Text(
                            'Item(s):',
                            style: TextStyle(color: Colors.blue.withOpacity(0.5), fontSize: 18),
                          ),
                        ),
                        FutureBuilder<List<QueryDocumentSnapshot>>(
                          future: getOrderItems(orderDocId),
                          builder: (_, itemSnapshot) {
                            if (itemSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Text('Loading'),
                              );
                            } else {
                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: itemSnapshot.data.length,
                                  //number of item
                                  itemBuilder: (_, index) {
                                    return Row(
                                      children: [
                                        Icon(Icons.arrow_right,color: Colors.black45),
                                        Text(
                                            itemSnapshot.data[index]
                                            ['menuName'],
                                            style: TextStyle(
                                                color: Colors.black45)),
                                        Text(
                                            ' x${itemSnapshot.data[index]['quantity']}',
                                            style: TextStyle(
                                                color: Colors.black45)),
                                      ],
                                    );
                                  });
                            }
                          },
                        ),
                        Container(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}

