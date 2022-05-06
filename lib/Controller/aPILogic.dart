import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:glucose_predictor/Model/Ingredient.dart';
import 'package:http/http.dart' as http;

var token = [
  "1ab2db2229ed969c132af157a9cbefe5699802ba",
  "28b9c4320de1612707b3d8a2631e9a3b64adb8df",
  "53cbad19537f00fb6daf35bcd0ca7b5169af428d",
  "5217b1057d4500d22acea3ca6976a1f247a066c6",
  "152596692c3bebf8682401e70d36c50d31ec9c68",
  "683c51d5d4df3708dd550f5e784905208cdbafba",
  "96d710827473b0b7b9854cf5999da86322da0c22",
  "f98b8c50b0d51baf315302c6440667c82cd1e4bf",
  "c558895bd0568912d58f26d060cc3682704ecb35",
  "dda82fe5c6e2e1342bb42d67230460f565e8c5af",
  "a43b878ca923996795a1fa0d13b51b89b92ce204",
];
var tokenIndex = 0;

Future<Ingredient> uploadImage(Uint8List imageFile) async {
    var uri1 = Uri.parse("https://api.logmeal.es/v2/recognition/complete");
    var request = http.MultipartRequest("POST", uri1);
    request.fields['title'] = "dummyData";
    request.headers['Authorization'] = "Bearer " + token[tokenIndex];

    print("THE TOKEN IS ${token[tokenIndex]}");
    var picture = http.MultipartFile.fromBytes('image', imageFile,
        filename: 'testImage.jpeg');
    request.files.add(picture);
    var response = await request.send();
    print("FIRST RESPONSE FOR UPLOAD IMAGE - ${response.statusCode}");
    if(response.statusCode == 429) {
      tokenIndex++;
      if (tokenIndex >= token.length) {
        tokenIndex = 0;
        throw Exception("YOU ARE OUT OF TOKEN");
      }
      return uploadImage(imageFile);
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
  print("SECOND RESPONSE FOR REQUESTING - ${response.statusCode}");
  var reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  Ingredient ingredients = Ingredient.fromJson(jsonDecode(reply));

  return ingredients;
}
