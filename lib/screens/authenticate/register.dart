import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandwich_sample/services/auth.dart';
import 'package:sandwich_sample/shared/constant.dart';
import 'package:sandwich_sample/shared/loading.dart';
import 'package:path/path.dart';


class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); //identify form, validation form
  bool loading = false;

  String restaurantName = '';
  String email = '';
  String password = '';
  String categories = '';
  String address = '';
  String phone = '';
  String facebook_url = '';
  String time = '';
  String error = '';

  String valueChoose;
  List categoriesList = [
    'Japanese',
    'China',
    'Korea',
    'Vegetarian',
    'Western',
    'Cake',
    'Beverage'
  ];

  PickedFile _image;

  Future getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text("Sign Up to Sandwich"),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text('Sign In'))
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
//        child:
//        RaisedButton(
//          child: Text("Sign in anon"),
//          onPressed: ()async{
//          dynamic result = await _auth.signInAnon();
//          if(result == null){
//            print('Error in Signing In');
//          }else{
//            print('Signed In');
//            print(result.uid);
//
//          }
//          },
//        ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        error,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: CircleAvatar(
                          backgroundImage: AssetImage('assets/image/noImg.png'),
                          radius: 40,
                          backgroundColor: Colors.black12,
                          child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image != null)
                                ? Image.file(File(_image.path),
                                    fit: BoxFit.cover)
                                : Image.network(
                                    '',
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                            //TODO: step 4 : display user profile picture
                          ),
                        ),
                      ),
                      Text("Upload Logo"),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Restaurant Name'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an Restaurant Name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            restaurantName = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Email'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value.length < 6) {
                            return 'Enter at least 6 numbers';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      Card(
                        child: DropdownButton(
                          hint: Text("  Select Categories  ",
                              style: TextStyle(
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                          dropdownColor: Colors.white,

//              isExpanded: true,
                          underline: SizedBox(),
//                style: TextStyle(color: Colors.black, fontSize: 16),
                          value: valueChoose,
                          onChanged: (newValue) {
                            setState(() {
                              categories = newValue;
                            });
                          },
                          items: categoriesList.map((valueGuests) {
                            return DropdownMenuItem(
                              value: valueGuests,
                              child: Text(valueGuests),
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Address'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an Address';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            address = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: 'Phone'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an Phone';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            phone = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Facebook Url'),
//                        validator: (value) {
//                          if (value.isEmpty) {
//                            return 'Please enter an Facebook Url';
//                          }
//                          return null;
//                        },
                        onChanged: (value) {
                          setState(() {
                            facebook_url = value;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: 'Business Time'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter an Business Time';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            time = value;
                          });
                        },
                      ),
                      RaisedButton(
                        color: Colors.brown,
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {

                          String fileName = basename(_image.path);
                          Reference reference = FirebaseStorage.instance.ref().child(fileName);
                          UploadTask uploadTask = reference.putFile(File(_image.path));
                          TaskSnapshot taskSnapshot =
                          await uploadTask.whenComplete(() => print("Uploaded"));

                          var uploadedImg = await taskSnapshot.ref.getDownloadURL();                          String finalRestaurantName = restaurantName.trim();
                          String finalEmail = email.trim();
                          String finalPassword = password.trim();
                          String finalPhone = phone.trim();
                          String finalCategories = categories.trim();
                          String finalAddress = address.trim();
                          String finalFacebookUrl = facebook_url.trim();
                          String finalTime = time.trim();

                          if (_formKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    uploadedImg,
                                    finalRestaurantName,
                                    finalEmail,
                                    finalPassword,
                                    finalCategories,
                                    finalAddress,
                                    finalPhone,
                                    finalFacebookUrl,
                                    finalTime);
                            if (result == null) {
                              setState(() {
                                error = 'Please supply a valid email !';
                                loading = false;
                              });
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
