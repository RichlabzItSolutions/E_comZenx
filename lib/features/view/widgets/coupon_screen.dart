import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../common/Utils/app_colors.dart';
import '../../../viewmodel/coupon_view_model.dart';

class CouponScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CouponViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Coupons'),
      ),
      body: ListView.builder(
        itemCount: viewModel.coupons.length,
        itemBuilder: (context, index) {
          final coupon = viewModel.coupons[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Container(
                width: 60,
                height: double.infinity, // Ensure the container fills the parent's height
                color: AppColors.primaryColor,
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 3, // Rotates the text 90 degrees
                    child: Container(
                      height: 100, // Increase this height to make the text box taller
                      alignment: Alignment.center,
                      child: Text(
                        '50% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14, // Adjust font size if needed
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              title: Text(coupon.code),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coupon.description),
                  Text('Valid until: ${coupon.validity}'),
                ],
              ),
              trailing: ElevatedButton(
                onPressed: coupon.isUnlocked
                    ? null // Disable button if already unlocked
                    : () {
                  viewModel.applyCoupon(index); // Apply the coupon
                },
                child: Text(coupon.isUnlocked ? 'Applied' : 'Apply'),
              ),
            ),
          );
        },
      ),
    );
  }
}
