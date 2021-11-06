import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:tuandesa/src/models/bantuan_model.dart';
import 'package:tuandesa/src/models/jawaban_model.dart';
import 'package:tuandesa/src/models/jenis_model.dart';
import 'dart:convert';

import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/models/soalbantuan_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_koneksi.dart';

class MenuBantuanView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MenuBantuanViewState();
}

class _MenuBantuanViewState extends State<MenuBantuanView> {
  @override
  void initState() {
    super.initState();
    ProfileModel.getProfileFromSh().then((value) {
      setState(() {
        name = value.name;
      });
    });
    JenisModel.getJenis("bantuan").then((value) {
      if (value.status) {
        List<dynamic> data = json.decode(value.data);
        List<Map<String, dynamic>> hasil = [];
        for (var i = 0; i < data.length; i++) {
          hasil.insert(i, {"id": data[i]['id'], "jenis": data[i]["name"]});
        }
        setState(() {
          _jeniBantuan = hasil;
        });
      }
    });
  }

  late int valueJawaban;
  List<int> listJawabanHasil = [];

  late JawabanModel jawaban;
  List<SoalBantuanModel>? listSoal;
  Color buttonColor = Color(0xff00B894);
  String name = "";
  int no = 0;
  String komentar = "";
  bool loading = false;
  Map<String, dynamic>? jenisBantuanSelected;
  List<Map<String, dynamic>> _jeniBantuan = [];
  List<Asset> lampiran = [];
  late String _error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomStyle.headerColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Bantuan Sosial",
              style: TextStyle(color: Colors.black87),
            ),
            Text(
              name,
              style: TextStyle(fontSize: 14, color: Colors.black87),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Container(
          color: CustomStyle.bgColor,
          padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 30),
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              text("Jenis Bantuan Sosial"),
              FutureBuilder(
                future: JenisModel.getJenis("bantuan"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 20, top: 10),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<Map<String, dynamic>>(
                              isExpanded: true,
                              hint: Text('--Pilih Jenis Bantuan Sosial--'),
                              value: jenisBantuanSelected,
                              icon: Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              items: _jeniBantuan
                                  .map<DropdownMenuItem<Map<String, dynamic>>>(
                                      (Map<String, dynamic> value) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                    value: value, child: Text(value['jenis']));
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  jenisBantuanSelected = value ?? {};
                                });
                                SoalBantuanModel.getSoalBantuans(
                                        value!['id'].toString(), context)
                                    .then((snapshot) {
                                  setState(() {
                                    no = 0;
                                    listJawabanHasil = [];
                                    valueJawaban = 0;
                                    listSoal = snapshot;
                                  });
                                });
                              }),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                        child: Center(
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator())));
                  }
                },
              ),
              (listSoal != null) ? soalBantuan(context) : Container(),
              text("Komentar"),
              Container(
                height: 170,
                child: Card(
                  margin: EdgeInsets.only(bottom: 20, top: 10),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: TextField(
                      maxLines: 10,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan Komentar Anda'),
                      onChanged: (value) {
                        setState(() {
                          komentar = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              text("Lampiran"),
              FlatButton(
                onPressed: () {
                  loadAssets();
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      "images/upload.png",
                      width: 30,
                      height: 30,
                    ),
                    Text(
                        lampiran.length == 0
                            ? "Belum ada lampiran yang dipilih"
                            : "${lampiran.length} lampiran",
                        style: TextStyle(fontWeight: FontWeight.w600))
                  ],
                ),
              ),
              Center(
                child: ButtonTheme(
                  minWidth: 400.0,
                  height: 40.0,
                  child: RaisedButton(
                      onPressed: loading
                          ? null
                          : () {
                              if (jenisBantuanSelected == null ||
                                  komentar == null ||
                                  lampiran.length == 0 ||
                                  listJawabanHasil.length != listSoal!.length) {
                                ShowAlert.show(context, "Validasi",
                                    "Semua data harus diisi!");
                              } else {
                                postBantuan(context);
                              }
                            },
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20)),
                      color: buttonColor,
                      child: !loading
                          ? Text("Simpan",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                          : CircularProgressIndicator()),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  Widget text(text) {
    return Text(
      text,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget soalBantuan(context) {
    if (listSoal!.isEmpty) {
      return Text("Belum Ada Pilihan Soal");
    }
    SoalBantuanModel soalBantuanModel = listSoal![no];
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 1,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              soalBantuanModel.soal,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Container(
                width: MediaQuery.of(context).size.width * 1,
                height: soalBantuanModel.jawaban.length * 60,
                child: jawabanBantuan(soalBantuanModel.jawaban)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: (no == 0)
                      ? null
                      : (listJawabanHasil.length == listSoal!.length)
                          ? () {
                              setState(() {
                                valueJawaban = listJawabanHasil[no - 1];
                                no -= 1;
                              });
                            }
                          : null,
                  child: Text("Kembali"),
                ),
                ElevatedButton(
                  onPressed:
                      (valueJawaban == null || no == listSoal!.length - 1)
                          ? null
                          : () {
                              if (listJawabanHasil.length == listSoal!.length) {
                                setState(() {
                                  valueJawaban = listJawabanHasil[no + 1];
                                  no += 1;
                                });
                              } else {
                                setState(() {
                                  valueJawaban = 0;
                                  no += 1;
                                });
                              }
                            },
                  child: Text("Lanjutkan"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget jawabanBantuan(jawaban) {
    if (valueJawaban == 0) {
      List<int> jaw = listJawabanHasil;
      if (jaw.asMap().containsKey(no)) {
        jaw[no] = 0;
      } else {
        jaw.add(0);
      }
      setState(() {
        valueJawaban = 0;
        listJawabanHasil = jaw;
      });
    }
    return ListView.builder(
      itemCount: jawaban.length,
      itemBuilder: (BuildContext context, int index) {
        JawabanModel data = jawaban[index];
        return RadioListTile(
            title: Text(data.jawaban),
            value: index,
            groupValue: valueJawaban,
            onChanged: (val) {
              List<int> jaw = listJawabanHasil;
              if (jaw.asMap().containsKey(no)) {
                jaw[no] = int.parse(val.toString());
              } else {
                jaw.add(int.parse(val.toString()));
              }
              setState(() {
                valueJawaban = int.parse(val.toString());
                listJawabanHasil = jaw;
              });
            });
      },
    );
  }

  void postBantuan(BuildContext context) async {
    CekKoneksi.cek().then((val) async {
      if (val) {
        setState(() {
          loading = true;
        });
        List<String> files = [];
        List<String> soal = listSoal!.map((val) => val.soal).toList();
        List<String> id_jawaban = [];
        List<String> jawaban = [];
        List<String> nilai = [];
        for (int i = 0; i < listJawabanHasil.length; i++) {
          List<JawabanModel> listJaw = listSoal![i].jawaban;
          id_jawaban.add(listJaw[listJawabanHasil[i]].id);
          jawaban.add(listJaw[listJawabanHasil[i]].jawaban);
          nilai.add(listJaw[listJawabanHasil[i]].nilai);
        }
        for (var i = 0; i < lampiran.length; i++) {
          ByteData image = await lampiran[i].getByteData();
          Uint8List imageUint8List = image.buffer
              .asUint8List(image.offsetInBytes, image.lengthInBytes);
          List<int> imageListInt = imageUint8List.cast<int>();
          String base64Image =
              "data:image/jpeg;base64,${base64Encode(imageListInt)}";
          files.insert(i, base64Image);
        }
        await BantuanModel.postBantuan(jenisBantuanSelected?['id'], komentar,
                files, soal, jawaban, nilai, id_jawaban)
            .then((value) {
          setState(() {
            loading = false;
          });
          if (value.status) {
            Navigator.pop(context);
            ShowAlert.show(context, "Berhasil", value.messages);
          } else {
            ShowAlert.show(context, "Gagal", value.messages);
          }
        });
      } else {
        ShowAlert.show(context, "Koneksi", "Cek koneksi internet anda");
      }
    });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: lampiran,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Pilih Gambar",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      lampiran = resultList;
      _error = error;
    });
  }
}
