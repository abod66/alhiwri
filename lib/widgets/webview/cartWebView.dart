
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nyoba/widgets/webview/WebView.dart';

import '../../AppLocalizations.dart';

class cartWebview extends StatefulWidget {
  @override
  _cartWebviewState createState() => _cartWebviewState();
}

class _cartWebviewState extends State<cartWebview> {
  var title;
  String deviceLanguage= Platform.localeName.substring(0,2);
  @override
  Widget build(BuildContext context) {

    return Container(
      child: WebViewScreen(title: AppLocalizations.of(context)
          .translate('cart'),url: deviceLanguage=="ar"?"https://alhiwri.com/ar/cart/":"https://alhiwri.com/cart/",),

    );
  }
}
