import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanner_direccions/src/pages/detail_page.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController _cameraController;
  List<CameraDescription> cameras = [];
  dynamic errorCamera;

  @override
  void initState() {
    super.initState();

    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        _cameraController =
            CameraController(cameras[0], ResolutionPreset.medium);
        _cameraController
            .initialize()
            .then((_) => {
                  if (!mounted)
                    {}
                  else
                    {
                      setState(() {
                        errorCamera = null;
                      })
                    }
                })
            .catchError((err) {
          print("ERROR DE LA CAMARA");
          print(err.code);
          setState(() {
            errorCamera = err;
          });
        });
      } else {
        print("NO AVAILABLE CAMERA");
      }
    }).catchError((err) {
      print("ERROR AL INICIALIZAR LA CAMARA");
      print(err);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  Future<String> _takePicture() async {
    // Checking whether the controller is initialized
    if (!_cameraController.value.isInitialized) {
      print("Controller is not initialized");
      return null;
    }
    // Formatting Date and Time
    String dateTime = DateFormat.yMMMd()
        .addPattern('-')
        .add_Hms()
        .format(DateTime.now())
        .toString();

    String formattedDateTime = dateTime.replaceAll(' ', '');

    // Retrieving the path for saving an image
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String visionDir = '${appDocDir.path}/Photos/Vision\ Images';
    await Directory(visionDir).create(recursive: true);
    final String imagePath = '$visionDir/image_$formattedDateTime.jpg';

    // Checking whether the picture is being taken
    // to prevent execution of the function again
    // if previous execution has not ended
    if (_cameraController.value.isTakingPicture) {
      print("Processing is in progress...");
      return null;
    }

    try {
      await _cameraController.takePicture(imagePath);
    } on CameraException catch (e) {
      print("CAMERA EXCEPTION $e");
      return null;
    }
    print("PATH $imagePath");
    return imagePath;
  }

  // !_cameraController.value.isInitialized
  @override
  Widget build(BuildContext context) {
    dynamic controller = (_cameraController?.value?.isInitialized) ?? false;
    if (errorCamera != null) {
      return Container(
        color: Colors.white24,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return (!controller)
        ? new Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : new Stack(children: <Widget>[
            AspectRatio(
              aspectRatio: _cameraController.value.aspectRatio,
              child: CameraPreview(_cameraController),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                alignment: AlignmentDirectional.bottomCenter,
                child: RaisedButton.icon(
                  icon: Icon(Icons.camera),
                  label: Text("Click"),
                  onPressed: () async {
                    await _takePicture().then((String path) {
                      if (path != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => DetailPage(
                                      imagePath: path,
                                      // imagePath:
                                      //     "/data/user/0/com.example.scanner_direccions/app_flutter/Photos/Vision Images/image_Nov3,2020-21:51:40.jpg",
                                    )));
                      }
                    });
                  },
                ),
              ),
            )
          ]);
  }
}
