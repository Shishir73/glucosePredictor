class Recipe {
  int? id;
  String? name;
  double? weight;
  double? carbs;

  Recipe({this.id, this.name, this.weight, this.carbs});

  Recipe.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    weight = json['weight'];
    carbs = json['carbs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['weight'] = weight;
    data['carbs'] = carbs;
    return data;
  }

  @override
  String toString() {
    return 'Recipe: {Food Name: $name, Weight: $weight, Carbohydrates: $carbs}';
  }
}
