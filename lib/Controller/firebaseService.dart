import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';

Future saveToFirebase(Ingredient data, String imgURL) async {
  var db = FirebaseFirestore.instance.collection("ApiData");
  Map<String, dynamic> food = {
    "dishid": data.dish_id,
    "name": data.foodName,
    "hasrecipe": data.hasRecipe,
    "image": data.imageId,
    "combo": data.is_combo,
    "servingsize": data.serving_size,
    "source": data.source,
    "url": imgURL
  };
  await db.add(food);
  print("success");
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
