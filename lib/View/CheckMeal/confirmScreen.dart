import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:glucose_predictor/Model/DraftImage.dart';
import 'package:glucose_predictor/View/CheckMeal/apiDataView.dart';
import 'package:glucose_predictor/View/ManualInputPage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';

class ConfirmScreen extends StatelessWidget {
  final String path;

  const ConfirmScreen(this.path, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Confirm Image',
            style: TextStyle(color: Color(0xff909090))),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[IconButton(
          icon: const Icon(Icons.add_moderator_outlined,color: Colors.black,),
          tooltip: 'Enter Manual Value',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ManualPageView()));
          },
        ),
        ],
      ),
      body: Center(
          child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 3.0),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 225,
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 7.0, 3.0, 3.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 12.0),
                primary: const Color(0Xff53B2DB),
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                await _saveAsDraft(context);
                Navigator.pop(context);
              },
              child: const Text(
                "Save for Later",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            SizedBox(
                width: (MediaQuery.of(context).size.width / 2.6), height: 5),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ApiDataView(path)));
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 12.0),
                primary: const Color(0Xff53DB61),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                "Confirm",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ]),
        )
      ])),
    );
  }

  _saveAsDraft(BuildContext context) async {
    String imgName = DateFormat("H:mm, d MMM yyyy").format(DateTime.now());
    Uint8List fPic = await File(path).readAsBytes();
    final nyFood = DraftImage(imgName, fPic);
    print("FILE NAME: ${nyFood.fileName}");
    final draftBox = Hive.box<DraftImage>("DraftImage");
    draftBox.add(nyFood);

    return showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: const Text("Image Saved 😊"),
        content: const Text(
            "The image has been saved.\nYou can view it on home screen."),
        actions: <Widget>[
          BasicDialogAction(
            title: const Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
