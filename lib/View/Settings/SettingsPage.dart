import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsView();
}

class _SettingsView extends State<SettingsPage> {
  bool status = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Settings",
              style: TextStyle(color: Color(0xff909090))),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _getInfo(),
            const SizedBox(width: 10, height: 10),
            Container(
              alignment: Alignment.center,
              child: const Text("Select preferred Unit:"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterSwitch(
                  activeText: "mmol/L",
                  inactiveText: "mg/dL",
                  value: status,
                  valueFontSize: 17.0,
                  width: 115,
                  height: 45,
                  borderRadius: 45.0,
                  toggleSize: 45.0,
                  padding: 1.0,
                  activeColor: const Color(0Xff5281CA),
                  inactiveColor: const Color(0Xff5281CA),
                  showOnOff: true,
                  onToggle: (val) {
                    setState(() {
                      status = val;
                    });
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () {
                      _showUnitInfo(context);
                    },
                    icon: const Icon(Icons.info_outline))
              ],
            ),
            const SizedBox(width: 1, height: 20),
            SizedBox(
              width: 170,
              height: 40,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Current Glucose Level",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(),
                  ),
                ),
                validator: (val) {
                  if (val?.length == 0) {
                    return "Email cannot be empty";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10, height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 7.0),
                primary: const Color(0Xff53DB61),
                shape: const StadiumBorder(),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
          ],
        )),
      );

  _showUnitInfo(BuildContext context) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: const Text("Measurement Units"),
        content: const DecoratedBox(
          decoration: BoxDecoration(color: Color(0XffFFFDEA)),
          child: Text(
              "mg/dL  milligrams per deciliters \n \n 1 mg/dL = 18.018018 mmol/L \n \n mmol/L  millimoles per liters"),
        ),
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

  _getInfo() {
    List<String> list = [
      "Glucose Predictor is designed for people with diabetes who need to mainitain their blood glucose level.",
      "There are two types of units to measure blood glucose level depending on the device used like mg/dl and nmol/L.",
      "People with diabetes has to find ways to calculate glucose level in food before eating.",
      "Glucose Predictor provides you an easy and quick way to calculate the glucose level in the food by just clicking a picture.",
      "Glucose Predictor provides an option to log your meal and glucose level and user can see  overview of it at any time."
    ];

    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 1.6,
        enlargeCenterPage: true,
      ),
      items: list
          .map((item) => Container(
                child: Center(
                    child: Center(
                        child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Text(item,
                                style: const TextStyle(
                                  fontSize: 25.0,
                                  color: Colors.black,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 7,
                                textAlign: TextAlign.center)))),
                color: const Color(0XffFFF9C2),
              ))
          .toList(),
    );
  }
}
