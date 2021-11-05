import 'package:flutter/material.dart';
import 'package:tuandesa/src/models/profiledesa_model.dart';
import 'package:tuandesa/src/ui/widgets/image_view.dart';
import 'package:tuandesa/src/utils/static_data.dart';

class MenuProfileDesaView extends StatefulWidget {
  @override
  _MenuProfileDesaViewState createState() => _MenuProfileDesaViewState();
}

class _MenuProfileDesaViewState extends State<MenuProfileDesaView> {
  @override
  void initState() {
    super.initState();
  }

  String lampiranUrl = StaticData.url + '/assets/uploads/profiledesa/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seputar Desa"),
      ),
      body: Container(
        child: FutureBuilder(
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ProfileDesaModel profileDesaModel = snapshot.data![index];
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            profileDesaModel.judul.toUpperCase(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ImageViewPage(
                                        lampiran: profileDesaModel.lampiran))),
                            child: Image.network(profileDesaModel.lampiran[0]),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
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
          future: ProfileDesaModel.getData(context),
        ),
      ),
    );
  }
}
