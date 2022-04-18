import 'dart:io';
import 'package:glucose_predictor/Controller/APILogic.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:flutter/material.dart';

class ApiDataView extends StatelessWidget {
  final String imageFile;
  const ApiDataView(this.imageFile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            child: const Icon( Icons.arrow_back_ios, color: Colors.black,),
            onTap: () {
              Navigator.pop(context);
            } ,
          ) ,
        ),
        body: Center (
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 3.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 500,
                    child: Image.file(
                      File(imageFile),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              FutureBuilder<Ingredient>(
                future: uploadImage(File(imageFile)),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data?.recipe
                              ?.map((e) => Text("${e.name} - ${e.weight}"))
                              .toList() ?? [],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
            ])
        ),
        );
  }
}
