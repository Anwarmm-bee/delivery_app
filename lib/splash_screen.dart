import 'package:flutter/material.dart';
import 'dart:async';
import 'login_screen.dart'; // ✅ Added import

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    gotoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/images/logo.png', width: 150),
          ),
          SizedBox(height: 20),
          Text(
            "eSupplyco Delivery App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> gotoLogin()async{
    await Future.delayed(Duration(seconds: 5));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx1){
      return LoginScreen();
    }));
  }
}
