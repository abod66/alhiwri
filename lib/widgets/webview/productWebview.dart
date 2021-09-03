import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:nyoba/widgets/webview/WebView.dart';
import 'package:webview_flutter/webview_flutter.dart';

class productWebview extends StatefulWidget {
  final id;

  const productWebview({Key key, this.id}) : super(key: key);
  @override
  _productWebviewState createState() => _productWebviewState();
}

class _productWebviewState extends State<productWebview> {
  var id;

  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    String deviceLanguage = Platform.localeName.substring(0, 2);
    id = widget.id;
    num _stackToView=0;
    return Scaffold(
        appBar: AppBar(title: Text("ALHIWRI",style: TextStyle(color: Colors.white),),centerTitle: true,),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              WebView(
                  initialUrl: deviceLanguage == "ar"
                      ? "https://alhiwri.com/ar/product/$id"
                      : "https://alhiwri.com/product/$id",
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
