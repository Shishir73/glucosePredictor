import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Colors.grey,
    body: Center(
      child: Text(
        "Home",
        style: TextStyle(fontSize: 60, color: Colors.white),
      ),
    ),
  );

}