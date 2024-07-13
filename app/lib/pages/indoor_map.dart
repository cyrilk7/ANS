import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class IndoorMap extends StatefulWidget {
  final String mapId;
  final String startSpace;
  final String endSpace;

  const IndoorMap({super.key, required this.mapId, required this.startSpace, required this.endSpace});

  @override
  State<IndoorMap> createState() => _IndoorMapState();
}

class _IndoorMapState extends State<IndoorMap> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // You can update a loading bar here if needed
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    String fileText =
        await rootBundle.loadString('assets/html/mappedin_map.html');
    String modifiedHtml = fileText
        .replaceAll('{{MAP_ID}}', widget.mapId)
        .replaceAll('{{START_SPACE}}', widget.startSpace)
        .replaceAll('{{END_SPACE}}', widget.endSpace);

    _controller.loadRequest(Uri.dataFromString(
      modifiedHtml,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
