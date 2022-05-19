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
                      // width: 100,
                      // height: 100,
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

class CustomListItemTwo extends StatelessWidget {
  const CustomListItemTwo({
    Key? key,
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
    required this.readDuration,
  }) : super(key: key);

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: thumbnail,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                child: _ArticleDescription(
                  title: title,
                  subtitle: subtitle,
                  author: author,
                  publishDate: publishDate,
                  readDuration: readDuration,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ArticleDescription extends StatelessWidget {
  const _ArticleDescription({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.author,
    required this.publishDate,
    required this.readDuration,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                author,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black87,
                ),
              ),
              Text(
                '$publishDate - $readDuration',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
