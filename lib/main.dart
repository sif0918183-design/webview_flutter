import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // إعداد OneSignal
  OneSignal.shared.setAppId("e542557c-fbed-4ca6-96fa-0b37e0d21490");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});
  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://driver.zoonasd.com"));

    // عند الضغط على إشعار OneSignal
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      final additionalData = result.notification.additionalData;
      if (additionalData?['type'] == 'ride_request') {
        _controller.loadRequest(Uri.parse("https://driver.zoonasd.com/accept-ride.html"));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}