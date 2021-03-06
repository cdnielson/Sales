library rings;
import 'package:polymer/polymer.dart';

// include Polymer to have access to @observable

class Ring extends Object with Observable{
  List category;
  final String SKU;
  final String finish;
  num price;
  final String image;
  int tier;
  int id;
  final String combo;
  final String combo2;


  Ring(List this.category, String this.SKU, String this.finish, String _price, String this.image, String _tier, String _id, String this.combo, String this.combo2)
  {
    this.price = num.parse(_price);
    this.tier = int.parse(_tier);
    this.id = int.parse(_id);

  }

  Ring.fromMap(Map<String, Object> map) : this(map["category"], map["SKU"], map["finish"], map["price"], map["image"], map["tier"], map["id"], map["combo"], map["combo2"]);

  @override String toString() => "$SKU";

  @observable bool cleared = false;
  @observable String added = "Remove";
  @observable String icon = "clear";
  @observable String notes;
}


