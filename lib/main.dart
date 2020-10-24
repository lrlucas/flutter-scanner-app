import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scanner app',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Scanner app'),
        ),
        body: Center(
          child:ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ListTile(
                leading: Icon(Icons.directions),
                title: Text("direccion 1"),
                subtitle: Text("subtitle text"),
                trailing: Icon(Icons.arrow_right),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.directions),
                title: Text("direccion 2"),
                subtitle: Text("subtitle text"),
                trailing: Icon(Icons.arrow_right),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.directions),
                title: Text("direccion 2"),
                subtitle: Text("subtitle text"),
                trailing: Icon(Icons.arrow_right),
                onTap: () {},
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.camera_alt),
          onPressed: () {
            // Add your onPressed code here!
          },
        ),
      ),
    );
  }

}
