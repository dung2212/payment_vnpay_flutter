/// Tách link `intent://` của Android thành các link mở được bằng url_launcher.
///
/// Định dạng: `intent://HOST/PATH?QUERY#Intent;scheme=SCHEME;package=PKG;S.browser_fallback_url=URL;end`
class IntentUrl {
  /// Link mở thẳng app, dạng `SCHEME://HOST/PATH?QUERY`. Null khi intent không có scheme.
  final String? appUrl;

  /// Link dự phòng khi máy chưa cài app.
  final String? fallbackUrl;

  /// Package của app ngân hàng, dùng để mở trang cài đặt trên Play Store.
  final String? package;

  const IntentUrl({this.appUrl, this.fallbackUrl, this.package});

  String? get storeUrl => package == null ? null : "market://details?id=$package";

  /// Các link thử lần lượt: mở app → link dự phòng → Play Store.
  List<String> get candidates => [appUrl, fallbackUrl, storeUrl].whereType<String>().toList();

  static IntentUrl? tryParse(String url) {
    if (!url.startsWith("intent://")) return null;
    final hashIndex = url.indexOf("#Intent;");
    final body = hashIndex == -1 ? url.substring("intent://".length) : url.substring("intent://".length, hashIndex);

    final params = <String, String>{};
    if (hashIndex != -1) {
      for (final part in url.substring(hashIndex + "#Intent;".length).split(";")) {
        final eq = part.indexOf("=");
        if (eq <= 0) continue;
        params[part.substring(0, eq)] = part.substring(eq + 1);
      }
    }

    final scheme = params["scheme"];
    final fallback = params["S.browser_fallback_url"];
    return IntentUrl(
      appUrl: (scheme == null || scheme.isEmpty) ? null : "$scheme://$body",
      fallbackUrl: (fallback == null || fallback.isEmpty) ? null : Uri.decodeComponent(fallback),
      package: (params["package"]?.isEmpty ?? true) ? null : params["package"],
    );
  }
}
