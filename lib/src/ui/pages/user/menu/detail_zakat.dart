import 'package:flutter/material.dart';
import 'package:tuandesa/src/models/amil_model.dart';
import 'package:tuandesa/src/models/zakat_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_koneksi.dart';

class DetailZakat extends StatefulWidget {
  String title;
  String id;
  DetailZakat({required this.id, required this.title});
  @override
  _DetailZakatState createState() => _DetailZakatState();
}

class _DetailZakatState extends State<DetailZakat> {
  final _formKey = GlobalKey<FormState>();
  String uang = "";
  String beras = "";
  String dusun = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomStyle.bgColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: CustomStyle.headerColor,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: FutureBuilder(
              future: AmilModel.getAmil(widget.id, context),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  AmilModel amilModel = snapshot.data;
                  double berasdouble = double.parse(amilModel.beras);
                  double uangdouble = double.parse(amilModel.uang);
                  return Column(
                    children: <Widget>[
                      Card(
                        color: Colors.white,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextFormField(
                            controller:
                                TextEditingController(text: amilModel.dusun),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: 'Masukkan Dusun', labelText: "Dusun"),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Masukkan Dusun";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                dusun = value ?? '';
                              });
                            },
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: 'Masukkan Nominal Uang',
                                labelText: "Uang"),
                            validator: (value) {
                              if (value!.isEmpty || value == '0.0') {
                                return "Masukkan Nominal Uang";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                uang = value ?? '';
                              });
                            },
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 10, right: 10, bottom: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                hintText: 'Masukkan Beras (Kg)',
                                labelText: "Beras"),
                            validator: (value) {
                              if (value!.isEmpty || value == '0.0') {
                                return "Masukkan Beras (Kg)";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              setState(() {
                                beras = value ?? '';
                              });
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: ButtonTheme(
                            minWidth: 200.0,
                            height: 40.0,
                            child: RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(20)),
                              color: Colors.green,
                              onPressed: loading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        postAmilZakat();
                                      }
                                    },
                              child: !loading
                                  ? Text("Simpan",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                  : CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return Container(
                    child: Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        width: 30,
                        height: 30,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  String _toString(data) {
    String kembali = "";
    if (data.contains(",")) {
      var hasil = data.split(",");
      for (var i = 0; i < hasil.length; i++) {
        kembali += hasil[i];
      }
    } else {
      kembali = data;
    }
    return kembali;
  }

  void postAmilZakat() async {
    CekKoneksi.cek().then((val) async {
      if (val) {
        setState(() {
          loading = true;
        });
        await ZakatModel.postAmilZakat(
                widget.id, _toString(beras), _toString(uang), dusun)
            .then((value) {
          setState(() {
            loading = false;
          });
          if (value.status) {
            ShowAlert.show(context, "Berhasil", value.messages);
          } else {
            ShowAlert.show(context, "Gagal", value.messages);
          }
        });
      } else {
        ShowAlert.show(context, "Koneksi", "Cek Koneksi Anda");
      }
    });
  }
}
