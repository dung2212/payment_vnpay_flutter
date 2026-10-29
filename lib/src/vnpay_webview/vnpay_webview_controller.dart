import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import '../intent_url.dart';
import '../vnpay_response_code.dart';

class VNPayWebViewController {
  /// Scheme app nhận kết quả, vd `abin://`.
  final String schemeReturn;

  /// Chuỗi nhận diện trang web trả về của server (vnp_ReturnUrl), vd `"vnpay/return"`.
  final List<String> listCheckReturn;

  /// Gọi khi `vnp_ResponseCode == "00"`. App nên kiểm lại trạng thái đơn trên server,
  /// vì tham số trên URL có thể bị sửa.
  final Future Function()? onPaymentSuccess;
  final Function(String? code, String? message)? onPaymentError;
  final Function(String? message)? onShowDialogError;

  VNPayWebViewController({
    required this.schemeReturn,
    this.listCheckReturn = const [],
    this.onPaymentSuccess,
    this.onPaymentError,
    this.onShowDialogError,
  }) {
    _initAppLink();
  }

  static const _webSchemes = ["http", "https", "file", "chrome", "data", "javascript", "about"];
  static const _errorOpenApp = "Không thể thanh toán bằng phương thức này";

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// Kết quả chỉ báo một lần: app link và WebView có thể cùng nhận URL trả về.
  bool _isHandled = false;

  Future<NavigationActionPolicy?> shouldOverrideUrlLoading(
      InAppWebViewController controller, NavigationAction navigationAction) async {
    final uri = navigationAction.request.url;
    if (uri == null) return NavigationActionPolicy.ALLOW;
    final url = uri.toString();
    debugPrint("VNPay: $url");

    if (isSchemeReturn(url)) {
      _onCheckErrorCode(uri);
      return NavigationActionPolicy.CANCEL;
    }
    if (!_webSchemes.contains(uri.scheme)) {
      await _openExternalApp(url);
      return NavigationActionPolicy.CANCEL;
    }
    if (isReturnUrl(url)) {
      _onCheckErrorCode(uri);
    }
    return NavigationActionPolicy.ALLOW;
  }

  /// Bắt URL trả về khi server redirect (Android không phải lúc nào cũng gọi shouldOverrideUrlLoading).
  void onLoadStart(InAppWebViewController controller, WebUri? uri) {
    if (uri != null && isReturnUrl(uri.toString())) {
      _onCheckErrorCode(uri);
    }
  }

  bool isSchemeReturn(String url) => url.startsWith(schemeReturn);

  bool isReturnUrl(String url) => listCheckReturn.any(url.contains);

  Future<void> _openExternalApp(String url) async {
    final candidates = Platform.isAndroid && url.startsWith("intent://")
        ? (IntentUrl.tryParse(url)?.candidates ?? const <String>[])
        : [url];
    for (final item in candidates) {
      if (await _launchExternal(item)) return;
    }
    onShowDialogError?.call(_errorOpenApp);
  }

  static Future<bool> _launchExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("VNPay launch $url: $e");
      return false;
    }
  }

  void _onCheckErrorCode(Uri uri) {
    final responseCode = uri.queryParameters["vnp_ResponseCode"];
    // URL chưa có mã (trang trung gian) thì chờ URL tiếp theo.
    if (responseCode == null || _isHandled) return;
    _isHandled = true;
    if (responseCode == VNPayResponseCode.success) {
      onPaymentSuccess?.call();
    } else {
      onPaymentError?.call(responseCode, VNPayResponseCode.messageOf(responseCode));
    }
  }

  void _initAppLink() {
    _sub = _appLinks.uriLinkStream.listen((uri) {
      if (isSchemeReturn(uri.toString())) _onCheckErrorCode(uri);
    });
  }

  void dispose() {
    _sub?.cancel();
  }
}
