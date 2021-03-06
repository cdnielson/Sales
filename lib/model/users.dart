library users;
// include Polymer to have access to @observable
import 'package:polymer/polymer.dart';

class User extends Object with Observable{
  final String username;
  final List pin;
  final String email;

  User(String this.username, List this.pin, String this.email);

  User.fromMap(Map<String, Object> map) : this(map["username"], map["pin"], map["email"]);

  @override String toString() => "$username";

}


