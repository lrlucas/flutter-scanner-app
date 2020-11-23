import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner_direccions/src/bloc/direction_bloc.dart';
import 'package:scanner_direccions/src/models/DirectionModel.dart';
import 'package:scanner_direccions/src/models/DirectionsModel.dart';
import 'package:scanner_direccions/src/pages/camera_page.dart';
import 'package:scanner_direccions/src/pages/edit_page.dart';
// import 'package:scanner_direccions/src/providers/db_provider.dart';

class HomePage extends StatefulWidget {
  final DirectionModel directionModel;

  const HomePage({this.directionModel});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final directionBloc = new DirectionsBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    directionBloc.getAllDirections();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Scanner app'),
          actions: [
            IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Delete all confirmation"),
                        content:
                            Text("Are you sure you want to delete all items?"),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text("Delete all items"),
                            onPressed: () {
                              directionBloc.deleteAllDirections();
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
                })
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
                child: Text("No records"),
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
                  title: Text(directions[index].value),
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

        // body: Center(
        //   child: ListView(
        //     physics: BouncingScrollPhysics(),
        //     children: [
        //       ListTile(
        //         leading: Icon(Icons.directions),
        //         title: Text("direccion 1"),
        //         subtitle: Text("subtitle text"),
        //         trailing: Icon(Icons.arrow_right),
        //         onTap: () {
        //           Map<String, dynamic> map = {
        //             "id": 1,
        //             'value': 'texto escaneado aaaa'
        //           };
        //           DirectionModel model = new DirectionModel.fromJson(map);
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => EditPage(
        //                       directionModel: model,
        //                     )),
        //           );
        //         },
        //       ),
        //     ],
        //   ),
        // ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => CameraPage()));
          },
        ),
      ),
    );
  }
}
