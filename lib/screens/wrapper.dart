import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_sample/models/user.dart';
import 'package:sandwich_sample/screens/authenticate/authenticate.dart';
import 'package:sandwich_sample/screens/authenticate/sign_in.dart';
import 'package:sandwich_sample/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Users>(context);
    //return either Home or Authentication widget

    if(user == null){
      return Authenticate();

    }else{
      return Home();
    }
  }
}
