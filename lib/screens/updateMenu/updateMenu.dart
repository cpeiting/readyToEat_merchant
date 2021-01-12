import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sandwich_sample/services/auth.dart';
import 'package:sandwich_sample/shared/constant.dart';
import 'package:path/path.dart';


class updateMenu extends StatefulWidget {
  @override
  _updateMenuState createState() => _updateMenuState();
}

class _updateMenuState extends State<updateMenu> {
  final _formKey = GlobalKey<FormState>(); //identify form, validation form
  bool loading = false;
  final AuthService _auth = AuthService();


  String title = '';
  String price = '';
  String content = '';

  PickedFile _image;

  Future getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  Future uploadImage(BuildContext context) async {
    String fileName = basename(_image.path);
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    TaskSnapshot taskSnapshot =
    await uploadTask.whenComplete(() => print("Uploaded"));

    var uploadedImg = await taskSnapshot.ref.getDownloadURL();

    //TODO: Step 2: get image url
    print('uppppp ${uploadedImg}');

    //TODO: step 3 : save url into firestore
//    String uid = FirebaseAuth.instance.currentUser.uid;

//      final CollectionReference userImage =  FirebaseFirestore.instance.collection('restaurantProfileInfo').doc(uid).collection('menus');
//      String userId = FirebaseAuth.instance.currentUser.uid;
//      return userImage.doc(userId).set({
//      'foodImg': uploadedImg,
//    });

    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Uploadeded')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change
          // your color here
        ),
        title: Text("Update Menu",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
//            fontFamily: 'OpenSans',
          ),),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:  Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'title'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an title';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      title = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'price'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an price';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      price = value;
                    });
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'content'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter an content';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      content = value;
                    });
                  },
                ),
              ),
          CircleAvatar(
            backgroundImage: AssetImage('assets/image/noImg.png'),
            radius: 60,
            backgroundColor: Colors.black12,
            child: SizedBox(
              width: 180.0,
              height: 180.0,
              child: (_image != null)
                  ? Image.file(File(_image.path),
                  fit: BoxFit.cover)
                  : Image.network('', loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null ?
                    loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },),
              //TODO: step 4 : display user profile picture
            ),
          ),
              Padding(
                padding: const EdgeInsets.only(left:50,top:10.0, right: 50),
                child: FlatButton(
                  onPressed: (){
                    getImage();
                  },
                  color: Colors.deepOrange,
                  child: Container(
                    child: Row(// Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(Icons.file_upload,color: Colors.white,),
                        SizedBox(width: 10,),
                        Text("Upload Image",style: TextStyle(
                            color: Colors.white
                        ),)

                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              FlatButton(
                onPressed: () async {
                  String finalTitle = title.trim();
                  String finalPrice = price.trim();
                  String finalContent = content.trim();

                  if (_formKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });

                    String fileName = basename(_image.path);
                    Reference reference = FirebaseStorage.instance.ref().child(fileName);
                    UploadTask uploadTask = reference.putFile(File(_image.path));
                    TaskSnapshot taskSnapshot =
                    await uploadTask.whenComplete(() => print("Uploaded"));

                    var uploadedImg = await taskSnapshot.ref.getDownloadURL();
                    dynamic result =
                    await _auth.insertMenus(
                      finalTitle,
                      finalPrice,
                      finalContent,
                        uploadedImg
                    );

//                    Navigator.pop(context);
                    if (result == null) {
                      setState(() {
                        loading = false;
                      });
                    }
                  }
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('Submit', style: TextStyle(fontSize: 20)),
                ),
              ),


            ],
          ),



        ),
      ),
    );
  }
}
