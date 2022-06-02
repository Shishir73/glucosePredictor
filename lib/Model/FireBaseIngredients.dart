import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseIng {
  int? aUniqueId;
  String? createdDate;
  int? dishId;
  String? foodName;
  bool? hasRecipe;
  int? imageId;
  List<dynamic>? recipe;
  String? source;
  String? url;

  FireBaseIng({this.aUniqueId,
    this.createdDate,
    this.dishId,
    this.foodName,
    this.hasRecipe,
    this.imageId,
    this.recipe,
    this.source,
    this.url});

  factory FireBaseIng.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,) {
    final data = snapshot.data();
    return FireBaseIng(
      aUniqueId: data?['aUniqueId'],
      createdDate: data?['createdDate'],
      dishId: data?['dishId'],
      foodName: data?['foodName'],
      hasRecipe: data?['hasRecipe'],
      recipe: data?['recipe'],
      url: data?['url'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (aUniqueId != null) "aUniqueId": aUniqueId,
      if (createdDate != null) "createdDate": createdDate,
      if (dishId != null) "dishId": dishId,
      if (foodName != null) "foodName": foodName,
      if (hasRecipe != null) "hasRecipe": hasRecipe,
      if (recipe != null) "recipe": recipe,
    };
  }
}