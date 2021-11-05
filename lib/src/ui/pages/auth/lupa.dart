import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:tuandesa/src/models/auth_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/layouts/auth_layout.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_koneksi.dart';

class LupaPage extends StatefulWidget {
  @override
  _LupaPageState createState() => _LupaPageState();
}

class _LupaPageState extends State<LupaPage> {
  final _formKey = GlobalKey<FormState>();
  String nik = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Parent(
              child: TextFormField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Masukkan Username";
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    nik = val ?? '';
                  });
                },
                decoration: const InputDecoration(
                    hintText: "Masukkan Username",
                    labelText: "Username",
                    focusColor: Colors.pinkAccent),
              ),
              style: CustomStyle.cardStyle.clone(),
            ),
            Parent(
              style: CustomStyle.buttonStyle,
              child: (loading)
                  ? const Center(
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )))
                  : Txt(
                      "Kirim Permintaan",
                      style: CustomStyle.textStyle.clone()
                        ..textColor(Colors.white)
                        ..bold()
                        ..alignment.center()
                        ..textAlign.center(),
                    ),
              gesture: Gestures()
                ..onTap((loading)
                    ? () {}
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          lupa(context);
                        }
                      }),
            ),
            Parent(
              style: ParentStyle()
                ..alignment.centerRight()
                ..margin(bottom: 20, top: 20)
                ..padding(all: 10)
                ..ripple(true, splashColor: Colors.grey[400]),
              child: Txt(
                "Login",
                style: CustomStyle.textStyle.clone()
                  ..fontSize(15)
                  ..textColor(Colors.redAccent),
                gesture: Gestures()..onTap(() => Navigator.pop(context)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void lupa(context) {
    CekKoneksi.cek().then((val) {
      if (val) {
        setState(() {
          loading = true;
        });
        AuthModel.lupa(nik).then((val) {
          setState(() {
            loading = false;
          });
          if (val.status) {
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
