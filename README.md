Show VNPay Payment
## Features

Package support Open Scheme app to app Bank


## Getting started
## iOS
Add white list to Info.Plist
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>momo</string>
    <string>ncbsmartbanking</string>
    <string>ivbmobilebanking</string>
    <string>abbankmobile</string>
    <string>scbmobilebanking</string>
    <string>vietinbankmobile</string>
    <string>bidvsmartbanking</string>
    <string>agribankmobile</string>
    <string>vietcombankmobile</string>
    <string>f5smartaccount</string>
    <string>vcbpaymobile</string>
    <string>vietbankmobilebanking</string>
    <string>eximbankmobile</string>
    <string>qpaymobile</string>
    <string>acbapp</string>
    <string>viettelpay</string>
    <string>vabmobilebanking</string>
    <string>msbmobile</string>
    <string>vibmobile</string>
    <string>qpaymobile</string>
    <string>shbmobile</string>
    <string>shbmobile</string>
    <string>oceanbankmobilebanking</string>
    <string>namabankmobile</string>
    <string>baovietmobile</string>
    <string>hdbankmobile</string>
    <string>saigonbankmobilebanking</string>
    <string>kienlongbankmobilebanking</string>
    <string>bidcvnmobile</string>
    <string>vivietvnpay</string>
    <string>com.mobile.vtcpay</string>
</array>
```
Add scheme call back to Info.Plist
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string></string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string><scheme_name></string>
        </array>
    </dict>
</array>
```

## Android
Add scheme call back in `<activity android:name=".MainActivity">` of AndroidManifest.xml
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="<scheme_name>" />
</intent-filter>
```
Link `intent://` của ngân hàng được tách thành `scheme://…` → `browser_fallback_url` → Play Store
(không cần package `flutter_intent_scheme_android` nữa).

## Usage
```dart
VNPayWebViewView(
    redirectUrl: paymentUrl, // link VNPay server trả về
    schemeReturn: '<scheme_name>://',
    listCheckReturn: ["vnpay/return"], // chuỗi nhận diện trang vnp_ReturnUrl
    onPaymentSuccess: () async {
        // vnp_ResponseCode == 00 — vẫn phải kiểm lại trạng thái đơn trên server
    },
    onPaymentError: (code, message) {
        // code: vnp_ResponseCode, message: VNPayResponseCode.messageOf(code)
    },
    onShowDialogError: (message) {
        // không mở được app ngân hàng
    },
)
```

## Version
- `2.x` (nhánh `v2`): Dart 3, flutter_inappwebview 6, app_links 6.
- `0.0.1` (nhánh `main`): Dart 2.
