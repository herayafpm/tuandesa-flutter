import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenModel extends Equatable {
  static Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token") ?? "";
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
