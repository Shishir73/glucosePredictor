import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:http/http.dart' as http;

var tokenIndex = 0;
var token = [
  "8653489f5fda954ca16f485158be3120176fe8cd",
  "040de939a3ef5ca4a11fc66784f09805e80a8f5d",
  "d54ac72571c8c101ee36d932a712ef18425644f6",
  "10a9027cb4ee1c7e45f517f780fd60345baebb71",
  "8119373f1bf96a69f5b64b738260a000fe213ad5",
];

Future<Ingredient> getDataFromImage(Uint8List imageFile) async {
  var uri1 = Uri.parse("https://api.logmeal.es/v2/recognition/complete");
  var request = http.MultipartRequest("POST", uri1);
  request.fields['title'] = "dummyData";
  request.headers['Authorization'] = "Bearer " + token[tokenIndex];

  print("THE TOKEN IS ${token[tokenIndex]}");
  var picture = http.MultipartFile.fromBytes('image', imageFile,
      filename: 'testImage.jpeg');
  request.files.add(picture);
  var response = await request.send();
  print("*** FIRST RESPONSE STATUS CODE *** ${response.statusCode}");
  print("*** FIRST RESPONSE *** \n $response ");

  if (response.statusCode == 429) {
    tokenIndex++;
    if (tokenIndex >= token.length) {
      tokenIndex = 0;
      throw Exception("YOU ARE OUT OF TOKEN");
    }
    return getDataFromImage(imageFile);
  }
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
  request.headers.set("Authorization", "Bearer " + token[tokenIndex]);
  request.headers.set('content-type', 'application/json');
  request.add(utf8.encode(json.encode(imageID)));
  HttpClientResponse response = await request.close();
  print(" *** SECOND RESPONSE STATUS CODE ***  ${response.statusCode}");

  print(" *** SECOND RESPONSE *** \n $response ");

  var reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  Ingredient ingredients = Ingredient.fromJson(jsonDecode(reply));

  return ingredients;
}
