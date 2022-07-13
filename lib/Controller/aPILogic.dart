import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:http/http.dart' as http;

var tokenIndex = 0;
var token = [
  "948d0293ed8b2cdd8ed8728d0ae0404460ef7be2",
  "9951f8dcb93b2baa9a53678c40b078f07771559e",
  "56b474f48dc5ea21776e60054ef03d722225829d",
  "a2cb0d37bd7783d5ee72c5aa9bbabd6e71d219c3",
  "5b6f49762bd12ebaec66a4fc423dbf8eaa2c0334",
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
