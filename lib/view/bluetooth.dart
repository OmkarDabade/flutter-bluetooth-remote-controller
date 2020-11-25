import 'package:flutter/material.dart';

class Hello extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Bluetooth Connection"),
          backgroundColor: Color(0XFF2e2e2e),
        ),
        body: new Center(
          child: new Text(
            "Merhaba Flutter2",

          ),
        )
    );
  }
}