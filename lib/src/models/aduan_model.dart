import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/response_model.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/utils/custom_exception.dart';
import 'package:tuandesa/src/utils/static_data.dart';
import 'package:http/http.dart' as http;

class AduanModel extends Equatable {
  final String id, name, komentar, jenis, createdAt;
  final int userId;
  final List<String> lampiran;
  final bool status;
  AduanModel(
      {required this.id,
      required this.name,
      required this.komentar,
      required this.jenis,
      required this.createdAt,
      required this.lampiran,
      required this.status,
      required this.userId});
  factory AduanModel.create(Map<String, dynamic> data) {
    List<String> dataLampiran = [];
    var lampiran = data['aduan_images'];
    for (var i = 0; i < lampiran.length; i++) {
      dataLampiran.add(StaticData.url + "/${lampiran[i]['path']}");
    }
    // if (data['aduan_images'].contains(';')) {

    // } else {
    //   dataLampiran
    //       .add(StaticData.url + "/assets/uploads/aduan/${data['lampiran']}");
    // }
    return AduanModel(
        id: data['id'].toString(),
        name: data['user']['name'],
        userId: data['user_id'],
        komentar: data['komentar'],
        createdAt: data['created_at'],
        jenis: data['jenisaduan']['name'],
        status: data['status'] == 1,
        lampiran: dataLampiran);
  }

  static Future<List<AduanModel>> getData(int limit, int start) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url =
            StaticData.url + "/api/aduan?limit=${limit}&start=${start}";
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        HttpClientRequest request = await client.getUrl(Uri.parse(url));
        request.headers.set("Authorization", "Bearer " + val.split('\"')[1]);
        request.headers.contentType =
            new ContentType("application", "json", charset: "utf-8");
        HttpClientResponse response =
            await request.close().timeout(const Duration(seconds: 15));
        String reply = await response.transform(utf8.decoder).join();
        var jsonObject = json.decode(reply);
        List<dynamic> listAduan = (jsonObject as Map<String, dynamic>)['data'];
        List<AduanModel> aduan = [];
        for (int i = 0; i < listAduan.length; i++) {
          aduan.add(AduanModel.create(listAduan[i]));
        }
        return aduan;
      } on TimeoutException catch (e) {
        List<AduanModel> aduan = [];
        return aduan;
      } on SocketException catch (e) {
        List<AduanModel> aduan = [];
        return aduan;
      }
    });
  }

  static Future<ResponseModel> postAduan(
      int jenis_kategori_id, String komentar, List<String> lampiran) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/aduan";
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        Map data = {
          'jenis_aduan': jenis_kategori_id,
          'komentar': komentar,
          'lampiran': lampiran
        };
        var body = utf8.encode(json.encode(data));
        HttpClientRequest request = await client.postUrl(Uri.parse(url));
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

  static Future<ResponseModel> aduanLike(String id, bool like) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/aduan/${id}/like";
        // if (like) {
        //   final request = http.Request("DELETE", Uri.parse(url));
        //   request.headers.addAll(<String, String>{
        //     "Accept": "application/json",
        //     "Authorization": "Bearer " + val.split('\"')[1]
        //   });
        //   final response = await request.send();
        //   var jsonObject = json.decode(await response.stream.bytesToString());
        //   return ResponseModel.fromJson(jsonObject);
        // } else {
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        // Map data = {'id': id};
        // var body = utf8.encode(json.encode(data));
        HttpClientRequest request = await client.postUrl(Uri.parse(url));
        request.headers.set("Authorization", "Bearer " + val.split('\"')[1]);
        request.headers.contentType =
            new ContentType("application", "json", charset: "utf-8");
        // request.headers.contentLength = body.length;
        // request.add(body);
        HttpClientResponse response =
            await request.close().timeout(const Duration(seconds: 15));
        String reply = await response.transform(utf8.decoder).join();
        var jsonObject = json.decode(reply);
        return ResponseModel.fromJson(jsonObject);
        // }
      } on TimeoutException catch (e) {
        var jsonObject = CustomException.data(e.toString());
        return ResponseModel.fromJson(jsonObject);
      } on SocketException catch (e) {
        var jsonObject = CustomException.data(e.toString());
        return ResponseModel.fromJson(jsonObject);
      }
    });
  }

  static Future<ResponseModel> aduanDelete(String id) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/aduan/" + id;
        final request = http.Request("DELETE", Uri.parse(url));
        request.headers.addAll(<String, String>{
          "Accept": "application/json",
          "Authorization": "Bearer " + val.split('\"')[1]
        });
        final response = await request.send();
        var jsonObject = json.decode(await response.stream.bytesToString());
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
  // TODO: implement props
  List<Object> get props => [];
}
