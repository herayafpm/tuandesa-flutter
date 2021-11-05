import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/response_model.dart';
import 'package:tuandesa/src/utils/custom_exception.dart';
import 'package:tuandesa/src/utils/static_data.dart';

abstract class AuthModel extends Equatable {
  static Future<ResponseModel> login(String nik, String password) async {
    try {
      String url = StaticData.url + "/api/auth/login";
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      Map data = {
        "username": nik,
        "password": password,
      };
      var body = utf8.encode(json.encode(data));
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.headers.contentLength = body.length;
      request.add(body);
      HttpClientResponse response =
          await request.close().timeout(const Duration(seconds: 15));
      String reply = await response.transform(utf8.decoder).join();
      var jsonObject = json.decode(reply);
      return ResponseModel.fromJson(jsonObject);
    } on TimeoutException catch (_) {
      var jsonObject =
          CustomException.data("Koneksi gagal silahkan coba kembali");
      return ResponseModel.fromJson(jsonObject);
    } on SocketException catch (_) {
      var jsonObject =
          CustomException.data("Koneksi gagal silahkan coba kembali");
      return ResponseModel.fromJson(jsonObject);
    }
  }

  static Future<ResponseModel> lupa(String nik) async {
    try {
      String url = StaticData.url + "/api/auth/lupa";
      HttpClient client = new HttpClient();
      client.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      Map data = {
        "username": nik,
      };
      var body = utf8.encode(json.encode(data));
      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.contentType =
          new ContentType("application", "json", charset: "utf-8");
      request.headers.contentLength = body.length;
      request.add(body);
      HttpClientResponse response =
          await request.close().timeout(const Duration(seconds: 15));
      String reply = await response.transform(utf8.decoder).join();
      var jsonObject = json.decode(reply);
      return ResponseModel.fromJson(jsonObject);
    } on TimeoutException catch (_) {
      var jsonObject =
          CustomException.data("Koneksi gagal silahkan coba kembali");
      return ResponseModel.fromJson(jsonObject);
    } on SocketException catch (_) {
      var jsonObject =
          CustomException.data("Koneksi gagal silahkan coba kembali");
      return ResponseModel.fromJson(jsonObject);
    }
  }

  @override
  List<Object> get props => [];
}
