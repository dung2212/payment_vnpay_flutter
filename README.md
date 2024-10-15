Show VNPay Payment
## Features

Package support Open Scheme app to app Bank


## Getting started
## iOS
Add white list to Info.Plist
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

Add scheme call back to Info.Plist
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


## Android
Add scheme call back
<data
android:scheme="<scheme_name>"
android:host="" />

## Usage

VNPayWebViewView(
redirectUrl: widget.redirectUrl,
schemeReturn: '<scheme_name>://',
listCheckReturn: ["don-hang/chi-tiet"],
onPaymentSuccess: () async {
Get.offNamedUntil(
PaymentResultPage.routeName,
(route) {
if (route.settings.name == WebViewPaymentPage.routeName) {
return false;
}
if (route.settings.name == PaymentPage.routeName) {
return false;
}
return true;
},
arguments: PaymentResultPage.arguments(
transactionCode: widget.transactionCode,
orderCode: widget.orderCode,
),
);
},
onShowDialogError: (message){
DialogUtil.showDialogMessage(message);
},
onPaymentError: (code, message) {
Get.offNamedUntil(
PaymentFailPage.routeName,
(route) {
if (route.settings.name == WebViewPaymentPage.routeName) {
return false;
}
if (route.settings.name == PaymentPage.routeName) {
return false;
}
return true;
},
arguments: PaymentFailPage.arguments(note: message ??""),
);
},
)

```dart
const like = 'sample';
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
