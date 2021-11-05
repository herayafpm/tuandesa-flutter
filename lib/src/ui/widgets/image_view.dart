import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewPage extends StatefulWidget {
  final List<String> lampiran;
  ImageViewPage({required this.lampiran}) : super();
  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  int lampiranIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:
              Text("Lampiran ${lampiranIndex} dari ${widget.lampiran.length}")),
      body: Container(
        child: PhotoViewGallery.builder(
          onPageChanged: (index) {
            setState(() {
              lampiranIndex = index + 1;
            });
          },
          scrollPhysics: const BouncingScrollPhysics(),
          itemCount: widget.lampiran.length,
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.lampiran[index]),
              initialScale: PhotoViewComputedScale.contained * 1,
            );
          },
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded /
                        event.expectedTotalBytes!.toInt(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
