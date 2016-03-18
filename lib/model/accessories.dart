library accessories;
import 'package:polymer/polymer.dart';

// include Polymer to have access to @observable

class Accessory extends Object with Observable{
  final String category;
  final String SKU;
  final String finish;
  final int price;
  final String image;
  final String tier;
  final int id;

  Accessory(String this.category, String this.SKU, String this.finish, int this.price, String this.image, String this.tier, int this.id);

  Accessory.fromMap(Map<String, Object> map) : this(map["category"], map["SKU"], map["finish"], map["price"], map["image"], map["tier"], map["id"]);

  @override String toString() => "$SKU";

  @observable bool cleared = false;
  @observable String added = "Add to Order";
  @observable String icon = "add";



}


