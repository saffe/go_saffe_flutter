library go_saffe_flutter;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Go Saffe Capture Widget.
class GoSaffeCapture extends StatefulWidget {
  final String apiKey;
  final String identifier;
  final String type;
  final String endToEndId;

  const GoSaffeCapture(this.apiKey, this.identifier, this.type, this.endToEndId,
      {super.key});

  @override
  State<GoSaffeCapture> createState() => _CaptureState();
}

class _CaptureState extends State<GoSaffeCapture> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  String url = "";
  bool isLoading = true;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      Expanded(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(
                url: WebUri("https://xl7coszbs3ct.share.zrok.io/v0/capture"),
                method: "POST",
                body: Uint8List.fromList(utf8.encode(jsonEncode({
                  "api_key": widget.apiKey,
                  "user_identifier": widget.identifier,
                  "type": widget.type,
                  "end_to_end_id": widget.endToEndId,
                }))),
                headers: {
                  'Content-Type': 'application/x-www-form-urlencoded',
                },
              ),
              initialSettings: settings,
              onWebViewCreated: (controller) {
                webViewController = controller;
                controller.addJavaScriptHandler(
                    handlerName: 'handler',
                    callback: (args) {
                      print("aqui");
                    });
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onProgressChanged: (controller, progress) {
                if (progress >= 100) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                  print(consoleMessage)
              },
            ),
            if (isLoading)
              const Center(
                  child: CircularProgressIndicator(color: Colors.cyan)),
          ],
        ),
      ),
    ])));
  }
}
