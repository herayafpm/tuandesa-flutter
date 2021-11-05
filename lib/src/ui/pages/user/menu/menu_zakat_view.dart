import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuandesa/src/models/zakat_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/pages/user/menu/detail_zakat.dart';

class MenuZakatView extends StatefulWidget {
  @override
  _MenuZakatViewState createState() => _MenuZakatViewState();
}

class _MenuZakatViewState extends State<MenuZakatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomStyle.bgColor,
      appBar: AppBar(
        backgroundColor: CustomStyle.headerColor,
        title: Txt("Zakat Desa"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureZakat(),
      ),
    );
  }
}

class FutureZakat extends StatefulWidget {
  const FutureZakat() : super();

  @override
  _FutureZakatState createState() => _FutureZakatState();
}

class _FutureZakatState extends State<FutureZakat> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              header: WaterDropHeader(),
              onRefresh: () {
                _onRefresh();
              },
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ZakatModel zakatModel = snapshot.data[index];
                  return Parent(
                    gesture: Gestures()
                      ..onTap(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DetailZakat(
                                      title: zakatModel.judul,
                                      id: zakatModel.id,
                                    )));
                      }),
                    style: CustomStyle.cardStyle.clone()..padding(all: 10),
                    child: Parent(
                      style: ParentStyle()..padding(all: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Txt(
                            zakatModel.judul.toUpperCase(),
                            style: CustomStyle.textStyle.clone()
                              ..bold()
                              ..fontSize(16)
                              ..textColor(Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Container(
              child: Center(
                child: Txt(
                  "Tidak ada zakat untuk saat ini",
                  style: CustomStyle.textStyle,
                ),
              ),
            );
          }
        } else {
          return Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      future: ZakatModel.getZakats(context),
    );
  }
}
