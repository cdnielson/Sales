library swatches;
import 'package:polymer/polymer.dart';

// include Polymer to have access to @observable

class Swatch extends Object with Observable{
  final String name;
  final String url;
  final String type;

  Swatch(String this.name, String this.url, String this.type);

  Swatch.fromMap(Map<String, Object> map) : this(map["name"], map["url"], map['type']);

  @override String toString() => "$name";

  @observable bool added = false;
}


