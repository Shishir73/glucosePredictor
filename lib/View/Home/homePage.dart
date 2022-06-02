//import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/Controller/firebaseService.dart';
import 'package:glucose_predictor/Model/DraftImage.dart';
//import 'package:glucose_predictor/Model/food_notifier.dart';
import 'package:glucose_predictor/View/Home/draftPage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:glucose_predictor/main.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:glucose_predictor/View/Home/detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder(
      future: Hive.openBox<DraftImage>("DraftImage"),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const HomeTimelineView();
          }
        } else {
          return const Scaffold();
        }
      },
    ));
  }
}

class HomeTimelineView extends StatefulWidget {
  const HomeTimelineView({Key? key}) : super(key: key);

  @override
  State<HomeTimelineView> createState() => _HomeTimelineView();
}

class _HomeTimelineView extends State<HomeTimelineView> {
  var pickeddate;

  // late String formattedDate="";
  /*@override
  void initState() {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);
    getFoods(foodNotifier);
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    var foodNotifier;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text("Overview",
              style: TextStyle(color: Color(0xff909090))),
          centerTitle: true,
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.watch_later_outlined,
                color: Colors.black,
              ),
              tooltip: 'Quick Saved Meal',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DraftPageView()));
              },
            ),
          ]),
      /*  body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            var foodNotifier;
            return ListTile(
                title: Text(foodNotifier.foodList[index].foodName),
                subtitle: Text(foodNotifier.foodList[index].createdDatetime)
            );
          },
          itemCount: foodNotifier.foodList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
        ));
  }
}*/
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Expanded(child: _buildDate(context)),
              //const SizedBox(width: 20, height: 45),
              Expanded(child: _buildFireView()),
              const SizedBox(width: 20, height: 45),
            ]
        ),
      ),
    );
  }

  Widget _buildDate(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 25,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2018, 03, 5),
                      maxTime: DateTime(2026, 06, 7),
                      onChanged: (date) {
                        print('change $date');
                        setState(() {
                          pickeddate = "${date.day}";
                        });
                      },
                      onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          pickeddate =
                          "${date.day}/${date.month}/${date.year}";
                        });
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en);
                },
                label: Text("Set Date"),
                icon: Icon(Icons.date_range),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: (pickeddate == null)
                    ? Text("Select a date Please")
                    : Text("$pickeddate"),
              ),
            ],
          ),
        ));
  }

  Widget _buildFireView() {
    print(pickeddate.toString());
    /*final Stream<QuerySnapshot> fireData =
    FirebaseFirestore.instance.collection("apiIngredients").where(
        'createdTime', isEqualTo:
    pickeddate.toString()).snapshots();*/
    final Stream<QuerySnapshot> fireData =
    FirebaseFirestore.instance.collection("apiIngredients").snapshots();
    /*navigateToDetail(DocumentSnapshot post) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(post:post,)));
    }*/
    return Align(
      alignment:Alignment.topLeft,
      child:Container(
        width: 300,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: StreamBuilder<QuerySnapshot>(
            stream: fireData,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,) {
              if (snapshot.hasError) {
                return const Text("ERROR call for help!!");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Wait a minute, loading brother...");
              }
              final offData = snapshot.requireData;
              return ListView.separated(
               // itemCount: offData.size,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading:Image.network("${offData.docs[index]["url"]}",
                    width:120,
                    //fit:BoxFit.fitWidth,
                    ),
                    title: Text("${offData.docs[index]["foodName"]}"),
                   // subtitle: Text("${offData.docs[index]["createdDatetime"]}"),
                    //onTap:()=>navigateToDetail(offData.docs[index]),
                    onTap:(){
                       var index1=offData.docs[index];
                      Navigator.push(
                        context,
                      MaterialPageRoute(builder: (context)=>DetailPage(index1)));
                    }
                  );
                },
                  itemCount: offData.size,
                separatorBuilder: (BuildContext context, int index){
                  return Divider(
                    color:Colors.black,
                  );
                }
              );
            })));
  }
}



