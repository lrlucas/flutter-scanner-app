import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:scanner_direccions/src/i18n/app_language_provider.dart';
import 'package:scanner_direccions/src/i18n/app_localizations.dart';
import 'package:scanner_direccions/src/pages/home_page.dart';

Future <void> main() async {
  AppLanguage appLanguage;
  try {
    WidgetsFlutterBinding.ensureInitialized();
    appLanguage = AppLanguage();
    await appLanguage.fetchLocale();
  } on CameraException catch (e) {
    print("ERROR CAMARA");
    print(e.description);
  }
  runApp(MyApp(appLanguage: appLanguage,));
}

class MyApp extends StatelessWidget {
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => appLanguage,
      child: Consumer<AppLanguage> (builder: (context, model, child) {
       return  MaterialApp(
         debugShowCheckedModeBanner: false,
         title: 'Scanner app',
         locale: model.appLocal,
         supportedLocales: [
           Locale('en', 'US'),
           Locale('es', 'BO')
         ],
         localizationsDelegates: [
           AppLocalizations.delegate,
           GlobalMaterialLocalizations.delegate,
           GlobalCupertinoLocalizations.delegate,
           GlobalWidgetsLocalizations.delegate
         ],
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
      }),
    );





  }

}
