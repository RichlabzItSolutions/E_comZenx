import 'package:flutter/material.dart';
import 'package:hygi_health/viewmodel/subcategory_view_model.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/viewmodel/category_view_model.dart';
import 'package:hygi_health/features/view/product_item.dart';

class ProductListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoryViewModel = Provider.of<SubcategoryViewModel>(context);
    return ListView.builder(
      itemCount: categoryViewModel.products.length,
      itemBuilder: (context, index) {
        final product = categoryViewModel.products[index];
        return ProductItem(product: product);
      },
    );
  }
}
