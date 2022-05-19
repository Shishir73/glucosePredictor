
class ManualInput {
  late String foodName;
  late List<Ing> items;

  ManualInput(this.foodName, this.items);

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};

    data['foodName'] = foodName;
    data['Ingredients'] = items.toString();

    return data;
  }
}

class Ing {
  late String ingName;
  late int quantity;

  Ing(this.ingName, this.quantity);

  @override
  String toString() {
    return ("{IngName: "+ ingName + ", Quantity: $quantity}");
  }
}