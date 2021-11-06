import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tuandesa/src/blocs/berita_bloc.dart';
import 'package:tuandesa/src/models/berita_model.dart';
import 'package:tuandesa/src/models/profile_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/user/berita/detail_terkini_view.dart';
import 'package:tuandesa/src/ui/widgets/image_view.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_koneksi.dart';

class BeritaTerkiniView extends StatefulWidget {
  @override
  _BeritaTerkiniViewState createState() => _BeritaTerkiniViewState();
}

class _BeritaTerkiniViewState extends State<BeritaTerkiniView> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late BeritaBloc beritaBloc;
  String userId = "";
  @override
  void initState() {
    super.initState();
    ProfileModel.getProfileFromSh().then((val) {
      setState(() {
        userId = val.id;
      });
    });
  }

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 2000));
    beritaBloc..add(RefreshBerita());
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 2000));
    beritaBloc..add(GetBerita());
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    beritaBloc = BlocProvider.of<BeritaBloc>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Parent(
        style: CustomStyle.cardStyle.clone()
          ..borderRadius(topLeft: 20, topRight: 20)
          ..background.color(Color(0xffF1F2F6))
          ..elevation(1)
          ..ripple(false)
          ..padding(horizontal: 20, vertical: 5),
        child: BlocBuilder<BeritaBloc, BeritaState>(
          builder: (context, state) {
            if (state is BeritaUninitialized) {
              return ListView.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) {
                  return LoadingSkelton();
                },
              );
            } else {
              BeritaLoaded beritaLoaded = state as BeritaLoaded;
              if (beritaLoaded.beritas.length > 0) {
                return SmartRefresher(
                  controller: _refreshController,
                  enablePullUp: true,
                  enablePullDown: true,
                  header: WaterDropHeader(),
                  onLoading: () => _onLoading(),
                  onRefresh: () => _onRefresh(),
                  child: ListView.builder(
                      itemCount: beritaLoaded.beritas.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListItem(
                              beritaModel: beritaLoaded.beritas[index],
                              userId: userId,
                              beritaBloc: beritaBloc)),
                );
              } else {
                return Container(
                  child: Center(
                    child: Txt(
                      "Tidak ada berita saat ini",
                      style: CustomStyle.textStyle.clone(),
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class LoadingSkelton extends StatelessWidget {
  const LoadingSkelton() : super();

  @override
  Widget build(BuildContext context) {
    return Parent(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300] ?? Colors.grey,
        highlightColor: Colors.grey[100] ?? Colors.grey,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Parent(
              style: CustomStyle.imgStyle.clone()
                ..elevation(5)
                ..width(MediaQuery.of(context).size.width * 0.3)
                ..height(MediaQuery.of(context).size.height * 1 / 6),
              child: Shimmer.fromColors(
                baseColor: Colors.grey,
                highlightColor: Colors.white,
                child: Container(),
              ),
            ),
            Flexible(
              child: Txt(
                "Mengambil data",
                style: CustomStyle.textStyle,
              ),
            )
          ],
        ),
      ),
      style: CustomStyle.cardStyle.clone()
        ..background.color(Color(0xffF4FEFF))
        ..borderRadius(all: 10),
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem(
      {required this.beritaModel,
      required this.userId,
      required this.beritaBloc})
      : super();

  final String userId;
  final BeritaModel beritaModel;
  final BeritaBloc beritaBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Parent(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Parent(
                style: CustomStyle.imgStyle.clone()
                  ..width(MediaQuery.of(context).size.width * 0.3)
                  ..height(MediaQuery.of(context).size.height * 1 / 6)
                  ..background
                      .image(url: beritaModel.lampiran[0], fit: BoxFit.cover)
                  ..elevation(5),
                gesture: Gestures()
                  ..onTap(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ImageViewPage(lampiran: beritaModel.lampiran)));
                  }),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Txt(beritaModel.name,
                          style: CustomStyle.textStyle.clone()
                            ..maxLines(1)
                            ..fontSize(16)
                            ..bold()
                            ..textColor((beritaModel.userId == userId)
                                ? Colors.blueAccent
                                : Colors.white)),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: Txt(beritaModel.komentar + ".",
                            style: CustomStyle.textStyle.clone()
                              ..maxLines(2)
                              ..fontSize(14)
                              ..textAlign.justify()),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: Txt("Selengkapnya...",
                            style: CustomStyle.textStyle.clone()
                              ..fontSize(14)
                              ..textColor(Colors.lightBlue)
                              ..maxLines(2)),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          style: CustomStyle.cardStyle.clone()
            ..background.color(const Color(0xffF4FEFF))
            ..borderRadius(all: 10),
          gesture: Gestures()
            ..onTap(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailTerkiniView(
                            berita: beritaModel,
                          )));
            })
            ..onLongPress((beritaModel.userId == userId)
                ? () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Hapus berita"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text("Yakin ingin menghapus berita ini?")
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
                                    onPressed: () {
                                      deleteBerita(
                                          id: beritaModel.id, context: context);
                                    },
                                    child: Text("Ya")),
                              ],
                            ));
                  }
                : () {}),
        )
      ],
    );
  }

  void deleteBerita({required String id, context}) async {
    CekKoneksi.cek().then((val) async {
      if (val) {
        await BeritaModel.beritaDelete(id).then((val) {
          Navigator.pop(context);
          beritaBloc..add(RefreshBerita());
        });
      } else {
        ShowAlert.show(context, "Koneksi", "Pastikan koneksi internet ada");
      }
    });
  }
}
