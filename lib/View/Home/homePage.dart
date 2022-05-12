import 'package:flutter/material.dart';
import 'package:glucose_predictor/Model/DraftImage.dart';
import 'package:hive_flutter/adapters.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Overview", style: TextStyle(color: Color(0xff909090))),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: _buildListView()),
            const SizedBox(width: 20, height: 45),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ValueListenableBuilder(
        valueListenable: Hive.box<DraftImage>('DraftImage').listenable(),
        builder: (context, Box<DraftImage> dradtImgBox, _) {
          return ListView.builder(
              itemCount: dradtImgBox.length,
              reverse: true,
              itemBuilder: (context, index) {
                final draftBox = dradtImgBox.getAt(index) as DraftImage;
                return ListTile(
                  leading: Image.memory(draftBox.image!),
                  title: Text(draftBox.fileName ?? ''),
                    subtitle: const Text("Quick Saved", style: TextStyle(color: Colors.blueGrey)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  visualDensity: const VisualDensity(horizontal: 0, vertical: 4),
                  trailing: SizedBox(
                    width: 50,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              dradtImgBox.deleteAt(index);
                            },
                            icon: const Icon(Icons.delete_forever_rounded))
                      ],
                    ),
                  ),
                );
              });
        });
  }
}