import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sandwich_sample/models/restaurant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class MenuList extends StatefulWidget {
  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  String restaurantID = FirebaseAuth.instance.currentUser.uid;
  TextEditingController _priceController = new TextEditingController();

  Future getCustomers() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("restaurantProfileInfo")
        .doc(restaurantID)
        .collection('menus')
        .get();
//    print("pt"+qn.docs.toString());
    return qn.docs;
  }

  Future deleteMenu(menuDocId) async {
    try {
      print('yyyyy $menuDocId');
      return await FirebaseFirestore.instance
          .collection("restaurantProfileInfo")
          .doc(restaurantID)
          .collection('menus')
          .doc(menuDocId)
          .delete();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateDialog(menuDocId, menuPrice) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text(
                "Edit Price",
                style: TextStyle(color: Colors.red),
              ),
              content: Column(
                children: <Widget>[
                  Column(
                    children: [
                      TextField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'RM $menuPrice',
                          hintText: 'New Price',
                        ),
                      ),
                    ],
                  ),
                  RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      submitAction(menuDocId);
                      Navigator.pop(context);
                    },
                    child: Text("Edit"),
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          );
        });
  }

  var isSelected = false;
  var mycolor = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            'All Menu',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
//            fontFamily: 'OpenSans',
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: FutureBuilder(
            future: getCustomers(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text('Loading'),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length, //number of item
                    itemBuilder: (_, index) {
                      var restaurantMenu =
                          RestaurantMenu.fromJson(snapshot.data[index].data());

                      var menuDocId = snapshot.data[index].id;
                      var menuPrice = restaurantMenu.price;
//                      print('ssssssaaaa $menuDocId');

                      return Column(
                        children: [
                          Container(
                            child: ListTile(
                              selected: isSelected,
                              title: Text(snapshot.data[index]['title']),
                              subtitle: Text(snapshot.data[index]['content']),
                              trailing:
                                  Text('RM ${snapshot.data[index]['price']}'),
                              leading: Container(
                                  child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.transparent,
                                child: ClipRect(
                                  child: SizedBox(
                                    width: 180.0,
                                    height: 180.0,
                                    child: Image.network(
                                      '${snapshot.data[index]['foodImg']}',
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )),
//                              onLongPress: toggleSelection(),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: FlatButton(
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  onPressed: () {
                                    var menuDocId = snapshot.data[index].id;
                                    updateDialog(menuDocId, menuPrice);

                                    print("aaaaaaaa $menuDocId");
                                  },
                                ),
                              ),
                              Container(
                                child: FlatButton(
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        content:
                                            Text("Are you sure to delete?"),
                                        actions: [
                                          FlatButton(
                                              onPressed: () {
                                                var menuDocId =
                                                    snapshot.data[index].id;
                                                deleteMenu(menuDocId);

                                                print("aaaaaaaa $menuDocId");
                                              },
                                              child: Text("Yes")),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "No",
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    });
              }
            }));
  }

  submitAction(menuDocId) {
    FirebaseFirestore.instance
        .collection('restaurantProfileInfo')
        .doc(restaurantID)
        .collection('menus')
        .doc(menuDocId)
        .update({
      'price': _priceController.text,
    });
  }

//  toggleSelection() {
//    setState(() {
//      if (isSelected) {
//        print("eeeeeeee");
//      } else {
//        print("aaaaaaaa");
//        showDialog(
//            context: context,
//            builder: (context) => AlertDialog(
//                  title: Text("Warning"),
//                  content: Text("Are you sure to delete?"),
//                  actions: [
//                    FlatButton(
//                        onPressed: () {
//
//                          FirebaseFirestore.instance
//                              .collection("restaurantProfileInfo")
//                              .doc(restaurantID)
//                              .collection('menus')
//                              .doc()
//                              .delete();
//                          },
//                        child: Text("Yes")),
//                    FlatButton(
//                        onPressed: () {
//
//                          Navigator.of(context).pop(false);
//                        },
//                        child: Text("No"))
//                  ],
//                ));
//      }
//    });
//  }
}
