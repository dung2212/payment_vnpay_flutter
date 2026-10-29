import 'package:flutter_test/flutter_test.dart';
import 'package:payment_vnpay_flutter/payment_vnpay_flutter.dart';
import 'package:payment_vnpay_flutter/src/intent_url.dart';

void main() {
  group('IntentUrl', () {
    test('tách scheme, package và link dự phòng', () {
      final intent = IntentUrl.tryParse(
          'intent://pay?token=abc#Intent;scheme=vietcombankmobile;package=com.VCB;S.browser_fallback_url=https%3A%2F%2Fvcb.vn%2Fpay;end');
      expect(intent, isNotNull);
      expect(intent!.appUrl, 'vietcombankmobile://pay?token=abc');
      expect(intent.fallbackUrl, 'https://vcb.vn/pay');
      expect(intent.storeUrl, 'market://details?id=com.VCB');
      expect(intent.candidates, ['vietcombankmobile://pay?token=abc', 'https://vcb.vn/pay', 'market://details?id=com.VCB']);
    });

    test('intent không có scheme thì chỉ còn Play Store', () {
      final intent = IntentUrl.tryParse('intent://pay#Intent;package=com.mbmobile;end');
      expect(intent!.candidates, ['market://details?id=com.mbmobile']);
    });

    test('không phải intent thì trả null', () {
      expect(IntentUrl.tryParse('https://sandbox.vnpayment.vn'), isNull);
    });
  });

  test('VNPayResponseCode.messageOf', () {
    expect(VNPayResponseCode.messageOf('24'), 'Khách hàng hủy giao dịch.');
    expect(VNPayResponseCode.messageOf('xx'), 'Lỗi không xác định');
  });
}
