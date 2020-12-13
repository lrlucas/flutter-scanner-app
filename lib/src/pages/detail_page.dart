import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:scanner_direccions/src/bloc/direction_bloc.dart';
import 'package:scanner_direccions/src/models/DirectionModel.dart';

class DetailPage extends StatefulWidget {
  final String imagePath;

  DetailPage({this.imagePath});

  @override
  _DetailPageState createState() => _DetailPageState(imagePath);
}

class _DetailPageState extends State<DetailPage> {
  final String path;
  Size _imageSize;
  String recognizedText = "Loading...";
  var listRecognizerText = [];
  String text = "";
  TextEditingController _controller = new TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();
  final directionBloc = new DirectionsBloc();

  _DetailPageState(this.path);

  void _initializeVision() async {
    final File imageFile = File(path);

    if (imageFile != null) {
      await _getImageSize(imageFile);
    }

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);

    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();

    final VisionText visionText =
        await textRecognizer.processImage(visionImage);

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        setState(() {
          text += " ${line.text}";
        });
      }
    }

    if (this.mounted) {
      setState(() {
        _controller.text = text;
      });
    }
  }

  Future<void> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    // Fetching image from path
    final Image image = Image.file(imageFile);

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    print("PATH");
    print(this.path);
    super.initState();
    _initializeVision();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text("Detail page"),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        children: [
          Divider(), // todo: no me gusta como queda el borde, revisar otras opciones
          Card(
            child: TextField(
              controller: _controller,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              onChanged: (String value) {
                setState(() {
                  text = value;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                child: Text("Save"),
                onPressed: text.length > 0
                    ? () async {
                        var directionIdContador = directionBloc.getContador();
                        var direction = DirectionModel(
                            value: text,
                            directionId: directionIdContador
                        );
                        await directionBloc.createDirection(direction);
                        directionBloc.addContador();
                        final snackBar = SnackBar(
                          content: Text('Scanner Saved successful'),
                          duration: Duration(seconds: 3),
                        );
                        globalKey.currentState.showSnackBar(snackBar);
                      }
                    : null,
              ),
              RaisedButton(
                child: Text("Back to Home"),
                onPressed: text.length > 0
                    ? () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      }
                    : null,
              ),
            ],
          )
        ],
      )),
    );
  }
}
