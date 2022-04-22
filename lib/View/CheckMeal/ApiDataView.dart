import 'dart:io';
import 'package:glucose_predictor/Controller/APILogic.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:flutter/material.dart';

class ApiDataView extends StatelessWidget {
  final String imageFile;

  const ApiDataView(this.imageFile, {Key? key}) : super(key: key);

  Future<Ingredient> getIngredients() async {
    var f = await File(imageFile).readAsBytes();
    return uploadImage(f);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Ingredient Contains',style: TextStyle(color: Color(0xff909090))),
        centerTitle: true,
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
      body: SizedBox(
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
          future: getIngredients(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: snapshot.data?.recipe?.map((e) => ListTile(
                                  title: Text("${e.name}"),
                                  trailing: Text(" ~ ${e.weight}"),
                                  tileColor: const Color(0XffFEF1F1),
                                )
                            // Text("${e.name} - ${e.weight}g", style: const TextStyle(fontSize: 20))
                            )
                        .toList() ??
                [],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
        SizedBox(width: (MediaQuery.of(context).size.width / 2.6), height: 10),
        ElevatedButton(
          onPressed: () {
            /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditIngredients()));*/
          },
          style: ElevatedButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
            primary: const Color(0Xff4CA4D6),
            shape: const StadiumBorder(),
          ),
          child: const Text(
            "Edit Ingredients",
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ])),
    );
  }
}
