import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailViewScreen extends StatefulWidget {
  final String newsUrl;

  const DetailViewScreen({super.key, required this.newsUrl});

  @override
  State<DetailViewScreen> createState() => _DetailViewScreenState();
}

class _DetailViewScreenState extends State<DetailViewScreen> {
  late String sanitizedUrl;
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true; // Track loading state
  bool hasError = false; // Track error state

  @override
  void initState() {
    super.initState();

    // Initialize the WebView and sanitize the URL
    sanitizedUrl = widget.newsUrl.trim();
    if (sanitizedUrl.isEmpty || (!sanitizedUrl.startsWith("http") && !sanitizedUrl.startsWith("https"))) {
      hasError = true; // Invalid URL
    } else if (sanitizedUrl.startsWith("http:")) {
      sanitizedUrl = sanitizedUrl.replaceFirst("http:", "https:");
    }
  }

  // Retry the WebView if there's an error
  void _retryLoading() {
    setState(() {
      hasError = false; // Reset error state
      isLoading = true; // Start loading again
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Snack"),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: hasError
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Invalid URL. Please check the news source.",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _retryLoading,
                    child: Text("Retry"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                WebView(
                  initialUrl: sanitizedUrl,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                  },
                  onPageStarted: (_) {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onPageFinished: (_) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onWebResourceError: (error) {
                    setState(() {
                      hasError = true;
                    });
                  },
                ),
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
              ],
            ),
      floatingActionButton: FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () async {
                final controller = snapshot.data!;
                if (await controller.canGoBack()) {
                  await controller.goBack();
                }
              },
              child: const Icon(Icons.arrow_back),
            );
          }
          return const SizedBox(); // Return empty widget if the controller isn't ready
        },
      ),
    );
  }
}
