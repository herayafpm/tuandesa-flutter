import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/auth/login.dart';

class ProfileLayout extends StatefulWidget {
  final Widget body;
  final String title;
  ProfileLayout({required this.body, required this.title});
  @override
  _ProfileLayoutState createState() => _ProfileLayoutState();
}

class _ProfileLayoutState extends State<ProfileLayout> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ProfileModel.getProfileFromSh(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          ProfileModel profileModel = snapshot.data;
          return Scaffold(
              backgroundColor: CustomStyle.bgColor,
              drawer: DrawerProfile(profileModel: profileModel),
              appBar: AppBar(
                elevation: 0,
                title: Container(
                    child: Txt(widget.title,
                        style: CustomStyle.textStyle.clone()
                          ..fontSize(18)
                          ..textColor(Colors.black87))),
                backgroundColor: CustomStyle.bgColor,
                iconTheme: new IconThemeData(color: Colors.black87),
              ),
              body: widget.body);
        } else {
          return Container(
              child: Center(
            child: SizedBox(
                height: 30, width: 30, child: CircularProgressIndicator()),
          ));
        }
      },
    );
  }
}

void logout(context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (_) => LoginPage()));
}

class DrawerProfile extends StatelessWidget {
  const DrawerProfile({
    required this.profileModel,
  }) : super();

  final ProfileModel profileModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Parent(
                    style: CustomStyle.imgStyle.clone()
                      ..width(100)
                      ..height(100)
                      ..background.image(path: "images/profile.png"),
                    child: Container()),
                Txt(profileModel.name,
                    style: CustomStyle.textStyle.clone()
                      ..textColor(Colors.black87))
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0xff3C40C6),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Txt(
                  "Aktivitas",
                  style: CustomStyle.textStyle,
                ),
                ListTile(
                  title: Text('Aduan Anda'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Layanan Anda'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Bantuan Anda'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                Txt(
                  "Akun",
                  style: CustomStyle.textStyle,
                ),
                ListTile(
                  title: Text('Keluar'),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Konfirmasi Keluar"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text("Anda Yakin ingin keluar dari Akun?")
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Tidak")),
                                FlatButton(
                                    onPressed: () => logout(context),
                                    child: Text("Ya")),
                              ],
                            ));
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
