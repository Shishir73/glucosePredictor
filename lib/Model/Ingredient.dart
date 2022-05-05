import 'package:glucose_predictor/Model/Recipe.dart';

class Ingredient {
  int? dish_id;
  String? foodName;
  bool? hasRecipe;
  int? imageId;
  bool? is_combo;
  List<Recipe>? recipe;
  double? serving_size;
  String? source;

  Ingredient(
      {this.dish_id,
        this.foodName,
        this.hasRecipe,
        this.imageId,
        this.is_combo,
        this.recipe,
        this.serving_size,
        this.source});

  Ingredient.fromJson(Map<String, dynamic> json) {
    dish_id = json['dish_id'];
    foodName = json['foodName'];
    hasRecipe = json['hasRecipe'];
    imageId = json['imageId'];
    is_combo = json['is_combo'];
    if (json['recipe'] != null) {
      recipe = <Recipe>[];
      json['recipe'].forEach((v) {
        recipe!.add(new Recipe.fromJson(v));
      });
    }
    serving_size = json['serving_size'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dish_id'] = this.dish_id;
    data['foodName'] = this.foodName;
    data['hasRecipe'] = this.hasRecipe;
    data['imageId'] = this.imageId;
    data['is_combo'] = this.is_combo;
    if (this.recipe != null) {
      data['recipe'] = this.recipe!.map((v) => v.toJson()).toList();
    }
    data['serving_size'] = this.serving_size;
    data['source'] = this.source;
    return data;
  }

  @override
  String toString() {
    return 'FoodFamily: {imageId: $imageId, Food Name: $foodName, hasRecipe: $hasRecipe}';
  }
}
