import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/response_model.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/utils/custom_exception.dart';
import 'package:tuandesa/src/utils/static_data.dart';
import 'package:http/http.dart' as http;

class BeritaModel extends Equatable {
  final String id, name, komentar, jenis, createdAt, userId;
  final List<String> lampiran;
  final bool status;
  BeritaModel(
      {required this.id,
      required this.name,
      required this.userId,
      required this.komentar,
      required this.jenis,
      required this.createdAt,
      required this.lampiran,
      required this.status});
  factory BeritaModel.create(Map<String, dynamic> data) {
    List<String> dataLampiran = [];
    var lampiran = data['berita_images'];
    for (var i = 0; i < lampiran.length; i++) {
      dataLampiran.add(StaticData.url + "/${lampiran[i]['path']}");
    }
    return BeritaModel(
        id: data['id'].toString(),
        userId: data['user_id'].toString(),
        name: data['user']['name'],
        komentar: data['komentar'],
        createdAt: data['created_at'],
        jenis: data['jenisberita']['name'],
        status: data['status'] == 1,
        lampiran: dataLampiran);
  }

  static Future<List<BeritaModel>> getData(int limit, int start) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url =
            StaticData.url + "/api/berita?limit=${limit}&start=${start}";
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
        List<dynamic> listBerita = (jsonObject as Map<String, dynamic>)['data'];
        List<BeritaModel> berita = [];
        for (int i = 0; i < listBerita.length; i++) {
          berita.add(BeritaModel.create(listBerita[i]));
        }
        return berita;
      } on TimeoutException catch (e) {
        List<BeritaModel> berita = [];
        return berita;
      } on SocketException catch (e) {
        List<BeritaModel> berita = [];
        return berita;
      }
    });
  }

  static Future<ResponseModel> postBerita(int jenis_kategori_id,
      String komentar, List<String> lampiran, String status) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/berita";
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        Map data = {
          'jenis_berita': jenis_kategori_id,
          'komentar': komentar,
          'lampiran': lampiran,
          'status': status,
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

  static Future<ResponseModel> beritaLike(String id, bool like) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/berita/$id/like";
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        HttpClientRequest request = await client.postUrl(Uri.parse(url));
        request.headers.set("Authorization", "Bearer " + val.split('\"')[1]);
        request.headers.contentType =
            new ContentType("application", "json", charset: "utf-8");
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

  static Future<ResponseModel> beritaDelete(String id) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/berita/$id";
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
