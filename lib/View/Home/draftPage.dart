import 'package:flutter/material.dart';
import 'package:glucose_predictor/Model/DraftImage.dart';
import 'package:hive_flutter/adapters.dart';

class DraftPageView extends StatefulWidget {
  const DraftPageView({Key? key}) : super(key: key);

  @override
  State<DraftPageView> createState() => _DraftPageView();
}

class _DraftPageView extends State<DraftPageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Quick Saved",
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
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: _buildDraftView()),
            const SizedBox(width: 20, height: 45),
          ],
        ),
      ),
    );
  }
}

Widget _buildDraftView() {
  return ValueListenableBuilder(
      valueListenable: Hive.box<DraftImage>('DraftImage').listenable(),
      builder: (context, Box<DraftImage> dradtImgBox, _) {
        return ListView.builder(
            itemCount: dradtImgBox.length,
            reverse: true,
            itemBuilder: (context, index) {
              final draftBox = dradtImgBox.getAt(index) as DraftImage;
              return ListTile(
                leading: Image.memory(
                  draftBox.image!,
                ),
                title: Text(draftBox.fileName ?? ''),
                subtitle: const Text("Quick Saved",
                    style: TextStyle(color: Colors.blueGrey)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
