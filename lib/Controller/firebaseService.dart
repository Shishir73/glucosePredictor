import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glucose_predictor/Model/FireBaseIngredients.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:intl/intl.dart';

var collectionRef = FirebaseFirestore.instance.collection("apiIngredients");

Future saveToFirebase(Ingredient data, String imgURL, String uniqueKey) async {
  Map<String, dynamic> food = {
    "dateTime": DateFormat("H:mm, d/M/yyyy").format(DateTime.now()),
    "dishId": data.dish_id,
    "foodName": data.foodName,
    "hasRecipe": data.hasRecipe,
    "image": data.imageId,
    "recipe": data.recipe?.map((v) => v.toJson()).toList(),
    "source": data.source,
    "url": imgURL,
    "createdDate": DateFormat("d/M/yyyy").format(DateTime.now()),
  };
  await collectionRef.doc("$uniqueKey").set(food);
  print("FOOD 🔥 SAVED!");
}

Future<String> uploadFireImage(String imagePath) async {
  Reference db1 =
      FirebaseStorage.instance.ref("apiImages/${getImageName(imagePath)}");
  await db1.putFile(File(imagePath));
  String url = await db1.getDownloadURL();
  print(url);
  return url;
}

String getImageName(String image) {
  return image.split("/").last;
}

Future<List<dynamic>?> getRecipeById(String uniqueKey) async {
  final ref = collectionRef.doc(uniqueKey).withConverter(
        fromFirestore: FireBaseIng.fromFirestore,
        toFirestore: (FireBaseIng data, _) => data.toFirestore(),
      );

  final docSnap = await ref.get();
  return docSnap.data()?.recipe;
}

updateRecipe(String uniqueKey, List? value) async {
  return await collectionRef
      .doc(uniqueKey)
      .update({'recipe': value})
      .then((_) => print('Updated'))
      .catchError((error) => print('Update failed: $error'));
}
