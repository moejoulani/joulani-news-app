import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/paper2.jpg'), fit: BoxFit.cover),
          ),
        ),
        Center(
          child: Text(
            "Loading ... ",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        )
      ],
    ));
  }
}
