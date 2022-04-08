import 'dart:io';

import 'package:flutter/material.dart';

class ConfirmScreen extends StatelessWidget {
  ConfirmScreen(this.path, {Key? key}) : super(key: key);
  String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Confirm Image'),
        ),
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 150,
                child: Image.file(
                  File(path),
                  fit: BoxFit.cover,
                ),
              ),
            ])));
  }
}
