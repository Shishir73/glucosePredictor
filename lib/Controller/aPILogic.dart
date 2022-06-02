import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:http/http.dart' as http;

var tokenIndex = 0;
var token = [
  "06dd8599ea3b634ff4469b9119993d9e31c991d5",
  "3936ab98bf4c0354c5bdaf22f76cf4ddd7563d62",
  "b9eda5673c06d114c54537235bca423746a42625",
  "12a8b5ea967c6b7e65c63e000174de5649e80363",
  "0853d94a13b49cab28c8822156da7e2839831670",
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
