import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:intl/intl.dart';

Future saveToFirebase(Ingredient data, String imgURL) async {
  var db = FirebaseFirestore.instance.collection("apiIngredients");

  Map<String, dynamic> food = {
    "foodName": data.foodName,
    "dishId": data.dish_id,
    "hasRecipe": data.hasRecipe,
    "recipe": data.recipe?.map((v) => v.toJson()).toList(),
    "image": data.imageId,
    "source": data.source,
    "createdDate": DateFormat("H:mm, d MMM yyyy").format(DateTime.now()),
    "url": imgURL
  };
  await db.add(food);
  print("SUCCESS");
}

Future<String> uploadFireImage(String imagePath) async {
  Reference db1 =
      FirebaseStorage.instance.ref("testFolder/${getImageName(imagePath)}");
  await db1.putFile(File(imagePath));
  String url = await db1.getDownloadURL();
  print(url);
  return url;
}

String getImageName(String image) {
  return image.split("/").last;
}
