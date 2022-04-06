import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.grey,
    body: Center(
      child: Text(
        "Home",
        style: TextStyle(fontSize: 60, color: Colors.white),
      ),
    ),
  );
}