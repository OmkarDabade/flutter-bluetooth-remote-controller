import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CameraComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: "http://192.168.43.165/",
      javascriptMode: JavascriptMode.unrestricted,
      
    );
  }
}