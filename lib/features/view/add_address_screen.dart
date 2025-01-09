import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hygi_health/features/view/BaseScreen.dart';
import 'package:hygi_health/features/view/widgets/addresss_form_widget.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/AddressViewModel.dart';

class AddAddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Add New Address',
      cartItemCount: 3, // Example cart item count
      showCartIcon: false,
      showShareIcon: false,
      // Providing a Scaffold as the child
      child: Scaffold(
        body: ChangeNotifierProvider(
          create: (_) => AddressViewModel(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AddressFormWidget(),
          ),
        ),
      ),
    );
  }
}
