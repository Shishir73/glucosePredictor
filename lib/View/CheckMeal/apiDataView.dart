import 'dart:io';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/Controller/aPILogic.dart';
import 'package:glucose_predictor/Controller/firebaseService.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:glucose_predictor/View/CheckMeal/editIngScreen.dart';

class ApiDataView extends StatefulWidget {
  final String imageFile;

  const ApiDataView(this.imageFile, {Key? key}) : super(key: key);

  @override
  _ApiDataViewState createState() => _ApiDataViewState(imageFile);
}

class _ApiDataViewState extends State<ApiDataView> {
  String imageFile;

  _ApiDataViewState(this.imageFile);

  // INSTANCE TO GET INGREDIENT DATA
  late Future<Ingredient> _apiIngData;
  bool isLoading = false;
  String uniqueKey = "imzY" + UniqueKey().hashCode.toString();

  Future<Ingredient> getIngredients() async {
    var f = await File(imageFile).readAsBytes();
    return await getDataFromImage(f);
  }

  saveToFire() async {
    Ingredient _ingredient = await _apiIngData;
    var imgLink = await uploadFireImage(imageFile);
    String URL = imgLink;
    await saveToFirebase(_ingredient, URL, uniqueKey);
  }

  @override
  void initState() {
    super.initState();
    _apiIngData = getIngredients();
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
        Visibility(
            visible: isLoading,
            child: const LinearProgressIndicator(
              backgroundColor: Colors.greenAccent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            )),
        Flexible(child: _buildListView()),
      ])),
    );
  }

  Widget _buildListView() {
    return FutureBuilder<Ingredient>(
      future: _apiIngData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              padding: const EdgeInsets.fromLTRB(60.0, 2.0, 60.0, 45.0),
              children: [
                SizedBox(
                  child: Center(
                      child: Text(
                    "${snapshot.data?.foodName}",
                  )),
                ),
                Container(
                  child: Column(
                    children: snapshot.data?.recipe
                            ?.map((e) => ListTile(
                                  title: Text("${e.name}"),
                                  trailing: Text("~${e.weight} gram"),
                                ))
                            .toList() ??
                        [],
                  ),
                ),
                const SizedBox(height: 30.0, width: 10.0),
                SizedBox(
                    child: ElevatedButton(
                  onPressed: () async {
                    await _gotoEditScreen(context);
                  },
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

  _gotoEditScreen(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    await saveToFire();
    print("*****.SAVED TO 🔥 DATABASE 👏.*****");
    setState(() {
      isLoading = false;
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EditScreen(uniqueKey, imageFile)));
  }
}
