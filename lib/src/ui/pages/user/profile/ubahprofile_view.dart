import 'package:connectivity/connectivity.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_email.dart';
import 'package:tuandesa/src/utils/cek_koneksi.dart';

class UbahProfileView extends StatefulWidget {
  @override
  _UbahProfileViewState createState() => _UbahProfileViewState();
}

class _UbahProfileViewState extends State<UbahProfileView> {
  final _formKey = GlobalKey<FormState>();
  late String ttl, noHP, email, password1, password2;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomStyle.bgColor,
        appBar: AppBar(
          title: Container(
              child: Txt("Ubah Profile",
                  style: CustomStyle.textStyle.clone()
                    ..fontSize(18)
                    ..textColor(Colors.black87))),
          backgroundColor: CustomStyle.bgColor,
          iconTheme: new IconThemeData(color: Colors.black87),
        ),
        body: FutureBuilder(
          future: ProfileModel.getProfileFromSh(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              ProfileModel profileModel = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Parent(
                          style: CustomStyle.cardStyle.clone()
                            ..opacity(0.7)
                            ..width(MediaQuery.of(context).size.width * 0.9)
                            ..padding(all: 10)
                            ..borderRadius(all: 20),
                          child: Container(
                              child: TextFormField(
                            enabled: false,
                            initialValue: profileModel.nik,
                            decoration: InputDecoration(labelText: "NIK"),
                          )),
                        ),
                        Parent(
                          style: CustomStyle.cardStyle.clone()
                            ..opacity(0.7)
                            ..width(MediaQuery.of(context).size.width * 0.9)
                            ..padding(all: 10)
                            ..borderRadius(all: 20),
                          child: Container(
                              child: TextFormField(
                            enabled: false,
                            initialValue: profileModel.name,
                            decoration:
                                InputDecoration(labelText: "Nama Lengkap"),
                          )),
                        ),
                        Parent(
                          style: CustomStyle.cardStyle.clone()
                            ..width(MediaQuery.of(context).size.width * 0.9)
                            ..padding(all: 10)
                            ..borderRadius(all: 20),
                          child: Container(
                              child: TextFormField(
                            enabled: true,
                            initialValue: profileModel.ttl,
                            decoration: InputDecoration(
                                labelText: "Tempat Tanggal Lahir"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Masukkan Tempat Tanggal Lahir";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                ttl = val ?? '';
                              });
                            },
                          )),
                        ),
                        Parent(
                          style: CustomStyle.cardStyle.clone()
                            ..opacity(0.7)
                            ..width(MediaQuery.of(context).size.width * 0.9)
                            ..padding(all: 10)
                            ..borderRadius(all: 20),
                          child: Container(
                              child: TextFormField(
                            enabled: false,
                            initialValue: profileModel.alamat,
                            decoration: InputDecoration(labelText: "Alamat"),
                          )),
                        ),
                        Parent(
                          style: CustomStyle.cardStyle.clone()
                            ..width(MediaQuery.of(context).size.width * 0.9)
                            ..padding(all: 10)
                            ..borderRadius(all: 20),
                          child: Container(
                              child: TextFormField(
                            keyboardType: TextInputType.phone,
                            enabled: true,
                            initialValue: profileModel.noHP,
                            decoration: InputDecoration(labelText: "No HP"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Masukkan NO HP";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                noHP = val ?? '';
                              });
                            },
                          )),
                        ),
                        Parent(
                          style: CustomStyle.cardStyle.clone()
                            ..width(MediaQuery.of(context).size.width * 0.9)
                            ..padding(all: 10)
                            ..borderRadius(all: 20),
                          child: Container(
                              child: TextFormField(
                            enabled: true,
                            initialValue: profileModel.email,
                            decoration: InputDecoration(labelText: "Email"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Masukkan Email";
                              } else if (!CekEmail.cek(val)) {
                                return "Email tidak valid";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                email = val ?? '';
                              });
                            },
                          )),
                        ),
                        Parent(
                          style: CustomStyle.cardStyle.clone()
                            ..width(MediaQuery.of(context).size.width * 0.9)
                            ..padding(all: 10)
                            ..borderRadius(all: 20),
                          child: Container(
                              child: TextFormField(
                            obscureText: true,
                            enabled: true,
                            decoration: InputDecoration(
                                labelText: "Kata Sandi sekarang"),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Masukkan Kata Sandi saat ini";
                              } else if (val.length < 6) {
                                return "Kata Sandi kurang dari 6 karakter";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                password1 = val ?? '';
                              });
                            },
                          )),
                        ),
                        Parent(
                          style: CustomStyle.cardStyle.clone()
                            ..width(MediaQuery.of(context).size.width * 0.9)
                            ..padding(all: 10)
                            ..borderRadius(all: 20),
                          child: Container(
                              child: TextFormField(
                            obscureText: true,
                            enabled: true,
                            decoration: InputDecoration(
                                labelText: "Kata Sandi Baru",
                                hintText: "Kosongi jika ingin tidak berubah"),
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                if (val.length < 6) {
                                  return "Kata Sandi baru kurang dari 6 karakter";
                                }
                                return null;
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                password2 = val ?? '';
                              });
                            },
                          )),
                        ),
                        Parent(
                          style: CustomStyle.buttonStyle.clone()..width(135),
                          child: (loading)
                              ? Center(
                                  child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                      )))
                              : Txt("Simpan Profile",
                                  style: CustomStyle.textStyle.clone()
                                    ..textColor(Colors.white)
                                    ..bold()
                                    ..alignment.center()
                                    ..textAlign.center()),
                          gesture: Gestures()
                            ..onTap((loading)
                                ? () {}
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      updateProfil(profileModel, context);
                                    }
                                  }),
                        )
                      ],
                    ),
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
        ));
  }

  void updateProfil(profileModel, context) async {
    CekKoneksi.cek().then((val) {
      if (val) {
        setState(() {
          loading = true;
        });
        ProfileModel.updateProfile(
                profileModel.alamat, ttl, noHP, email, password1, password2)
            .then((val) {
          setState(() {
            loading = false;
          });
          if (val.status) {
            Navigator.pop(context);
            ShowAlert.show(context, "Berhasil", val.messages);
          } else {
            ShowAlert.show(context, "Gagal", val.messages);
          }
        });
      } else {
        ShowAlert.show(context, "Koneksi", "Cek koneksi internet anda");
      }
    });
  }
}
