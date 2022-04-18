import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:http/http.dart' as http;

String token = "f98b8c50b0d51baf315302c6440667c82cd1e4bf"; // Shishir user
// String token = "c558895bd0568912d58f26d060cc3682704ecb35";
// String token = "dda82fe5c6e2e1342bb42d67230460f565e8c5af";
// String token = "683c51d5d4df3708dd550f5e784905208cdbafba";
// String token = "96d710827473b0b7b9854cf5999da86322da0c22";
// String token = "a43b878ca923996795a1fa0d13b51b89b92ce204";

Future<Ingredient> uploadImage(File imageFile) async {
  print("INSIDE UPLOAD IMAGE FUNCTION!");
  var uri1 = Uri.parse("https://api.logmeal.es/v2/recognition/complete");
  var request = http.MultipartRequest("POST", uri1);
  request.fields['title'] = "dummyData";
  request.headers['Authorization'] = "Bearer " + token;
  print("DONE WITH AUTHENTICATION!");

  print("LOADING THE IMAGE FILE i.e. PATH = ${imageFile.path}");
  print("LOADING THE IMAGE FILE i.e. toString() = ${imageFile.toString()}");
  var picture = http.MultipartFile.fromBytes('image',
      (await rootBundle.load('assets/food.jpg')).buffer.asInt8List(),
      filename: 'testImage.jpeg'); // imageFile.toString()
  print("LOADED THE IMAGE!");

  request.files.add(picture);
  var response = await request.send();
  print("FIRST RESPONSE FROM SERVER - ${response.statusCode}");
  var responseData = await response.stream.toBytes();
  var result = String.fromCharCodes(responseData);
  var imgID = jsonDecode(result);
  print("*** PARSED DATA FOR IMAGE ID!! ***");
  print(imgID['imageId']);
  Map data = {'imageId': imgID['imageId']};

  Ingredient ingData = await requestIng(data);
  print("*** GOT THE DATA FROM requestIng method. ***");
  print(ingData.imageId.toString());

  return ingData;
}

Future<Ingredient> requestIng(Map imageID) async {
  HttpClient httpClient = HttpClient();
  HttpClientRequest request = await httpClient
      .postUrl(Uri.parse('https://api.logmeal.es/v2/recipe/ingredients'));
  request.headers.set("Authorization", "Bearer " + token);
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(imageID)));
  HttpClientResponse response = await request.close();

  print("*** THE RESPONSE FROM THE INGREDIENT SERVER IS - ***");
  print(response.statusCode);
  var reply = await response.transform(utf8.decoder).join();
  httpClient.close();

  print("*** INGREDIENT DATA FOOD FAMILY! ***");
  print(reply);

  print("*** INGREDIENT FROMJSON after decode! ***");
  print(Ingredient.fromJson(jsonDecode(reply)));

  Ingredient ingredients = Ingredient.fromJson(jsonDecode(reply));

  return ingredients;
}