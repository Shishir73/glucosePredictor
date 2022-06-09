import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/Model/DraftImage.dart';
import 'package:glucose_predictor/View/Home/draftPage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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

  @override
  Widget build(BuildContext context) {
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
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.black,
                ),
                tooltip: 'pick date',
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2018, 03, 5),
                      maxTime: DateTime(2026, 06, 7), onChanged: (date) {
                        print('change $date');
                        setState(() {
                          pickeddate = "${date.day}";
                        });
                      }, onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          pickeddate = "${date.day}/${date.month}/${date.year}";
                          _buildDateView();
                        });
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
              ),
            ),
          ]),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (pickeddate != null) Expanded(child: _buildDateView()),
              const SizedBox(width: 20, height: 45),
              if (pickeddate == null) Expanded(child: _buildFireView()),
              const SizedBox(width: 20, height: 45),
            ]),
      ),
    );
  }

  Widget _buildFireView() {
    final Stream<QuerySnapshot> fireData =
        FirebaseFirestore.instance.collection("apiIngredients").snapshots();
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            width: 300,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
                stream: fireData,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return const Text("ERROR call for help!!");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Wait a minute, loading brother...");
                  }
                  final offData = snapshot.requireData;
                  return ListView.builder(
                    itemCount: offData.size,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: Image.network(
                          "${offData.docs[index]["url"]}",
                          width: 120,
                        ),
                        title: Text("${offData.docs[index]["foodName"]}"),
                        subtitle: Text("${offData.docs[index]["dateTime"]}"),
                        onTap: () {
                          var index1 = offData.docs[index];
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPage(index1)));
                        },
                      );
                    },
                  );
                })));
  }

  Widget _buildDateView() {
    final Stream<QuerySnapshot> fireData = FirebaseFirestore.instance
        .collection("apiIngredients")
        .where('createdDate', isEqualTo: pickeddate.toString())
        .snapshots();
    print(fireData);
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            width: 300,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: StreamBuilder<QuerySnapshot>(
                stream: fireData,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return const Text("ERROR call for help!!");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Wait a minute, loading brother...");
                  }
                  final offData = snapshot.requireData;
                  return ListView.builder(
                    itemCount: offData.size,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          leading: Image.network(
                            "${offData.docs[index]["url"]}",
                            width: 120,
                          ),
                          title: Text("${offData.docs[index]["foodName"]}"),
                          subtitle:
                              Text("${offData.docs[index]["dateTime"]}"),
                          onTap: () {
                            var index1 = offData.docs[index];
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailPage(index1)));
                          });
                    },
                  );
                })));
  }
}
