import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:tuandesa/src/models/response_model.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/custom_exception.dart';
import 'package:tuandesa/src/utils/static_data.dart';

class ProfileModel extends Equatable {
  static String url = StaticData.url + "/api/profile";
  final String id, nik, name, alamat, ttl, noHP, email, createdAt;
  final String type;
  ProfileModel(
      {required this.id,
      required this.nik,
      required this.alamat,
      required this.ttl,
      required this.noHP,
      required this.email,
      required this.name,
      required this.createdAt,
      required this.type});
  factory ProfileModel.create(Map<String, dynamic> data) {
    // print(data);
    return ProfileModel(
        id: data['id'].toString(),
        nik: data['username'].toString(),
        name: data['name'],
        createdAt: data['created_at'],
        type: data['type'],
        alamat: data['address'] ?? "",
        ttl: data['ttl'] ?? "",
        noHP: data['no_hp'] ?? "",
        email: data['email']);
  }

  Future getProfile(context) async {
    TokenModel.getToken().then((val) async {
      if (val.isNotEmpty) {
        try {
          HttpClient client = new HttpClient();
          client.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          HttpClientRequest request = await client.getUrl(Uri.parse(url));
          request.headers.set("Authorization", 'Bearer ' + val.split('\"')[1]);
          HttpClientResponse response =
              await request.close().timeout(const Duration(seconds: 15));
          ;
          String reply = await response.transform(utf8.decoder).join();
          var jsonObject = json.decode(reply);
          setProfile(jsonObject['data']);
        } on TimeoutException catch (e) {
          ShowAlert.show(context, "Gagal", e.toString());
        } on SocketException catch (e) {
          ShowAlert.show(context, "Gagal", e.toString());
        }
      }
    });
  }

  static Future<ProfileModel> getProfileFromSh() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      return ProfileModel.create(jsonDecode(pref.getString("profile") ?? ""));
    } catch (e) {
      print(e.toString());
      return ProfileModel(
          alamat: '',
          createdAt: '',
          email: '',
          id: '',
          name: '',
          nik: '',
          noHP: '',
          ttl: '',
          type: '');
    }
  }

  static Future setProfile(Map<String, dynamic> data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("profile", jsonEncode(data));
  }

  static Future<ResponseModel> updateProfile(String alamat, String ttl,
      String noHP, String email, String password, String passwordBaru) async {
    return TokenModel.getToken().then((val) async {
      try {
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        Map data = {
          "address": alamat,
          "ttl": ttl,
          "no_hp": noHP,
          "email": email,
          "password": password,
          "password2": passwordBaru
        };
        var body = utf8.encode(json.encode(data));
        HttpClientRequest request = await client.putUrl(Uri.parse(url));
        request.headers.set("Authorization", "Bearer " + val.split('\"')[1]);
        request.headers.contentType =
            new ContentType("application", "json", charset: "utf-8");
        request.headers.contentLength = body.length;
        request.add(body);
        HttpClientResponse response =
            await request.close().timeout(const Duration(seconds: 15));
        String reply = await response.transform(utf8.decoder).join();
        var jsonObject = json.decode(reply);
        return ResponseModel.fromJson(jsonObject);
      } on TimeoutException catch (e) {
        var jsonObject = CustomException.data(e.toString());
        return ResponseModel.fromJson(jsonObject);
      } on SocketException catch (e) {
        var jsonObject = CustomException.data(e.toString());
        return ResponseModel.fromJson(jsonObject);
      }
    });
  }

  @override
  List<Object> get props => [];
}
