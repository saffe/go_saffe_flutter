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
  final Function()? onFinish;
  final Function()? onClose;

  const GoSaffeCapture(
    this.apiKey,
    this.identifier,
    this.type,
    this.endToEndId,
    this.onFinish,
    this.onClose, {
    super.key,
  });

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
                url: WebUri("https://go.saffe.ai/v0/capture"),
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

                controller.addJavaScriptHandler(
                    handlerName: 'receiveMessage',
                    callback: (args) {
                      final source = args[0]['source'];
                      final event = args[0]['payload']['event'];

                      if (source == 'go-saffe-capture' && event == 'finish') {
                        if (widget.onFinish != null) {
                          widget.onFinish!();
                        }
                      }

                      if (source == 'go-saffe-capture' && event == 'close') {
                        if (widget.onClose != null) {
                          widget.onClose!();
                        }
                      }
                    });

                controller.evaluateJavascript(source: '''
                  window.addEventListener('message', function(event) {
                    // Verifica se a mensagem é do tipo esperado
                    if (event.data && event.data.source === 'go-saffe-capture' && event.data.payload.event === 'finish') {
                      // Envia a mensagem para o callback do Flutter
                      window.flutter_inappwebview.callHandler('receiveMessage', event.data);
                    }
                  });
                ''');
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
              onConsoleMessage: (controller, consoleMessage) {},
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
