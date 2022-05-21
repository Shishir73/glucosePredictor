import 'package:flutter/material.dart';
import 'package:glucose_predictor/main.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2),
            () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Predict Glucose')));
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff647659),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                Image.asset("assets/glucoselogo.jpg",height: 100,
                  width: 100,),
                const SizedBox(height: 100, width: 1),

                const Text('Glucose Predictor',
                  style: TextStyle(fontSize:20),
                ),
              ],
            )
        )
    );
  }
}


