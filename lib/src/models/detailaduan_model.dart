import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:tuandesa/src/models/token_model.dart';
import 'package:tuandesa/src/utils/static_data.dart';

class DetailAduanModel extends Equatable {
  final String comments, likes;
  final bool like;
  DetailAduanModel(
      {required this.comments, required this.likes, required this.like});
  factory DetailAduanModel.create(Map<String, dynamic> data) {
    return DetailAduanModel(
        comments: data['totalComment'].toString(),
        likes: data['totalLike'].toString(),
        like: data['me']);
  }
  static Future<DetailAduanModel> getData(id) async {
    return TokenModel.getToken().then((val) async {
      if (val.isNotEmpty) {
        try {
          String url = StaticData.url + "/api/aduan/$id";
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
          DetailAduanModel detailAduanModel =
              DetailAduanModel.create(jsonObject['data'][0]);
          return detailAduanModel;
        } on TimeoutException catch (_) {
          DetailAduanModel detailAduanModel =
              DetailAduanModel(comments: "0", likes: "0", like: false);
          return detailAduanModel;
        } on SocketException catch (_) {
          DetailAduanModel detailAduanModel =
              DetailAduanModel(comments: "0", likes: "0", like: false);
          return detailAduanModel;
        }
      }
      return Future.error("Not Found");
    });
  }

  @override
  // TODO: implement props
  List<Object> get props => [];
}
