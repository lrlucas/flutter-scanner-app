
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scanner_direccions/src/bloc/direction_bloc.dart';
import 'package:scanner_direccions/src/i18n/app_language_provider.dart';
import 'package:scanner_direccions/src/i18n/app_localizations.dart';
import 'package:scanner_direccions/src/models/DirectionModel.dart';
import 'package:scanner_direccions/src/pages/camera_page.dart';
import 'package:scanner_direccions/src/pages/edit_page.dart';
import 'package:scanner_direccions/src/pages/map_page.dart';
import 'package:scanner_direccions/src/widgets/custom_appbar.dart';



class HomePage extends StatefulWidget {
  final DirectionModel directionModel;

  const HomePage({this.directionModel});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final directionBloc = new DirectionsBloc();
  Set<Marker> markers = new Set<Marker>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget showMenuLanguage(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    return PopupMenuButton<int>(
      initialValue: 0,
      tooltip: "Change Language",
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      icon: Icon(Icons.language, semanticLabel: "Change language", size: 27.0,),
      onCanceled: () {
        print("OnCanceled");
      },
      onSelected: (int value) {
        print("onSelected $value");
        switch (value) {
          case 0:
            appLanguage.changeLanguage(Locale("en"));
            break;
          case 1:
            appLanguage.changeLanguage(Locale("es"));
            break;
        }
      },
      offset: Offset(0.0, 20.0),
     itemBuilder: (context) => [
       PopupMenuItem(
         child: Text("English"),
         value: 0,
       ),
       PopupMenuItem(
         child: Text("Spanish"),
         value: 1,
       ),
       PopupMenuItem(
         child: Text("Bulgarian"),
         value: 2,
       ),
       PopupMenuItem(
         child: Text("Romanian"),
         value: 3,
       ),
       PopupMenuItem(
         child: Text("Portuguese"),
         value: 4,
       ),
     ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLanguage = Provider.of<AppLanguage>(context);
    directionBloc.getAllDirections();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // centerTitle: true,
          // leading: showMenuLanguage(),
          title: Text(
            AppLocalizations.of(context).translate("principal_title"),
            style: TextStyle(
              fontSize: 25.0
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.delete_forever),
                iconSize: 27.0,
                enableFeedback: true,
                onPressed: () async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete all confirmation"),
                        content:
                           const Text("Are you sure you want to delete all items?"),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text("Delete all items"),
                            onPressed: () {
                              directionBloc.deleteAllDirections();
                              directionBloc.deleteContador();
                              Navigator.of(context).pop(true);
                            },
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                }
                ),
            showMenuLanguage(context),
            IconButton(
              icon: const Icon(Icons.map),
              iconSize: 27.0,
              enableFeedback: true,
              tooltip: "Open all direccion in map",
              onPressed: () async {
                var res = directionBloc.getAllDirection2();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage(res)),
                );
              },
            )
          ],
        ),
        body: StreamBuilder<List<DirectionModel>>(
          stream: directionBloc.directionStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            final directions = snapshot.data;
            if (directions.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_circle_rounded,
                      color: Colors.blue,
                      size: 60.0,
                    ),
                    Text(
                      "No records",
                      style: TextStyle(
                        fontSize: 20.0
                      ),
                    )
                  ],
                ),
              );
            }
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: directions.length,
              itemBuilder: (context, index) => Dismissible(
                key: UniqueKey(),
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.startToEnd) {
                    directionBloc.deleteDirection(directions[index].id);
                  } else {
                    directionBloc.deleteDirection(directions[index].id);
                  }
                },
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Delete confirmation"),
                        content:
                            Text("Are you sure you want to delete this item?"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text("Delete")),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: ListTile(
                  leading: Icon(Icons.directions),
                  title: Text("ID: ${directions[index].directionId}"),
                  subtitle: Text(directions[index].value),
                  trailing: Icon(Icons.arrow_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditPage(
                                directionModel: directions[index],
                              )),
                    );
                  },
                ),
              ),
            );
          },
        ),
        // body: Column(
        //   children: [
        //     SafeArea(child: CustomAppBar()),
        //     Expanded(
        //       child: StreamBuilder<List<DirectionModel>>(
        //         stream: directionBloc.directionStream,
        //         builder: (context, snapshot) {
        //           if (!snapshot.hasData) {
        //             return Center(child: CircularProgressIndicator());
        //           }
        //           final directions = snapshot.data;
        //           if (directions.length == 0) {
        //             return Center(
        //               child: const Text("No records"),
        //             );
        //           }
        //           return ListView.builder(
        //             physics: BouncingScrollPhysics(),
        //             itemCount: directions.length,
        //             itemBuilder: (context, index) => Dismissible(
        //               key: UniqueKey(),
        //               onDismissed: (DismissDirection direction) {
        //                 if (direction == DismissDirection.startToEnd) {
        //                   directionBloc.deleteDirection(directions[index].id);
        //                 } else {
        //                   directionBloc.deleteDirection(directions[index].id);
        //                 }
        //               },
        //               confirmDismiss: (DismissDirection direction) async {
        //                 return await showDialog(
        //                   context: context,
        //                   builder: (BuildContext context) {
        //                     return AlertDialog(
        //                       title: Text("Delete confirmation"),
        //                       content:
        //                       Text("Are you sure you want to delete this item?"),
        //                       actions: <Widget>[
        //                         FlatButton(
        //                             onPressed: () => Navigator.of(context).pop(true),
        //                             child: const Text("Delete")),
        //                         FlatButton(
        //                           onPressed: () => Navigator.of(context).pop(false),
        //                           child: const Text("Cancel"),
        //                         ),
        //                       ],
        //                     );
        //                   },
        //                 );
        //               },
        //               child: ListTile(
        //                 leading: Icon(Icons.directions),
        //                 title: Text("ID: ${directions[index].directionId}"),
        //                 subtitle: Text(directions[index].value),
        //                 trailing: Icon(Icons.arrow_right),
        //                 onTap: () {
        //                   Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => EditPage(
        //                           directionModel: directions[index],
        //                         )),
        //                   );
        //                 },
        //               ),
        //             ),
        //           );
        //         },
        //       ),
        //     )
        //   ],
        // ),


        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.camera_alt),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CameraPage()));
          },
        ),
      ),
    );
  }
}
