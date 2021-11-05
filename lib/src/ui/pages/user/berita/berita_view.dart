import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuandesa/src/blocs/aduan_bloc.dart';
import 'package:tuandesa/src/blocs/berita_bloc.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/user/berita/berita_aduan_view.dart';
import 'package:tuandesa/src/ui/pages/user/berita/berita_terkini_view.dart';

class BeritaView extends StatefulWidget {
  @override
  _BeritaViewState createState() => _BeritaViewState();
}

class _BeritaViewState extends State<BeritaView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomStyle.bgColor,
          elevation: 0,
          bottom: TabBar(tabs: [
            Tab(
              child: Txt(
                "Berita Terkini",
                style: CustomStyle.textStyle.clone()..fontSize(14),
              ),
            ),
            Tab(
              child: Txt(
                "Berita Aduan",
                style: CustomStyle.textStyle.clone()..fontSize(14),
              ),
            )
          ]),
          title: Row(
            children: <Widget>[
              Image.asset("images/banyumas.png", width: 40, height: 40),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Txt(
                  "TUAN Desa",
                  style: CustomStyle.textStyle,
                ),
              )
            ],
          ),
        ),
        backgroundColor: CustomStyle.bgColor,
        body: TabBarView(children: [
          Tab(
            child: BlocProvider<BeritaBloc>(
              create: (context) =>
                  BeritaBloc(BeritaUninitialized())..add(GetBerita()),
              child: BeritaTerkiniView(),
            ),
          ),
          Tab(
            child: BlocProvider<AduanBloc>(
              create: (context) =>
                  AduanBloc(AduanUninitialized())..add(GetAduan(id: 1)),
              child: BeritaAduanView(),
            ),
          )
        ]),
      ),
    );
  }
}
