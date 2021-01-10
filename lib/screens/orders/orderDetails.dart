import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class OrderDetails extends StatefulWidget {
  final orderDocId;

  const OrderDetails({Key key, this.orderDocId}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Future<void> whenAccept(String status) async {
    var orderDocId = widget.orderDocId;

    return await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderDocId)
        .update({
      'status': status,
    });
  }

  Future<void> whenReject(String status) async {
    var orderDocId = widget.orderDocId;

    return await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderDocId)
        .update({
      'status': status,
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
                child: Text('ssssss'),
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
      body: FutureBuilder(
          future: getOrdersDetails(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text('Loading'),
              );
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Text(snapshot.data[index]['menuName']),

                      trailing: Text(
                        snapshot.data[index]['menuPrice'],
                        style: TextStyle(color: Colors.red),
                      ),
                      leading: Container(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black12,
                            child: ClipOval(
                              child: SizedBox(
                                width: 180.0,
                                height: 180.0,
                                child: Image.network(
                                  '${snapshot.data[index]['foodImg']}',
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          )),

                    );
                  });
            }
          }),
    );
  }
}