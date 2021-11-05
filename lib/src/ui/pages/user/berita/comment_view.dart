import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tuandesa/src/blocs/comment_bloc.dart';
import 'package:tuandesa/src/models/aduan_model.dart';
import 'package:tuandesa/src/models/comment_model.dart';
import 'package:tuandesa/src/styles/custom_style.dart';
import 'package:tuandesa/src/ui/widgets/show_alert.dart';
import 'package:tuandesa/src/utils/cek_koneksi.dart';

class CommentView extends StatefulWidget {
  AduanModel aduan;
  String user_id;
  CommentView({required this.aduan, required this.user_id});
  @override
  _CommentViewState createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  late CommentBloc commentBloc;
  late String comment;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  void refreshComment() {
    commentBloc..add(RefreshComment(id: widget.aduan.id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(
          "Komentar Aduan ${widget.aduan.name}",
          style: CustomStyle.textStyle.clone()..textColor(Colors.white),
        ),
        backgroundColor: CustomStyle.headerColor,
      ),
      backgroundColor: CustomStyle.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Flexible(
                flex: 1,
                child: BlocProvider(
                  create: (context) {
                    commentBloc = CommentBloc(CommentUninitialized())
                      ..add(GetComment(id: widget.aduan.id));
                    return commentBloc;
                  },
                  child: CommentBuilder(
                    id: widget.aduan.id,
                    user_id: widget.user_id,
                  ),
                ),
              ),
            ),
            Container(
              height: 80,
              child: Form(
                key: _formKey,
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: 'Masukkan Komentar',
                            labelText: "Komentar"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Komentar tidak boleh kosong";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          setState(() {
                            comment = value ?? '';
                          });
                        },
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 30,
                      child: FlatButton(
                          onPressed: (loading)
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    postComment();
                                  }
                                },
                          child: const Icon(
                            Icons.send,
                            size: 30,
                          )),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void postComment() async {
    CekKoneksi.cek().then((val) async {
      if (val) {
        setState(() {
          loading = true;
        });
        await CommentModel.aduanComment(widget.aduan.id, comment).then((value) {
          refreshComment();
          _formKey.currentState!.reset();
          setState(() {
            loading = false;
          });
        });
      } else {
        ShowAlert.show(context, "Koneksi", "Periksa Koneksi Internet Anda");
      }
    });
  }
}

class CommentBuilder extends StatefulWidget {
  String id, user_id;
  CommentBuilder({required this.id, required this.user_id});
  @override
  _CommentBuilderState createState() => _CommentBuilderState();
}

class _CommentBuilderState extends State<CommentBuilder> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late CommentBloc commentBloc;
  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 2000));
    commentBloc..add(RefreshComment(id: widget.id));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 2000));
    commentBloc..add(GetComment(id: widget.id));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    commentBloc = BlocProvider.of<CommentBloc>(context);
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentUninitialized) {
          return Container(
              child: Center(
                  child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator())));
        } else {
          CommentLoaded commentLoaded = state as CommentLoaded;
          if (commentLoaded.comments.length > 0) {
            return SmartRefresher(
              controller: _refreshController,
              reverse: true,
              enablePullUp: true,
              enablePullDown: true,
              onRefresh: () {
                _onRefresh();
              },
              onLoading: () {
                _onLoading();
              },
              header: WaterDropHeader(),
              child: ListView.builder(
                reverse: true,
                itemCount: commentLoaded.comments.length,
                itemBuilder: (BuildContext context, int index) {
                  if (commentLoaded.comments[index].user_id.toString() ==
                      widget.user_id) {
                    return CommentItem(commentLoaded.comments[index], true,
                        commentBloc, widget.id);
                  } else {
                    return CommentItem(commentLoaded.comments[index], false,
                        commentBloc, widget.id);
                  }
                },
              ),
            );
          } else {
            return Center(
              child: Txt(
                "Belum ada komentar",
                style: CustomStyle.textStyle,
              ),
            );
          }
        }
      },
    );
  }
}

class CommentItem extends StatefulWidget {
  final CommentModel commentModel;
  final bool me;
  final CommentBloc commentBloc;
  final String aduanId;
  CommentItem(this.commentModel, this.me, this.commentBloc, this.aduanId);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          (widget.me) ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 85),
          child: GestureDetector(
            onLongPress: (widget.me)
                ? () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Hapus Komentar"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text("Yakin ingin menghapus komentar ini?")
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Tidak")),
                                TextButton(
                                    onPressed: () {
                                      deleteKomentar(
                                          id: widget.commentModel.id,
                                          context: context);
                                    },
                                    child: const Text("Ya")),
                              ],
                            ));
                  }
                : null,
            child: Card(
              elevation: 5,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular((widget.me) ? 10 : 0),
                      topRight: Radius.circular((widget.me) ? 0 : 10),
                      bottomLeft: Radius.circular((widget.me) ? 10 : 0),
                      bottomRight: Radius.circular((widget.me) ? 0 : 10))),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.commentModel.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(widget.commentModel.komentar)
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void deleteKomentar({required String id, context}) async {
    CekKoneksi.cek().then((val) async {
      if (val) {
        await CommentModel.deleteComment(id).then((val) {
          Navigator.pop(context);
          widget.commentBloc..add(RefreshComment(id: widget.aduanId));
          setState(() {});
        });
      } else {
        ShowAlert.show(context, "Koneksi", "Pastikan koneksi internet ada");
      }
    });
  }
}
