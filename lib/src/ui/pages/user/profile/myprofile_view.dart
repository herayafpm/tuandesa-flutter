import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/layouts/profile_layout.dart';
import 'package:tuandesa/src/ui/pages/user/profile/ubahprofile_view.dart';
import 'package:tuandesa/src/utils/cek_authorization.dart';

class MyProfileView extends StatefulWidget {
  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 2000));
    await ProfileModel(
            alamat: '',
            createdAt: '',
            email: '',
            id: '',
            name: '',
            nik: '',
            noHP: '',
            ttl: '',
            type: '')
        .getProfile(context)
        .then((val) {
      setState(() {
        _refreshController.refreshCompleted();
      });
    });
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 2000));
    await ProfileModel(
            alamat: '',
            createdAt: '',
            email: '',
            id: '',
            name: '',
            nik: '',
            noHP: '',
            ttl: '',
            type: '')
        .getProfile(context)
        .then((val) {
      setState(() {
        _refreshController.loadComplete();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfileLayout(
      title: "Profile",
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        header: WaterDropHeader(),
        onRefresh: () => _onRefresh(),
        onLoading: () => _onLoading(),
        child: FutureBuilder(
          future: ProfileModel.getProfileFromSh(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              ProfileModel profileModel = snapshot.data;
              String status = CekAuthorization.whoIs(profileModel.type);
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width * 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Parent(
                          style: CustomStyle.imgStyle.clone()
                            ..borderRadius(all: 50)
                            ..width(93)
                            ..height(93)
                            ..background.image(path: "images/profile.png")
                            ..elevation(2),
                          child: Container()),
                      Parent(
                        style: CustomStyle.cardStyle.clone()
                          ..width(MediaQuery.of(context).size.width * 0.9)
                          ..padding(all: 10)
                          ..borderRadius(all: 20),
                        child:
                            Container(child: Txt("NIK: ${profileModel.nik}")),
                      ),
                      Parent(
                        style: CustomStyle.cardStyle.clone()
                          ..width(MediaQuery.of(context).size.width * 0.9)
                          ..padding(all: 10)
                          ..borderRadius(all: 20),
                        child: Container(
                            child: Txt("Nama Lengkap: ${profileModel.name}")),
                      ),
                      Parent(
                        style: CustomStyle.cardStyle.clone()
                          ..width(MediaQuery.of(context).size.width * 0.9)
                          ..padding(all: 10)
                          ..borderRadius(all: 20),
                        child: Container(
                            child: Txt(
                                "Tempat Tanggal Lahir: ${profileModel.ttl}")),
                      ),
                      Parent(
                        style: CustomStyle.cardStyle.clone()
                          ..width(MediaQuery.of(context).size.width * 0.9)
                          ..padding(all: 10)
                          ..borderRadius(all: 20),
                        child: Container(
                            child: Txt("Alamat: ${profileModel.alamat}")),
                      ),
                      Parent(
                        style: CustomStyle.cardStyle.clone()
                          ..width(MediaQuery.of(context).size.width * 0.9)
                          ..padding(all: 10)
                          ..borderRadius(all: 20),
                        child: Container(
                            child: Txt("No HP: ${profileModel.noHP}")),
                      ),
                      Parent(
                        style: CustomStyle.cardStyle.clone()
                          ..width(MediaQuery.of(context).size.width * 0.9)
                          ..padding(all: 10)
                          ..borderRadius(all: 20),
                        child: Container(
                            child: Txt("Email: ${profileModel.email}")),
                      ),
                      Parent(
                        style: CustomStyle.cardStyle.clone()
                          ..width(MediaQuery.of(context).size.width * 0.9)
                          ..padding(all: 10)
                          ..borderRadius(all: 20),
                        child: Container(child: Txt("Status: $status")),
                      ),
                      Parent(
                        style: CustomStyle.buttonStyle.clone()..width(135),
                        child: Txt("Ubah Profile",
                            style: CustomStyle.textStyle.clone()
                              ..textColor(Colors.white)
                              ..bold()
                              ..alignment.center()
                              ..textAlign.center()),
                        gesture: Gestures()
                          ..onTap(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => UbahProfileView()));
                          }),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                  child: Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()),
              ));
            }
          },
        ),
      ),
    );
  }
}
