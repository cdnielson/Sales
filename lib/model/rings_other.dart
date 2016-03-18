library rings_other;
import 'package:polymer/polymer.dart';

// include Polymer to have access to @observable

class Person extends Observable {
  @observable bool cleared = false;
  @observable String added = "Remove from Order";
  @observable String icon = "clear";
  // mandatory field
  @observable int index;
  // mandatory field
  @observable bool selected;
  //model

  final int id;
  final String category;
  final String SKU;
  final String finish;
  final int price;
  final int tier;
  final String image;


  Person(this.id, this.category, this.SKU, this.finish, this.price, this.tier, this.image);
  Person.fromMap(Map<String, Object> map) : this(map["id"], map["category"], map["SKU"], map["finish"], map["price"], map["tier"], map["image"]);

  @override String toString() => "$SKU";
}

