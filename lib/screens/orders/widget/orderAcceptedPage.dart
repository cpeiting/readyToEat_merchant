import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';


class OrderAcceptedPage extends StatefulWidget {
  @override
  _OrderAcceptedPageState createState() => _OrderAcceptedPageState();
}

class _OrderAcceptedPageState extends State<OrderAcceptedPage> {
  Future<List<QueryDocumentSnapshot>> getOrders() async {
    String restaurantId = FirebaseAuth.instance.currentUser.uid;

    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("orders")
        .where('restaurantID', isEqualTo: restaurantId)
        .where('status', isEqualTo: 'accepted')
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

  FToast fToast;

  Widget completedToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.greenAccent,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Order accepted successfully!"),
      ],
    ),
  );


  Widget rejectedToast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.red,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check),
        SizedBox(
          width: 12.0,
        ),
        Text("Order rejected successfully!"),
      ],
    ),
  );



  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
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

                int deliveryInMinute =
                    documentSnapshot.data[index]['deliveryInMinutes'];
                String acceptedTime =
                    documentSnapshot.data[index]['acceptedTime'];
                DateTime acceptedDateTime = DateTime.parse(acceptedTime);
                acceptedDateTime.add(Duration(minutes: deliveryInMinute));

                return Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                  child: Card(
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
                                    color: Colors.black87, fontSize: 20),
                              ),
                              Text(documentSnapshot.data[index]['userPhone'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Deliver before ${DateFormat('hh:mm a').format(acceptedDateTime)} ',
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 14),
                            ),
                            Text('($deliveryInMinute mins)',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14))
                          ],
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
                                        Icon(Icons.arrow_right),
                                        Text(itemSnapshot.data[index]
                                            ['menuName']),
                                        Text(
                                            ' x${itemSnapshot.data[index]['quantity']}'),
                                      ],
                                    );
                                  });
                            }
                          },
                        ),
                        Container(
                          height: 25,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 6),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: RaisedButton(
                                  color: Colors.red,
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(orderDocId)
                                        .update({
                                      'status': 'rejected',
                                    }).then((value) {


                                      fToast.showToast(
                                        child: rejectedToast,
                                        gravity: ToastGravity.BOTTOM,
                                        toastDuration: Duration(milliseconds: 1500),
                                      );

                                      setState(() {});
                                    });
                                  },
                                  child: Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: RaisedButton(
                                  color: Colors.blue,
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('orders')
                                        .doc(orderDocId)
                                        .update({
                                      'status': 'completed',
                                    }).then((value) {


                                      fToast.showToast(
                                        child: completedToast,
                                        gravity: ToastGravity.BOTTOM,
                                        toastDuration: Duration(milliseconds: 1500),
                                      );

                                      setState(() {});

                                    });

                                  },
                                  child: Text('Done',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              )
                            ],
                          ),
                        )
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
