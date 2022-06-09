import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  var ingredients;

  DetailPage(this.ingredients, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(ingredients["foodName"],
            style: const TextStyle(color: Color(0xff909090))),
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
      body: SizedBox(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(3.0, 10.0, 3.0, 3.0),
                child: Container(
                    width: MediaQuery.of(context).size.width - 70,
                    height: MediaQuery.of(context).size.height - 500,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      image: DecorationImage(
                        image: NetworkImage(ingredients["url"]),
                        fit: BoxFit.cover,
                      ),
                    ))),
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: ingredients["recipe"].length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        ingredients["recipe"][index]["name"],
                      ),
                      subtitle: Text(
                          'Quantity ${ingredients["recipe"][index]["weight"]}g'),
                      trailing: Text(
                          'Carbs ${ingredients["recipe"][index]["carbs"]}g'),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
