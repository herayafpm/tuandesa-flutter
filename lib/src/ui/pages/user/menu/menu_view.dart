import 'package:flutter/material.dart';
import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/user/menu/menu_aduan_view.dart';
import 'package:tuandesa/src/ui/pages/user/menu/menu_bantuan_view.dart';
import 'package:tuandesa/src/ui/pages/user/menu/menu_berita_view.dart';
import 'package:tuandesa/src/ui/pages/user/menu/menu_pelayanan_view.dart';
import 'package:tuandesa/src/ui/pages/user/menu/menu_profile_desa_view.dart';
import 'package:tuandesa/src/ui/pages/user/menu/menu_zakat_view.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_authorization.dart';
import 'package:tuandesa/src/utils/static_data.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuView extends StatefulWidget {
  MenuView() : super();

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomStyle.bgColor,
      appBar: AppBar(
        backgroundColor: CustomStyle.headerColor,
        title: Text(
          "Menu",
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: CustomStyle.bgColor,
          padding: EdgeInsets.only(top: 30),
          child: FutureBuilder(
            future: ProfileModel.getProfileFromSh(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                ProfileModel profileModel = snapshot.data;
                return Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: menuButton(
                                context,
                                MenuAduanView(),
                                "images/aduan.png",
                                "Aduan Masyarakat",
                                cekIsNotAdmin(profileModel.type))),
                        Expanded(
                            child: menuButton(
                                context,
                                MenuBantuanView(),
                                "images/bantuan.png",
                                "Bantuan Sosial",
                                cekIsNotAdmin(profileModel.type))),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: menuButton(
                                context,
                                MenuPelayananView(),
                                "images/pelayanan.png",
                                "Layanan Masyarakat",
                                cekIsNotAdmin(profileModel.type))),
                        Expanded(
                            child: menuButton(
                                context,
                                MenuProfileDesaView(),
                                "images/seputardesa.png",
                                "Seputar Desa",
                                true)),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: menuButton(
                                context,
                                'url',
                                "images/website.png",
                                "Website Desa",
                                cekIsNotAdmin(profileModel.type))),
                        FutureBuilder(
                          future: ProfileModel.getProfileFromSh(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (CekAuthorization.isAmil(profileModel.type)) {
                                return Expanded(
                                    child: menuButton(
                                        context,
                                        MenuZakatView(),
                                        "images/zakat.png",
                                        "Zakat Desa",
                                        cekIsNotAdmin(profileModel.type)));
                              } else if (CekAuthorization.isAdminOrAduan(
                                  profileModel.type)) {
                                return Expanded(
                                    child: menuButton(
                                        context,
                                        MenuBeritaView(),
                                        "images/aduan.png",
                                        "Berita Masyarakat",
                                        true));
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Container(
                    child: Center(
                        child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                )));
              }
            },
          ),
        ),
      ),
    );
  }
}

cekIsNotAdmin(type) {
  return CekAuthorization.isNotAdmin(type);
}

_launchURL(url) async {
  await launch(url);
}

Widget menuButton(
    BuildContext context, route, String images, String text, bool isNotAdmin) {
  return FlatButton(
    onPressed: () {
      if (route == 'url') {
        _launchURL(StaticData.url);
      } else {
        if (isNotAdmin) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => route));
        } else {
          ShowAlert.show(context, "Status",
              "Tidak bisa masuk karena anda bukan Amil maupun penduduk");
        }
      }
    },
    child: Container(
      width: 140,
      height: 170,
      child: Column(
        children: <Widget>[
          Image.asset(
            images,
            width: 117,
            height: 117,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
