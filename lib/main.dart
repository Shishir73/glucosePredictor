import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/pages/homePage.dart';
import 'package:glucose_predictor/pages/settingsPage.dart';
import 'package:glucose_predictor/pages/takeImgPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'Predict Glucose'),
    );
  }
}


class _MyHomePageState extends State<MyHomePage> {
  int index = 1;

  final screens = [
    HomePage(),
    TakeImgPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final itemList = <Widget>[
      const Icon(Icons.home, size: 30,),
      const Icon(Icons.add_circle_outline, size: 30,),
      const Icon(Icons.settings, size: 30,),
    ];

    return Container(
        color: Colors.red,
        child:SafeArea(
            top: false,
            child: Scaffold(
              extendBody: true,
              backgroundColor: Colors.red,
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: screens[index],
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: const IconThemeData(color: Colors.black),
                ), child: CurvedNavigationBar(
                color: Color(0Xffe6ffe5),
                buttonBackgroundColor: Colors.green,
                backgroundColor: Colors.transparent,
                height: 50,
                items: itemList,
                index: index,
                animationDuration: const Duration(milliseconds: 300),
                onTap: (index) => setState(() {
                  this.index = index;
                }),
              ),),)
        ));
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
