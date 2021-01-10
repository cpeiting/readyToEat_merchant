import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_sample/models/user.dart';
import 'package:sandwich_sample/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sandwich_sample/services/auth.dart';
import 'package:sandwich_sample/models/user.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
