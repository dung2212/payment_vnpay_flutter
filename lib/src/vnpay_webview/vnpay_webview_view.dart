import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'vnpay_webview_controller.dart';

class VNPayWebViewView extends StatefulWidget {
  final String redirectUrl;
  final String schemeReturn;
  final List<String> listCheckReturn;
  final Future Function()? onPaymentSuccess;
  final Function(String? code, String? message)? onPaymentError;
  final Function(String? message)? onShowDialogError;

  const VNPayWebViewView({
    super.key,
    required this.redirectUrl,
    required this.schemeReturn,
    this.listCheckReturn = const [],
    this.onPaymentSuccess,
    this.onPaymentError,
    this.onShowDialogError,
  });

  @override
  State<VNPayWebViewView> createState() => _VNPayWebViewWidgetState();
}

class _VNPayWebViewWidgetState extends State<VNPayWebViewView> {
  late VNPayWebViewController controller;

  final GlobalKey webViewKey = GlobalKey();
  final InAppWebViewSettings settings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    mediaPlaybackRequiresUserGesture: false,
    preferredContentMode: UserPreferredContentMode.MOBILE,
    userAgent: Platform.isIOS
        ? "Mozilla/5.0 (iPhone; CPU iPhone OS 15_1_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Mobile/15E148 Safari/604.1"
        : null,
    cacheEnabled: false,
    useHybridComposition: true,
    allowsInlineMediaPlayback: true,
  );

  double progress = 0;

  @override
  void initState() {
    super.initState();
    controller = VNPayWebViewController(
      schemeReturn: widget.schemeReturn,
      listCheckReturn: widget.listCheckReturn,
      onPaymentSuccess: widget.onPaymentSuccess,
      onPaymentError: widget.onPaymentError,
      onShowDialogError: widget.onShowDialogError,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(widget.redirectUrl)),
          initialSettings: settings,
          shouldOverrideUrlLoading: controller.shouldOverrideUrlLoading,
          onLoadStart: controller.onLoadStart,
          onProgressChanged: (_, value) {
            setState(() => progress = value / 100);
          },
        ),
        if (progress < 1.0) LinearProgressIndicator(value: progress),
      ],
    );
  }
}
