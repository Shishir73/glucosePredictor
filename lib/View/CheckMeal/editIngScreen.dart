import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:glucose_predictor/Controller/carbsDirectory.dart';
import 'package:glucose_predictor/Controller/firebaseService.dart';
import 'package:glucose_predictor/main.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class EditScreen extends StatefulWidget {
  final String uniqueKey;
  final String imageFile;

  const EditScreen(this.uniqueKey, this.imageFile, {Key? key})
      : super(key: key);

  @override
  _EditPageState createState() => _EditPageState(uniqueKey, imageFile);
}

class _EditPageState extends State<EditScreen> {
  String uniqueKey;
  String imageFile;

  _EditPageState(this.uniqueKey, this.imageFile);

  // INSTANCE TO GET FIREBASE DATA
  late Future<List<dynamic>?> _futureRecipe;
  late List? _recipesValue;

  Future<List?> getRecipeData(String val) async {
    return await getRecipeById(val);
  }

  @override
  void initState() {
    super.initState();
    _futureRecipe = getRecipeData(uniqueKey);
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
                  print(_futureRecipe.toString());
                  _recipesValue = await _futureRecipe;
                  _updateFireData(context, uniqueKey, _recipesValue);
                  print("DOG. 🐶 DONE!");
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
                  "Carbs(g)",
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                )),
            Spacer(),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Text(
                  "Quantity(g)",
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
                double _carbs = snapshot.data![index]["carbs"] ?? 1;
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
                          _carbs.round().toString(),
                          () {},
                          (onValueSave) => {
                            snapshot.data![index]["carbs"] =
                                int.parse(onValueSave),
                          },
                          initialValue: "${snapshot.data![index]["carbs"]}",
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
                            snapshot.data![index]["carbs"] =
                                (getCarbs()[snapshot.data![index]["name"]] ??
                                        1) *
                                    _weight;
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

  _updateFireData(BuildContext context, String key, List? rVal) async {
    await updateRecipe(key, rVal);

    return showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: const Text("Ingredients Saved 👏"),
        content: const Text(
            "The ingredients has been saved.\nYou can view it on home screen."),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("OK"),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: 'Predict Glucose')),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
