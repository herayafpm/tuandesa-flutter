import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:tuandesa/src/models/aduan_model.dart';
import 'package:tuandesa/src/models/detailaduan_model.dart';
import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/user/berita/comment_view.dart';
import 'package:tuandesa/src/ui/widgets/image_view.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';

class DetailAduanView extends StatefulWidget {
  final AduanModel aduan;
  DetailAduanView({required this.aduan});
  @override
  _DetailAduanViewState createState() => _DetailAduanViewState();
}

class _DetailAduanViewState extends State<DetailAduanView> {
  late DetailAduanModel detailAduanModel;
  bool loading = false;
  bool comment = false;
  late String komentar;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  void getDetailAduan() {
    setState(() {
      loading = true;
    });
    DetailAduanModel.getData(widget.aduan.id).then((val) {
      setState(() {
        loading = false;
      });
      detailAduanModel = val;
    });
  }

  void aduanLike(like) async {
    await AduanModel.aduanLike(widget.aduan.id, like).then((val) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomStyle.bgColor,
      appBar: AppBar(
        title: Text("Aduan ${widget.aduan.name}"),
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
                                    lampiran: widget.aduan.lampiran)));
                      }),
                    style: CustomStyle.imgStyle.clone()
                      ..background.image(
                        url: widget.aduan.lampiran[0],
                        fit: BoxFit.fill,
                      )
                      ..borderRadius(all: 10)
                      ..width(MediaQuery.of(context).size.width * 0.7)
                      ..height(200),
                    child: (widget.aduan.lampiran.length > 1)
                        ? Parent(
                            style: ParentStyle()
                              ..borderRadius(all: 10)
                              ..background.rgba(0, 0, 0, 0.4)
                              ..padding(all: 10),
                            child: Center(
                              child: Txt(
                                "+${widget.aduan.lampiran.length}",
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
                                  widget.aduan.createdAt,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  widget.aduan.name,
                                  maxLines: 2,
                                  softWrap: false,
                                  textAlign: TextAlign.justify,
                                )
                              ],
                            ),
                          ),
                          FutureBuilder(
                            future: DetailAduanModel.getData(widget.aduan.id),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                DetailAduanModel detail = snapshot.data;
                                return Row(
                                  children: <Widget>[
                                    ButtonTheme(
                                      minWidth: 10,
                                      child: FlatButton(
                                          onPressed: () {
                                            aduanLike(detail.like);
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
                                    ButtonTheme(
                                      minWidth: 10,
                                      child: FlatButton(
                                          onPressed: () {
                                            ProfileModel.getProfileFromSh()
                                                .then((val) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          CommentView(
                                                            aduan: widget.aduan,
                                                            user_id: val.id
                                                                .toString(),
                                                          )));
                                            });
                                          },
                                          child: Row(
                                            children: <Widget>[
                                              Text(detail.comments),
                                              Image.asset('images/comment.png',
                                                  width: 30, height: 30)
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
                          (widget.aduan.status) ? "Selesai" : "Proses",
                          style: CustomStyle.textStyle.clone()
                            ..fontSize(17)
                            ..textAlign.justify()
                            ..textColor((widget.aduan.status)
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
                        widget.aduan.komentar,
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
