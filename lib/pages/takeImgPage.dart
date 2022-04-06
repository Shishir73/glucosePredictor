import 'package:flutter/material.dart';

class TakeImgPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Image.network('https://images.unsplash.com/photo-1645974715934-f47f63c05ea6?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80',
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,)
  );
}