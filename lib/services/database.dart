import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});

  final CollectionReference sandwichCollection = FirebaseFirestore.instance.collection('sandwiches');
  final CollectionReference profilelist = FirebaseFirestore.instance.collection('restaurantProfileInfo');
  final CollectionReference restaurantlist = FirebaseFirestore.instance.collection('restaurantProfileInfo').doc().collection('menus');

  Future updateUserData(String name, String address, int phone ) async{
    return await sandwichCollection.doc(uid).set({
      'name': name,
      'address': address,
      'phone': phone,
    }
    );

  }

  Future<void> createRestaurantData(String uploadedImg, String restaurantName, String email, String password,
      String categories, String address, String phone, String facebook_url, String time,String uid) async {
    return await profilelist.doc(uid).set({
      'uploadedImg': uploadedImg,
      'restaurantName': restaurantName,
      'email': email,
      'password': password,
      'categories': categories,
      'address': address,
      'phone': phone,
      'facebook_url': facebook_url,
      'time': time
    });
  }


  Future<void> insertMenu(String title, String price, String content, String uploadedImg) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
//    print('eeeeeeeeee ${uid}');

    return await FirebaseFirestore.instance.collection('restaurantProfileInfo').doc(uid).collection('menus').doc().set({
      'title': title,
      'price': price,
      'content': content,
      'foodImg': uploadedImg,
    });
  }
}