import 'dart:async';
import 'dart:convert';
import 'package:tuandesa/src/models/response_model.dart';
import 'dart:io';

import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/utils/custom_exception.dart';
import 'package:tuandesa/src/utils/static_data.dart';

class PelayananModel {
  static Future<ResponseModel> postPelayanan(
      int jenis_kategori_id, String komentar, List<String> lampiran) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/pelayanan";
        HttpClient client = new HttpClient();
        client.badCertificateCallback =
            ((X509Certificate cert, String host, int port) => true);
        Map data = {
          'jenis_pelayanan': jenis_kategori_id,
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
}
