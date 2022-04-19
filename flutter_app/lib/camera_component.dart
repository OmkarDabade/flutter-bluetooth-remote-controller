import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CameraComponent extends StatelessWidget {
  const CameraComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WebView(
      initialUrl: "http://192.168.43.165/",
      javascriptMode: JavascriptMode.unrestricted,
    );
  }
}
