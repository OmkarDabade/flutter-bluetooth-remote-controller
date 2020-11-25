import 'package:flutter/material.dart';

import 'view/rcCar.dart';
import 'view/bluetooth.dart';

void main(){
  runApp(
    MaterialApp(
      initialRoute: "/",
      routes: {
        "/":(context) => HomePage(),
        "/bluetooth":(context) => Hello()
      },
    )
  );
}