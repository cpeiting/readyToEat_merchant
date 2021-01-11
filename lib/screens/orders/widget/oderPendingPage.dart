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


  Future<List<QueryDocumentSnapshot>> getOrderItems(String oderId) async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("orders")
        .doc(oderId)
        .collection("items")
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

//  @override
//  Widget build(BuildContext context) {
//    return FutureBuilder<List<QueryDocumentSnapshot>>(
//      future: getOrders(),
//      builder: (_, snapshot) {
//        if (snapshot.connectionState == ConnectionState.waiting) {
//          return Center(
//            child: CircularProgressIndicator(),
//          );
//        } else {
//          return ListView.builder(
//              shrinkWrap: true,
//              itemCount: snapshot.data.length, //number of item
//              itemBuilder: (_, index) {
//                return Card(
//                  child: ListTile(
//                    title: Text(snapshot.data[index]['userID']),
//                    onTap: () async {
//                      String orderDocId = snapshot.data[index].id;
//                      String userPhoneNum = snapshot.data[index]['userPhone'];
//                      await navigateToDetail(orderDocId,userPhoneNum);
//                    },
//                  ),
//                );
//              });
//        }
//      },
//    );
//  }

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
                  child: GestureDetector(
                    onTap: () async {
                      String orderDocId = documentSnapshot.data[index].id;
                      String userPhoneNum = documentSnapshot.data[index]['userPhone'];
                      await navigateToDetail(orderDocId,userPhoneNum);
                    },
                    child: Card(
                      color: Colors.white,
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
                                      color: Colors.black, fontSize: 20),
                                ),
                                Text(documentSnapshot.data[index]['userPhone'],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 13))
                              ],
                            ),
                          ),
                          Divider(),
                          Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'Item(s):',
                              style: TextStyle(color: Colors.blue, fontSize: 18),
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
                                          Icon(Icons.arrow_right,color: Colors.black),
                                          Text(
                                              itemSnapshot.data[index]
                                              ['menuName'],
                                              style: TextStyle(
                                                  color: Colors.black)),
                                          Text(
                                              ' x${itemSnapshot.data[index]['quantity']}',
                                              style: TextStyle(
                                                  color: Colors.black)),
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
                  ),
                );
              });
        }
      },
    );
  }

}
