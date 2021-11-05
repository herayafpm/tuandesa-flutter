import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuandesa/src/models/response_model.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/utils/custom_exception.dart';
import 'package:tuandesa/src/utils/static_data.dart';
import 'dart:async';

class CommentModel extends Equatable {
  final String id, name, komentar, createdAt, user_id;
  CommentModel(
      {required this.id,
      required this.name,
      required this.user_id,
      required this.komentar,
      required this.createdAt});
  factory CommentModel.create(Map<String, dynamic> data) {
    return CommentModel(
        id: data['id'].toString(),
        user_id: data['user_id'].toString(),
        name: data['user']['name'],
        komentar: data['komentar'],
        createdAt: data['created_at']);
  }
  static Future<List<CommentModel>> getData(
      String id, int limit, int start) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url +
            "/api/aduan/${id}/comment?limit=${limit}&start=${start}";
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
        List<dynamic> lisComment = (jsonObject as Map<String, dynamic>)['data'];
        List<CommentModel> comments = [];
        for (int i = 0; i < lisComment.length; i++) {
          comments.add(CommentModel.create(lisComment[i]));
        }
        return comments;
      } on TimeoutException catch (_) {
        List<CommentModel> aduan = [];
        return aduan;
      } on SocketException catch (_) {
        List<CommentModel> aduan = [];
        return aduan;
      }
    });
  }

  static Future<ResponseModel> aduanComment(String id, String komentar) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/aduan/$id/comment";
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        Map data = {'komentar': komentar};
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

  static Future<ResponseModel> deleteComment(String id) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/aduan/comment/$id";
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
