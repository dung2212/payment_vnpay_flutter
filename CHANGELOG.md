## 2.0.0

* Dart 3 (`sdk: ^3.6.0`), flutter_inappwebview 6.1.5, app_links 6, url_launcher ^6.1.7.
* Bỏ `flutter_inappwebview` fork và `flutter_intent_scheme_android`; tự tách link `intent://`.
* Bỏ chấp nhận mọi chứng chỉ SSL và tự cấp quyền cho trang web.
* Chỉ báo kết quả một lần; bỏ qua URL trả về chưa có `vnp_ResponseCode`.
* Thêm `VNPayResponseCode`, export `VNPayWebViewController`.

## 0.0.1

* Bản đầu tiên.
