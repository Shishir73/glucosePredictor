import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/View/Home/homePage.dart';
import 'package:glucose_predictor/Model/FireBaseIngredients.dart';
class DetailPage extends StatelessWidget {
  var index1;

  DetailPage(this.index1);

  //final List? list1=convert(index1["recipe"]);

  // String get recipe => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(index1["foodName"],
            style: TextStyle(color: Color(0xff909090))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SizedBox(
        child: Column(children: [
        Padding(
        padding: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 3.0),
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height - 500,
          child: Image.network(
            index1["url"],
            fit: BoxFit.cover,
          ),
        ),
      ),
          Flexible(
            child: ListView.builder(
            shrinkWrap:true,
    itemCount: index1["recipe"].length,
    scrollDirection: Axis.vertical,
    itemBuilder:(BuildContext context, int index) {
      return ListTile(
        title: Text(
          index1["recipe"][index].toString(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      );
    }
            ),
    ),
      ],
    ),
    ),
    );
  }
}

