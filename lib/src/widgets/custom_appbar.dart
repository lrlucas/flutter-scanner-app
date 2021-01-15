import 'package:flutter/material.dart';
import 'package:scanner_direccions/src/bloc/direction_bloc.dart';
import 'package:scanner_direccions/src/pages/map_page.dart';
import 'package:scanner_direccions/src/widgets/popup_menu_button.dart';


class CustomAppBar extends StatelessWidget {
  final directionBloc = new DirectionsBloc();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        children: [
          // IconButton(
          //     icon: Icon(Icons.translate),
          //     iconSize: 30.0,
          //     onPressed: () {}
          // ),
          // Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(13.0, 0, 0, 0),
            child: Text(
              "Scanners",

              style: TextStyle(
                  fontSize: 28.0
              ),
            ),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.delete_forever),
            iconSize: 30.0,
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
            },
          ),
          CustomPopUpMenuButton(),
          IconButton(
            icon: Icon(Icons.map),
            iconSize: 30.0,
            tooltip: "Open all direction in map",
            enableFeedback: true,
              onPressed: () async {
                var res = directionBloc.getAllDirection2();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage(res)),
                );
              }
          )
        ],
      ),
    );
  }
}