import 'dart:io';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/Controller/carbsDirectory.dart';
import 'package:glucose_predictor/Controller/firebaseService.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class EditScreen extends StatefulWidget {
  final String uniqueKey;
  final String imageFile;

  EditScreen(this.uniqueKey, this.imageFile, {Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState(uniqueKey, imageFile);
}

class _EditPageState extends State<EditScreen> {
  String uniqueKey;
  String imageFile;

  _EditPageState(this.uniqueKey, this.imageFile);

  late Future<List<dynamic>?> _futureRecipe;

  @override
  void initState() {
    super.initState();
    _futureRecipe = fireRecipeData(uniqueKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Details Page",
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
          )),
      body: SizedBox(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
          child: Container(
              width: MediaQuery.of(context).size.width - 200,
              height: MediaQuery.of(context).size.height - 600,
              child: Image.file(
                File(imageFile),
                fit: BoxFit.fitWidth,
              )),
        ),
        _createHeaders(),
        Flexible(flex: 5, child: _createSliderWidget()),
        Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Container(
              child: FormHelper.submitButton(
                "Save",
                () async {
                  var fireData = await getRecipeById("sOwayJKgcXpGsTMH13Fh");
                  print(fireData![0]["name"]);
                  print(fireData);
                },
              ),
            )),
      ])),
    );
  }

  _createHeaders() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 0.0, 3.0, 3.0),
        child: Row(
          children: const [
            Text("Ingredient",
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
            Spacer(),
            Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  "Carbs",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            Spacer(),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text(
                  "Quantity",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
          ],
        ));
  }

  _createSliderWidget() {
    return FutureBuilder<List<dynamic>?>(
      future: _futureRecipe,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error;
          return Text("🥹 $error");
        } else if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                double _weight = snapshot.data![index]["weight"];
                // double _carbs = _newList[index].carbs;
                return Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5.0, 0, 0, 0),
                          child: Text("${snapshot.data![index]["name"]}"),
                        ),
                        const Spacer(),
                        Flexible(
                            child: FormHelper.inputFieldWidget(
                          context,
                          "",
                          "1", // _carbs.round().toString(),
                          () {},
                          (onValueSave) => {
                            // _newList[index].carbs = int.parse(onValueSave),
                          },
                          initialValue: "1",
                          borderFocusColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          isNumeric: true,
                          fontSize: 14,
                        )),
                        Flexible(
                            child: FormHelper.inputFieldWidget(
                          context,
                          "",
                          _weight.round().toString(),
                          () {},
                          (onValueSave) => {
                            snapshot.data![index]["weight"] =
                                int.parse(onValueSave),
                          },
                          initialValue: "${snapshot.data![index]["weight"]}",
                          borderFocusColor: Colors.transparent,
                          borderColor: Colors.transparent,
                          isNumeric: true,
                          fontSize: 14,
                        )),
                      ],
                    ),
                    Slider(
                        value: double.parse(_weight.toStringAsFixed(1)),
                        min: 0,
                        max: 800,
                        divisions: 800,
                        label: _weight.toStringAsFixed(1),
                        onChanged: (double value) {
                          setState(() {
                            _weight = value;
                            snapshot.data![index]["weight"] = value;

                            // _newList[index].carbs =
                            //     (getCarbohydrates()[_newList[index].name] ?? 0) *
                            //         _quantity;
                          });
                        }),
                  ],
                );
              });
        } else {
          return const CircularProgressIndicator(color: Colors.orange);
        }
      },
    );
  }
}

Future<List?> fireRecipeData(String val) async {
  return await getRecipeById(val);
}
