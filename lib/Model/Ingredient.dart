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
        recipe!.add(Recipe.fromJson(v));
      });
    }
    serving_size = json['serving_size'];
    source = json['source'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['dish_id'] = dish_id;
    data['foodName'] = foodName;
    data['hasRecipe'] = hasRecipe;
    data['imageId'] = imageId;
    data['is_combo'] = is_combo;
    if (recipe != null) {
      data['recipe'] = recipe!.map((v) => v.toJson()).toList();
    }
    data['serving_size'] = serving_size;
    data['source'] = source;
    return data;
  }

  @override
  String toString() {
    return 'FoodFamily: {imageId: $imageId, Food Name: $foodName, hasRecipe: $hasRecipe}';
  }
}
