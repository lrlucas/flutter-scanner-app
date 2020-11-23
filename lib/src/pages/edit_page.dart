import 'package:flutter/material.dart';
import 'package:scanner_direccions/src/bloc/direction_bloc.dart';
import 'package:scanner_direccions/src/models/DirectionModel.dart';

class EditPage extends StatefulWidget {
  DirectionModel directionModel;

  EditPage({this.directionModel});

  @override
  _EditPageState createState() => _EditPageState(directionModel);
}

class _EditPageState extends State<EditPage> {
  DirectionModel model;
  TextEditingController _controller = new TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();
  final directionBloc = new DirectionsBloc();

  _EditPageState(this.model);

  @override
  void initState() {
    super.initState();
    setState(() {
      _controller.text = this.model.value;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text("Edit Page"),
      ),
      body: Center(
          child: Column(
        children: [
          Divider(),
          Card(
            child: TextField(
              controller: _controller,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              onChanged: (String value) {
                this.model.value = value;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                  child: Text("Save"),
                  onPressed: () async {
                    await directionBloc.updateDirection(model);
                    final snackBar = SnackBar(
                      content: Text('Scanner Edited successful'),
                      duration: Duration(seconds: 3),
                    );
                    globalKey.currentState.showSnackBar(snackBar);
                  })
            ],
          )
        ],
      )),
    );
  }
}
