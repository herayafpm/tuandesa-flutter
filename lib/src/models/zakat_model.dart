import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/response_model.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/custom_exception.dart';
import 'package:tuandesa/src/utils/static_data.dart';

class ZakatModel extends Equatable {
  String id, judul;
  ZakatModel({required this.id, required this.judul});
  factory ZakatModel.createProfileDesa(Map<String, dynamic> data) {
    return ZakatModel(id: data['id'].toString(), judul: data['name']);
  }

  static Future<List<ZakatModel>> getZakats(context) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/zakat";
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
        List<dynamic> listZakat = (jsonObject as Map<String, dynamic>)['data'];
        List<ZakatModel> zakat = [];
        for (int i = 0; i < listZakat.length; i++) {
          zakat.add(ZakatModel.createProfileDesa(listZakat[i]));
        }
        return zakat;
      } on TimeoutException catch (e) {
        ShowAlert.show(context, "Gagal", e.toString());
      } on SocketException catch (e) {
        ShowAlert.show(context, "Gagal", e.toString());
      }
      return Future.error("Not Found");
    });
  }

  static Future<ResponseModel> postAmilZakat(
      String zakat, String beras, String uang, String dusun) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/zakat/" + zakat;
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        Map data = {'beras': beras, 'uang': uang, 'dusun': dusun};
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

  @override
  // TODO: implement props
  List<Object> get props => [];
}
