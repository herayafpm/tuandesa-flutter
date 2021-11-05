import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/static_data.dart';

class AmilModel {
  // ignore: non_constant_identifier_names
  String id, user_id, beras, uang, dusun;
  AmilModel(
      {required this.id,
      // ignore: non_constant_identifier_names
      required this.user_id,
      required this.beras,
      required this.uang,
      required this.dusun});
  factory AmilModel.create(Map<String, dynamic> data) {
    return AmilModel(
        id: data['id'].toString(),
        user_id: data['user_id'].toString(),
        beras: data['beras'].toString(),
        uang: data['uang'].toString(),
        dusun: data['dusun'].toString());
  }
  static Future<AmilModel> getAmil(id, context) async {
    return TokenModel.getToken().then((val) async {
      if (val.isNotEmpty) {
        try {
          String url = StaticData.url + "/api/zakat/" + id;
          HttpClient client = new HttpClient();
          client.badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true);
          HttpClientRequest request = await client.getUrl(Uri.parse(url));
          request.headers.set("Authorization", "Bearer " + val.split('\"')[1]);
          HttpClientResponse response =
              await request.close().timeout(const Duration(seconds: 15));
          ;
          String reply = await response.transform(utf8.decoder).join();
          var jsonObject = json.decode(reply);
          AmilModel amil;
          if (jsonObject['status']) {
            amil = AmilModel.create(jsonObject['data']['data']);
          } else {
            var data = {
              'id': "",
              'user_id': "",
              'beras': "0.0",
              'uang': "0.0",
              'dusun': ""
            };
            amil = AmilModel.create(data);
          }
          return amil;
        } on TimeoutException catch (e) {
          ShowAlert.show(context, "Gagal", e.toString());
        } on SocketException catch (e) {
          ShowAlert.show(context, "Gagal", e.toString());
        }
      }
      return Future.error("Not Found");
    });
  }
}
