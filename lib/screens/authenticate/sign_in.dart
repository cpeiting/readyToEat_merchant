import 'package:flutter/material.dart';
import 'package:sandwich_sample/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sandwich_sample/shared/constant.dart';
import 'package:sandwich_sample/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();//identify form, validation form
  bool loading = false;

  //text field state
  String email ='';
  String password ='';
  String error ='';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign In to Sandwich"),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: (){
                widget.toggleView();
              },
              icon: Icon(Icons.person),
              label: Text('Register'))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
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
          key:_formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              Text(
                error,
                style:TextStyle(
                  color:Colors.red,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (value){
                 if(value.isEmpty) {
                    return 'Please enter an email';
                  };
                 return null;
                },
                onChanged: (val){
                setState(() {
                  email = val;
                });
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                validator: (value){
                  if(value.length < 6){
                    return 'Enter at least 6 numbers';
                  }
                  return null;
                },
                onChanged: (value){
                setState(() {
                  password = value;
                });
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.brown,
                child: Text('Sign In',
                  style: TextStyle(
                    color: Colors.white),
                ),
                onPressed: ()async{
                  String finalEmail = email.trim();
                  String finalPassword = password.trim();

//                print(email);
//                print(password);
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.signInWithEmailAndPassword(finalEmail, finalPassword);
                    if(result == null){
                      setState(() {
                        error = 'Could not Sign in with this email and password !';
                        loading = false;
                      }
                      );
                    }
                    print(email);
                    print(password);
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
