import 'dart:io';

import 'package:flutter/material.dart';

class ConfirmScreen extends StatelessWidget {
  ConfirmScreen(this.path, {Key? key}) : super(key: key);
  String path;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(3.0, 90.0, 3.0, 3.0),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 225,
            child: Image.file(
              File(path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(2.0, 2.0, 3.0, 3.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal:10.0, vertical: 12.0),
              primary: const Color(0Xff53B2DB),
              shape: const StadiumBorder(),
            ),
            onPressed: (){

            },
            child: const Text(
              "Save for Later",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          SizedBox(width: (MediaQuery.of(context).size.width/2.6), height: 5),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 12.0),
              primary: const Color(0Xff53DB61),
              shape: const StadiumBorder(),
            ),
            child: const Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ]),
      )
    ]),
    color: Colors.white,);
  }
}

// body: SizedBox(
// width: MediaQuery.of(context).size.width,
// height: MediaQuery.of(context).size.height,
// child: Stack(children: [
// SizedBox(
// width: MediaQuery.of(context).size.width,
// height: MediaQuery.of(context).size.height - 250,
// child: Image.file(
// File(path),
// fit: BoxFit.cover,
// ),
// ),
// ])));
