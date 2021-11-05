import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/static_data.dart';

class ProfileDesaModel extends Equatable {
  final int id;
  final String judul;
  final String description;
  final List<String> lampiran;

  ProfileDesaModel(
      {required this.id,
      required this.judul,
      required this.description,
      required this.lampiran});

  factory ProfileDesaModel.createProfileDesa(Map<String, dynamic> data) {
    List<String> dataLampiran = [];
    for (int i = 0; i < data['profile_desa_images'].length; i++) {
      dataLampiran.add(
          (StaticData.url + "/${data['profile_desa_images'][i]['path']}")
              .toString());
    }
    return ProfileDesaModel(
        id: data['id'],
        judul: data['judul'],
        description: data['description'],
        lampiran: dataLampiran);
  }
  static Future<List<ProfileDesaModel>> getData(context) async {
    return TokenModel.getToken().then((val) async {
      try {
        String url = StaticData.url + "/api/profiledesa";
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
        List<dynamic> listProfileDesa =
            (jsonObject as Map<String, dynamic>)['data'];
        List<ProfileDesaModel> profileDesas = [];
        for (int i = 0; i < listProfileDesa.length; i++) {
          profileDesas
              .add(ProfileDesaModel.createProfileDesa(listProfileDesa[i]));
        }
        return profileDesas;
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
