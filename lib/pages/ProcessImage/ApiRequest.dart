import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiRequest extends StatelessWidget {
  final File imageFile;

  const ApiRequest(this.imageFile, {Key? key}) : super(key: key);

  Future getIngredientsData() async {
    String token = 'f98b8c50b0d51baf315302c6440667c82cd1e4bf';
    var stream = http.ByteStream(imageFile.openRead());

    var length = await imageFile.length();  // get file length

    var uri = Uri.parse("https://api.logmeal.es/v2/recognition/dish");  // string to uri

    var request = http.MultipartRequest("POST", uri); // create multipart request
    request.headers.addAll({"Authorization": "Bearer $token"});

    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));  // multipart that takes file

    request.files.add(multipartFile); // add file to multipart

    var response = await request.send(); // send

    print(response.statusCode);
    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Card(
          child: FutureBuilder(
            future: getIngredientsData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: const Center(
                    child: Text('Loading...'),
                  ),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(snapshot.data[i].name),
                        subtitle: Text(snapshot.data[i].id),
                        trailing: Text(snapshot.data[i].prob),
                      );
                    });
              }
            },
          ),
        ),
      ),
    );
  }
}

class Meal {
  final String id, name, prob;
  Meal(this.id, this.name, this.prob);
}
