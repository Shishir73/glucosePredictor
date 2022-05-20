import 'dart:io';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/Controller/aPILogic.dart';
import 'package:glucose_predictor/Controller/firebaseService.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';

class ApiDataView extends StatelessWidget {
  final String imageFile;

  const ApiDataView(this.imageFile, {Key? key}) : super(key: key);

  Future<Ingredient> getIngredients() async {
    var f = await File(imageFile).readAsBytes();
    var ingredients = await getDataFromImage(f);

    var imgLink = await uploadFireImage(imageFile);
    String URL = imgLink;

    await saveToFirebase(ingredients, URL);

    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Ingredient Contain',
            style: TextStyle(color: Color(0xff909090))),
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
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 500,
            child: Image.file(
              File(imageFile),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Flexible(child: _buildListView()),
      ])),
    );
  }

  Widget _buildListView() {
    return FutureBuilder<Ingredient>(
      future: getIngredients(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              padding: const EdgeInsets.fromLTRB(60.0, 2.0, 60.0, 45.0),
              children: [
                Container(
                  child: Column(
                    children: snapshot.data?.recipe
                            ?.map((e) => ListTile(
                                  title: Text("${e.name}"),
                                  trailing: Text(" ~${e.weight}gram"),
                                ))
                            .toList() ??
                        [],
                  ),
                ),
                const SizedBox(height: 30.0, width: 10.0),
                SizedBox(
                    child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22.0, vertical: 10.0),
                    primary: const Color(0Xff4CA4D6),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Edit Ingredients",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                )),
              ]);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
