import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:glucose_predictor/Model/Food.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';
//import 'package:glucose_predictor/Model/food_notifier.dart';

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
    "createdDatetime": DateFormat("H:mm, d MMM yyyy").format(DateTime.now()),
    "createdTime": DateFormat("d/M/yyyy").format(DateTime.now()),
     "url": imgURL
  };
  await db.add(food);
  print("SUCCESS");
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
/*getFoods(FoodNotifier foodNotifier)async{
  QuerySnapshot result = await FirebaseFirestore.instance.collection('apiIngredients').get();
  List<DocumentSnapshot> documents=result.docs;

  List<Food> _foodList=[];
  documents.forEach((snapshot){
   Food food=Food.fromMap(data) ;
   _foodList.add(food);
  });
  foodNotifier.foodList=_foodList;
}*/

