import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:http/http.dart' as http;

// String token = "f98b8c50b0d51baf315302c6440667c82cd1e4bf"; // Shishir user
String token = "c558895bd0568912d58f26d060cc3682704ecb35";
// String token = "dda82fe5c6e2e1342bb42d67230460f565e8c5af";
// String token = "683c51d5d4df3708dd550f5e784905208cdbafba";
// String token = "96d710827473b0b7b9854cf5999da86322da0c22";
// String token = "a43b878ca923996795a1fa0d13b51b89b92ce204";

Future<Ingredient> uploadImage(Uint8List imageFile) async {
  var uri1 = Uri.parse("https://api.logmeal.es/v2/recognition/complete");
  var request = http.MultipartRequest("POST", uri1);
  request.fields['title'] = "dummyData";
  request.headers['Authorization'] = "Bearer " + token;
  var picture = http.MultipartFile.fromBytes('image', imageFile, filename: 'testImage.jpeg');
  request.files.add(picture);
  var response = await request.send();
  print("FIRST RESPONSE FOR UPLOAD IMAGE - ${response.statusCode}");
  var responseData = await response.stream.toBytes();
  var result = String.fromCharCodes(responseData);
  var imgID = jsonDecode(result);
  Map data = {'imageId': imgID['imageId']};

  Ingredient ingData = await requestIng(data);
  print("DATA RETURNED - " + ingData.toString());
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
  print("SECOND RESPONSE FOR REQUESTING - ${response.statusCode}");
  var reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  Ingredient ingredients = Ingredient.fromJson(jsonDecode(reply));

  return ingredients;
}