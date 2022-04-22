import 'dart:io';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/View/CheckMeal/ApiDataView.dart';

class ConfirmScreen extends StatelessWidget {
  final String path;

  const ConfirmScreen(this.path, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 3.0),
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
          padding: const EdgeInsets.fromLTRB(2.0, 7.0, 3.0, 3.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 12.0),
                primary: const Color(0Xff53B2DB),
                shape: const StadiumBorder(),
              ),
              onPressed: () {
                // save the image to DataBase
              },
              child: const Text(
                "Save for Later",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            SizedBox(
                width: (MediaQuery.of(context).size.width / 2.6), height: 5),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ApiDataView(path)));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
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
      ])),
    );
  }
}
