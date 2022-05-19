import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:glucose_predictor/Model/Recipe.dart';
import 'package:image_picker/image_picker.dart';
import '../View/CheckMeal/apiDataView.dart';
import 'package:glucose_predictor/Controller/aPILogic.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/Controller/aPILogic.dart';

import '../View/CheckMeal/apiDataView.dart';

class FirebaseService {


 // String url=" ";



  savetofirebase(Ingredient data) async
  {
    //url=" ";
    var db = FirebaseFirestore.instance.collection("ApiData");
    Map<String, dynamic> food = {
      "dishid": data.dish_id,
      "name": data.foodName,
      "hasrecipe": data.hasRecipe,
      "image": data.imageId,
      "combo": data.is_combo,
      "servingsize": data.serving_size,
      "source": data.source,
      //"url": url
    };
    await db.add(food);
    print("success");
  }

  Future<String> uploadimage(XFile image) async {
    Reference db1 = FirebaseStorage.instance.ref("testFolder/${getImageName(image)}");
    await db1.putFile(File(image.path));
    String url= await db1.getDownloadURL();
    print(url);
    return url;
  }


  String getImageName(XFile image){
    return image.path.split("/").last;
  }
}