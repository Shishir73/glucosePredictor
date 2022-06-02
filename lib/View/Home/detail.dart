import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:glucose_predictor/View/Home/homePage.dart';
import 'package:glucose_predictor/Model/FireBaseIngredients.dart';
class DetailPage extends StatelessWidget{
  var index1;
  DetailPage(this.index1);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:AppBar(
        title:Text(index1["foodName"]),
      ),
      body: Center(
        child:Container(
          width:200,
          height:double.infinity,
          child:Column(
            children:<Widget>[
              Image.network(index1["url"]),
            SizedBox(height:32,width:200
            ),
              Text(index1["foodName"],
              style:TextStyle(fontSize:30,
              ),
              ),
               //Text(index1["recipe"].tiList()),
               /* GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 3,
                    crossAxisSpacing:4,
                  mainAxisSpacing:4,
                  children: index1["recipe"].map((v) => v.toJson()).toList(),
             )*/
            ],
          )
        ),
      ),
    );
  }
}
/*class FoodDetail extends StatefulWidget {
   final DocumentSnapshot post;
  FoodDetail({required this.post});
  @override
    _FoodDetailState createState() => _FoodDetailState();
  
  }

class _FoodDetailState extends State<FoodDetail>{
  @override
  Widget build(BuildContext context){
    var post;
    return Container(
     child: Card(
       child: ListTile(
         title:Text(Widget.post.offData["foodName"]),

       )
     )
    );

  }

}*/