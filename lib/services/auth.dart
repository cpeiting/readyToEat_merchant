import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sandwich_sample/models/user.dart';
import 'package:sandwich_sample/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj base on FirebaseUser
  Users _userFromFirebaseUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  Stream<Users> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

//Signin anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      //User == FirebaseUser
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Signin with Email & Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Register with Email & Password
//  Future registerWithEmailAndPassword(String email, String password)async{
//    try{
//      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//      User user = result.user;
//      //create a new document for user with uid
//      await DatabaseService(uid: user.uid).updateUserData('Cpeiting', '566 jingga 6', 0167755053);
//      return _userFromFirebaseUser(user);
//    }catch(e){
//    print(e.toString());
//    return null;
//    }
//  }

  Future registerWithEmailAndPassword(
      String uploadedImg,
      String restaurantName,
      String email,
      String password,
      String categories,
      String address,
      String phone,
      String facebook_url,
      String time) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DatabaseService().createRestaurantData(uploadedImg, restaurantName, email,
          password, categories, address, phone, facebook_url, time, user.uid);
      return user;
      //create a new document for user with uid
//      await DatabaseService(uid: user.uid).updateUserData('Cpeiting', '55 jingga 3', 0167755053);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
    }
  }

  //insert menu

  Future insertMenus(String title, String price, String content, String uploadedImg) async {
    try {
      await DatabaseService().insertMenu(title, price, content,uploadedImg);
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  //Signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getCurrentUID() async {
    String uid = (await _auth.currentUser).uid;
    return uid;
  }
}
