import 'package:flutter/material.dart';


class CustomPopUpMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      initialValue: 0,
      tooltip: "Change Language",
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      icon: Icon(Icons.language, semanticLabel: "Change language"),
      onCanceled: () {
        print("OnCanceled");
      },
      onSelected: (int value) {
        print("onSelected $value");
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
}
