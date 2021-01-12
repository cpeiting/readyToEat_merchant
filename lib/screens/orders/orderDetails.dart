import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_sample/screens/orders/widget/estimatedTimeDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  final orderDocId;
  final String userContactNumber;

  const OrderDetails({Key key, this.orderDocId, this.userContactNumber})
      : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  FToast fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Future<void> updateOrderStatus(int minutes) async {
    var orderDocId = widget.orderDocId;

    return await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderDocId)
        .update({
      'deliveryInMinutes': minutes,
      'acceptedTime':DateTime.now().toIso8601String(),
      'status': 'accepted',
    }).then((value) {
      // Show toast after updated
      Widget toast = Container(
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

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(milliseconds: 1500),
      );

      Future.delayed(const Duration(milliseconds: 1750), () {
        setState(() {});
        Navigator.of(context).pop(true);
      });
    });
  }

  Future<void> rejectOrder() async {
    var orderDocId = widget.orderDocId;

    return await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderDocId)
        .update({
      'status': 'rejected',
    }).then((value) {
      // Show toast after updated
      Widget toast = Container(
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

      fToast.showToast(
        child: toast,
        gravity: ToastGravity.BOTTOM,
        toastDuration: Duration(milliseconds: 1500),
      );

      Future.delayed(const Duration(milliseconds: 1750), () {
        setState(() {});
        Navigator.of(context).pop(true);
      });
    });
  }

  Future getOrdersDetails() async {
    var orderDocId = widget.orderDocId;

//    print('res ID$restaurantId');

    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("orders")
        .doc(orderDocId)
        .collection('items')
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getOrdersDetails(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Text('Loading'),
              ),
            );
          } else {
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
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return EstimatedTimeDialog(
                                      onDoneListener: (int selectedMinutes) {
                                    updateOrderStatus(selectedMinutes);
                                  });
                                },
                              );
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
                              rejectOrder();
                            }),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Having issues with this order? Contact driver.",
                            style: TextStyle(
                              color: Colors.black45,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var url = "tel:${widget.userContactNumber}";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Text(
                            "${widget.userContactNumber}",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: 'OpenSans',
                                color: Colors.brown,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                appBar: AppBar(
                  iconTheme: IconThemeData(
                    color: Colors.black, //change your color here
                  ),
                  title: Container(
                    child: Center(
                      child: Text(
                        "Waiting for confirmation",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 14,
                          fontFamily: 'OpenSans',
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
                body: ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]['menuName']),
                        trailing: Text(
                          'x ${snapshot.data[index]['quantity']}',
                          style: TextStyle(color: Colors.red),
                        ),
                        leading: Container(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.network(
                            '${snapshot.data[index]['foodImg']}',
                            fit: BoxFit.cover,
                            height: 50.0,
                            width: 50.0,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        )),
                      );
                    }));
          }
        });
  }
}
