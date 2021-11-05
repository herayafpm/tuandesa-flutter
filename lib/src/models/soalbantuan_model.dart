import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/static_data.dart';

import 'jawaban_model.dart';

class SoalBantuanModel extends Equatable {
  String id, soal;
  List<JawabanModel> jawaban;
  SoalBantuanModel(
      {required this.id, required this.soal, required this.jawaban});
  factory SoalBantuanModel.createProfileDesa(Map<String, dynamic> data) {
    List<JawabanModel> jawaban = [];
    for (int i = 0; i < data['jawabans'].length; i++) {
      jawaban.add(JawabanModel.createJawaban(data['jawabans'][i]));
    }
    return SoalBantuanModel(
        id: data['id'].toString(), soal: data['soal'], jawaban: jawaban);
  }

  static Future<List<SoalBantuanModel>> getSoalBantuans(
      String id, context) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/bantuan/soaljawaban/$id";
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
        List<dynamic> listSoalBantuan =
            (jsonObject as Map<String, dynamic>)['data'];
        List<SoalBantuanModel> soalBantuan = [];
        for (int i = 0; i < listSoalBantuan.length; i++) {
          soalBantuan
              .add(SoalBantuanModel.createProfileDesa(listSoalBantuan[i]));
        }
        return soalBantuan;
      } on TimeoutException catch (e) {
        ShowAlert.show(context, "Gagal", e.toString());
      } on SocketException catch (e) {
        ShowAlert.show(context, "Gagal", e.toString());
      }
      return Future.error("Not Found");
    });
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
