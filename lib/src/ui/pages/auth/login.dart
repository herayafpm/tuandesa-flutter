import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuandesa/src/models/auth_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/layouts/auth_layout.dart';
import 'package:tuandesa/src/ui/pages/auth/lupa.dart';
import 'package:tuandesa/src/ui/pages/user/home_page_view.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_koneksi.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String nik = "";
  String password = "";
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
              child: TextFormField(
                obscureText: true,
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Masukkan Kata sandi";
                  } else if (val.length < 6) {
                    return "Kata sandi kurang dari 6 karakter";
                  }
                  return null;
                },
                onSaved: (val) {
                  setState(() {
                    password = val ?? '';
                  });
                },
                decoration: const InputDecoration(
                    hintText: "Masukkan kata sandi",
                    labelText: "Kata sandi",
                    focusColor: Colors.pinkAccent),
              ),
              style: CustomStyle.cardStyle.clone(),
            ),
            Parent(
              style: CustomStyle.buttonStyle,
              child: (loading)
                  ? Center(
                      child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )))
                  : Txt("Login",
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
                          login(context);
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
                "Lupa Kata sandi?",
                style: CustomStyle.textStyle.clone()
                  ..fontSize(15)
                  ..textColor(Colors.redAccent),
              ),
              gesture: Gestures()
                ..onTap(() => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LupaPage()))),
            )
          ],
        ),
      ),
    );
  }

  void login(context) {
    CekKoneksi.cek().then((val) {
      if (val) {
        setState(() {
          loading = true;
        });
        AuthModel.login(nik, password).then((val) {
          setState(() {
            loading = false;
          });
          if (val.status) {
            setToken(val.data);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomePageView()));
          } else {
            ShowAlert.show(context, "Gagal", val.messages);
          }
        });
      } else {
        ShowAlert.show(context, "Koneksi", "Cek koneksi internet anda");
      }
    });
  }

  void setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }
}
