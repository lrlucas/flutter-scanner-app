import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scanner_direccions/src/pages/home_page.dart';

Future <void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
  } on CameraException catch (e) {
    print("ERROR CAMARA");
    print(e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scanner app',
      theme: ThemeData(
        splashFactory: InkRipple.splashFactory,
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: HomePage(),
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }

}
