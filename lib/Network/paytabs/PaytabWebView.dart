import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreen extends StatefulWidget {
  @override
  HelpScreenState createState() {
    return HelpScreenState();
  }
}

class HelpScreenState extends State<HelpScreen> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help')),
      body: WebView(
        onPageFinished: (_) async {
          if (await _controller.currentUrl() ==
              "https://cameo.deliveryventure.com/api/gigs/test") readJS();
        },
        navigationDelegate: (request) {
          if (request.url == "https://cameo.deliveryventure.com/") {
            return NavigationDecision.prevent;
          } else {
            return NavigationDecision.navigate;
          }
        },
        initialUrl: 'about:blank',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller = webViewController;
          _loadHtmlFromAssets();
        },
      ),
    );
  }

  _loadHtmlFromAssets() async {
    String fileText =
        await rootBundle.loadString('assets/animations/help.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  void readJS() async {
    String html = await _controller.evaluateJavascript(
        "window.document.getElementsByTagName('html')[0].innerHTML;");
    print(html);
    int startIndex = html.indexOf('{');
    int endIndex = html.lastIndexOf('}');
    String trimedResponse = html.substring(startIndex, endIndex + 1);
    trimedResponse = trimedResponse.replaceAll(new RegExp(r'\\'), "");
    var response = jsonDecode(trimedResponse);
    print(response["message"]["token"]);

    http.Response res = await http
        .post("https://secure-global.paytabs.com/payment/request", body: {
      "profile_id": "63208",
      "tran_type": "sale",
      "tran_class": "ecom",
      "cart_id": "2ca6efa1-efa3-4012-905b-11196cef5bd2",
      "cart_description": "Dummy Order 123456",
      "cart_currency": "USD",
      "cart_amount": "4700",
      "callback": "https://cameo.deliveryventure.com/",
      "return": "https://cameo.deliveryventure.com/",
      "payment_token": response["message"]["token"].toString(),
      "customer_details": {
        "name": "John Smith",
        "email": "jsmith@gmail.com",
        "street1": "404, 11th st, void",
        "city": "New York",
        "state": "NY",
        "country": "USA",
        "ip": "91.74.146.168"
      }
    });
    print(res);
  }
}
