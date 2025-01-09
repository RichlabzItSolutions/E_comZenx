import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/coupon_model.dart';

class CouponViewModel with ChangeNotifier {
  List<CouponModel> _coupons = [
    CouponModel(
        code: 'WELCOME200',
        description: 'Add items worth Rs.50 more to unlock',
        validity: 'August 15, 2024',
        isUnlocked: false),
    CouponModel(
        code: 'WELCOME200',
        description: 'Add items worth Rs.50 more to unlock',
        validity: 'August 15, 2024',
        isUnlocked: false),
    CouponModel(
        code: 'WELCOME200',
        description: 'Add items worth Rs.50 more to unlock',
        validity: 'August 15, 2024',
        isUnlocked: false),
    CouponModel(
        code: 'WELCOME200',
        description: 'Add items worth Rs.50 more to unlock',
        validity: 'August 15, 2024',
        isUnlocked: false),
  ];
  List<CouponModel> get coupons => _coupons;
  void applyCoupon(int index) {
    _coupons[index] = CouponModel(
      code: _coupons[index].code,
      description: _coupons[index].description,
      validity: _coupons[index].validity,
      isUnlocked: true,
    );
    notifyListeners();
  }
}