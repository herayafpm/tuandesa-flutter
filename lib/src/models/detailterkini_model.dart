import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/utils/static_data.dart';

class DetailTerkiniModel extends Equatable {
  final String likes;
  final bool like;
  DetailTerkiniModel({required this.likes, required this.like});
  factory DetailTerkiniModel.create(Map<String, dynamic> data) {
    return DetailTerkiniModel(
        likes: data['totalLike'].toString(), like: data['me']);
  }
  static Future<DetailTerkiniModel> getData(id) async {
    return TokenModel.getToken().then((val) async {
      if (val.isNotEmpty) {
        try {
          String url = StaticData.url + "/api/berita/$id";
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
          DetailTerkiniModel detailTerkiniModel =
              DetailTerkiniModel.create(jsonObject['data'][0]);
          return detailTerkiniModel;
        } on TimeoutException catch (_) {
          DetailTerkiniModel detailTerkiniModel =
              DetailTerkiniModel(likes: "0", like: false);
          return detailTerkiniModel;
        } on SocketException catch (_) {
          DetailTerkiniModel detailTerkiniModel =
              DetailTerkiniModel(likes: "0", like: false);
          return detailTerkiniModel;
        }
      }
      return Future.error("Not Found");
    });
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
