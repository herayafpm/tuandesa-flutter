import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tuandesa/src/models/aduan_model.dart';
import 'package:tuandesa/src/models/berita_model.dart';
import 'package:tuandesa/src/models/detailaduan_model.dart';
import 'package:tuandesa/src/models/detailterkini_model.dart';
import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/user/berita/comment_view.dart';
import 'package:tuandesa/src/ui/widgets/image_view.dart';

class DetailTerkiniView extends StatefulWidget {
  final BeritaModel berita;
  DetailTerkiniView({required this.berita});
  @override
  _DetailTerkiniViewState createState() => _DetailTerkiniViewState();
}

class _DetailTerkiniViewState extends State<DetailTerkiniView> {
  late DetailTerkiniModel detailTerkiniModel;
  bool loading = false;
  bool comment = false;
  late String komentar;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  void getDetailBerita() {
    setState(() {
      loading = true;
    });
    DetailTerkiniModel.getData(widget.berita.id).then((val) {
      setState(() {
        loading = false;
      });
      detailTerkiniModel = val;
    });
  }

  void beritaLike(like) async {
    await BeritaModel.beritaLike(widget.berita.id, like).then((val) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomStyle.bgColor,
      appBar: AppBar(
        title: Text("Berita ${widget.berita.name}"),
        backgroundColor: CustomStyle.headerColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Parent(
              style: CustomStyle.cardStyle.clone()
                ..borderRadius(topLeft: 20, topRight: 20)
                ..background.color(Color(0xffF1F2F6))
                ..elevation(1)
                ..alignment.center()
                ..width(MediaQuery.of(context).size.width * 0.9)
                ..height(MediaQuery.of(context).size.height * 1)
                ..ripple(false)
                ..padding(horizontal: 20, vertical: 5),
              child: Column(
                children: <Widget>[
                  Parent(
                    gesture: Gestures()
                      ..onTap(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ImageViewPage(
                                    lampiran: widget.berita.lampiran)));
                      }),
                    style: CustomStyle.imgStyle.clone()
                      ..background.image(
                        url: widget.berita.lampiran[0],
                        fit: BoxFit.fill,
                      )
                      ..borderRadius(all: 10)
                      ..width(MediaQuery.of(context).size.width * 0.7)
                      ..height(200),
                    child: (widget.berita.lampiran.length > 1)
                        ? Parent(
                            style: ParentStyle()
                              ..borderRadius(all: 10)
                              ..background.rgba(0, 0, 0, 0.4)
                              ..padding(all: 10),
                            child: Center(
                              child: Txt(
                                "+${widget.berita.lampiran.length}",
                                style: CustomStyle.textStyle.clone()
                                  ..fontSize(24)
                                  ..textColor(Colors.white),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  Flexible(
                    child: Parent(
                      style: ParentStyle()
                        ..maxHeight(70)
                        ..padding(all: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.berita.createdAt,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.berita.name,
                                  maxLines: 2,
                                  softWrap: false,
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            ),
                          ),
                          FutureBuilder(
                            future:
                                DetailTerkiniModel.getData(widget.berita.id),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                DetailTerkiniModel detail = snapshot.data;
                                return Row(
                                  children: <Widget>[
                                    ButtonTheme(
                                      minWidth: 10,
                                      child: FlatButton(
                                          onPressed: () {
                                            beritaLike(detail.like);
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text(detail.likes),
                                              (detail.like)
                                                  ? Image.asset(
                                                      "images/loveon.png",
                                                      width: 30,
                                                      height: 30)
                                                  : Image.asset(
                                                      "images/loveoff.png",
                                                      width: 30,
                                                      height: 30)
                                            ],
                                          )),
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
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Parent(
                    style: ParentStyle()
                      ..padding(all: 10)
                      ..alignment.topLeft(),
                    child: Row(
                      children: <Widget>[
                        Txt(
                          "Status: ",
                          style: CustomStyle.textStyle.clone()
                            ..fontSize(17)
                            ..textAlign.justify()
                            ..textColor(Colors.black87),
                        ),
                        Txt(
                          (widget.berita.status) ? "Selesai" : "Proses",
                          style: CustomStyle.textStyle.clone()
                            ..fontSize(17)
                            ..textAlign.justify()
                            ..textColor((widget.berita.status)
                                ? Colors.green
                                : Colors.redAccent)
                            ..bold(),
                        )
                      ],
                    ),
                  ),
                  Flexible(
                    child: Parent(
                      style: ParentStyle()
                        ..padding(all: 10)
                        ..alignment.topLeft(),
                      child: Txt(
                        widget.berita.komentar,
                        style: CustomStyle.textStyle.clone()
                          ..fontSize(17)
                          ..textAlign.justify(),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
