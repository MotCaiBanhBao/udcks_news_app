import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UdckDetailScreen extends StatefulWidget {
  @override
  UdckDetailScreenState createState() => UdckDetailScreenState();
}

class UdckDetailScreenState extends State<UdckDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return const WebView(
      initialUrl: 'http://kontum.udn.vn/',
    );
  }
}
