library go_saffe_flutter;

import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:safe_device/safe_device.dart';

class GoSaffeCapture extends StatefulWidget {
  final String captureKey;
  final String user;
  final String type;
  final String endToEndId;
  final Function()? onFinish;
  final Function()? onClose;
  final Function()? onError;
  final Function()? onTimeout;

  const GoSaffeCapture(
    this.captureKey,
    this.user,
    this.type,
    this.endToEndId,
    this.onFinish,
    this.onClose,
    this.onError,
    this.onTimeout, {
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
  late Future<Map<String, bool>?> _safeDeviceInfoFuture;

  @override
  void initState() {
    super.initState();
    _safeDeviceInfoFuture = _checkSafeDevice();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, bool>?>(
        future: _safeDeviceInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
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
                          "capture_key": widget.captureKey,
                          "user_identifier": widget.user,
                          "type": widget.type,
                          "end_to_end_id": widget.endToEndId,
                          "device_context": snapshot.data,
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
                      shouldOverrideUrlLoading:
                          (controller, navigationAction) async {
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

                              if (source == 'go-saffe-capture' &&
                                  event == 'finish') {
                                if (widget.onFinish != null) {
                                  widget.onFinish!();
                                }
                              }

                              if (source == 'go-saffe-capture' &&
                                  event == 'close') {
                                print("close");
                                if (widget.onClose != null) {
                                  widget.onClose!();
                                }
                              }

                              if (source == 'go-saffe-capture' &&
                                  event == 'timeout') {
                                if (widget.onTimeout != null) {
                                  widget.onTimeout!();
                                }
                              }
                            });

                        controller.evaluateJavascript(source: '''
                          window.addEventListener('message', function(event) {
                            if (event.data && event.data.source === 'go-saffe-capture') {
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
                      onUpdateVisitedHistory:
                          (controller, url, androidIsReload) {
                        setState(() {
                          this.url = url.toString();
                          urlController.text = this.url;
                        });
                      },
                      onConsoleMessage: (controller, consoleMessage) {},
                      onReceivedError: (controller, request, error) {
                        if (widget.onError != null) {
                          widget.onError!();
                        }
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
        });
  }
}

Future<Map<String, bool>> _checkSafeDevice() async {
  final isJailBroken = await SafeDevice.isJailBroken;
  final isRealDevice = await SafeDevice.isRealDevice;
  bool isOnExternalStorage = false;

  if (Platform.isAndroid) {
    isOnExternalStorage = await SafeDevice.isOnExternalStorage;
  }

  return {
    "isJailBroken": isJailBroken,
    "isRealDevice": isRealDevice,
    "isOnExternalStorage": isOnExternalStorage,
  };
}
