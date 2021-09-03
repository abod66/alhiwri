import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:nyoba/pages/home/HomeScreen.dart';
import 'package:nyoba/pages/home/LobbyScreen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final url;
  final String title;

  WebViewScreen({Key key, this.url, this.title}) : super(key: key);
  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.title,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              WebView(
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish) {
                    setState(() {
                      isLoading = false;
                    });

                  }),
              isLoading ?  SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
      child: Center(
        child: LoadingBouncingGrid.circle(
          borderColor: Colors.red,
          borderSize: 3.0,
          size: 30.0,
          backgroundColor: Colors.white,
        ),
      )): Stack(),
            ],
          ),
        ));
  }
}
