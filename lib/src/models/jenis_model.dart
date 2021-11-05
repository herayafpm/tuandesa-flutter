import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/response_model.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/utils/custom_exception.dart';
import 'dart:io';

import 'package:tuandesa/src/utils/static_data.dart';

class JenisModel extends Equatable {
  static Future<ResponseModel> getJenis(String kategori) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/${kategori}/jenis";
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
