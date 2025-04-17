import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' show InAppWebView, InAppWebViewController, InAppWebViewSettings, URLRequest, WebUri;

class pusWeb extends StatefulWidget {
  final String url; // URL, который нужно загрузить в WebView.

  pusWeb({required this.url}); // Конструктор для передачи URL.

  @override
  State<pusWeb> createState() => _pusWebState();
}

class _pusWebState extends State<pusWeb> {
  late InAppWebViewController _webViewController; // Контроллер WebView.
  double _progress = 0; // Прогресс загрузки страницы.

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children: [
          InAppWebView(
            initialSettings: InAppWebViewSettings(

              javaScriptEnabled: true, // Enable JavaScript
              javaScriptCanOpenWindowsAutomatically: true, // Allow JS to open new windows
            ),
            initialUrlRequest: URLRequest(url: WebUri(widget.url)), // URL для загрузки.
            onWebViewCreated: (controller) {
              _webViewController = controller; // Инициализация контроллера.
            },
            onLoadStart: (controller, url) {
              setState(() {
                _progress = 0; // При начале загрузки сбрасываем прогресс.
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _progress = 1; // Загрузка завершена.
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100; // Обновление прогресса загрузки.
              });
            },
          ),
          if (_progress < 1) // Показываем индикатор загрузки, пока страница не загрузится.
            LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}