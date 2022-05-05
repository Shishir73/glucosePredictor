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
        title:
            const Text("Settings", style: TextStyle(color: Color(0xff909090))),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
      child : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: const Text("Select preferred Unit:"),
          ),
          const SizedBox(height: 7, width: 5,),
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
                  onPressed: () {_showUnitInfo(context);},
                  icon: const Icon(Icons.info_outline))
            ],
          ),
          const SizedBox(width: 10, height: 30),
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
                //fillColor: Colors.green
              ),
              validator: (val) {
                if(val?.length == 0) {
                  return "Email cannot be empty";
                }else{
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
          const SizedBox(width: 10, height: 80),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 7.0),
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
        content:
        const DecoratedBox(
          decoration: BoxDecoration(color: Color(0XffFFFDEA)),
          child: Text("mg/dL  milligrams per deciliters \n \n 1 mg/dL = 18.018018 mmol/L \n \n mmol/L  millimoles per liters"),
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
}

// Image.network('https://images.unsplash.com/photo-1645998976611-2c1985ca1a63?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
//   height: double.infinity,
//   width: double.infinity,
//   fit: BoxFit.cover,)
