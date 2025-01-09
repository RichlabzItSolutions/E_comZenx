import 'package:flutter/material.dart';
import 'package:hygi_health/data/model/product_model.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/viewmodel/subcategory_view_model.dart';

class HorizontalCategoryList extends StatefulWidget {
  final Function(int) onCategorySelected;
  final int selectedPosition; // Accept selectedPosition from CategoryView

  HorizontalCategoryList({required this.onCategorySelected, required this.selectedPosition});

  @override
  _HorizontalCategoryListState createState() => _HorizontalCategoryListState();
}

class _HorizontalCategoryListState extends State<HorizontalCategoryList> {
  int _selectedIndex = -1; // Initialize to -1 (no selection)

  @override
  void initState() {
    super.initState();

    // Set the initial selected index from the passed position
    _selectedIndex = widget.selectedPosition;

    // Fetch products for the selected category
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_selectedIndex >= 0) {
        _fetchProductsForSelectedCategory();
      }
    });
  }

  // Fetch products for the selected category
  Future<void> _fetchProductsForSelectedCategory() async {
    final subcategoryViewModel = Provider.of<SubcategoryViewModel>(context, listen: false);

    if (subcategoryViewModel.subcategories.isNotEmpty && _selectedIndex >= 0) {
      final selectedCategory = subcategoryViewModel.subcategories[_selectedIndex];

      ProductFilterRequest payload = ProductFilterRequest(
        categoryId: selectedCategory.categoryId.toString(),
        subCategoryId: selectedCategory.subcategoryId.toString(),
        productTitle: '',
        brand: [],
        priceFrom: '',
        priceTo: '',
        colour: [],
        priceSort: '',
      );

      subcategoryViewModel.fetchProducts(payload);
      widget.onCategorySelected(selectedCategory.categoryId); // Notify parent widget
    }
  }

  // Refresh categories on pull-to-refresh
  Future<void> _refreshCategories() async {
    final subcategoryViewModel = Provider.of<SubcategoryViewModel>(context, listen: false);
    await _fetchProductsForSelectedCategory();
  }

  @override
  Widget build(BuildContext context) {
    final subcategoryViewModel = Provider.of<SubcategoryViewModel>(context);
    final categories = subcategoryViewModel.subcategories;
    final isLoading = subcategoryViewModel.isLoading;

    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return Center(child: Text('No categories available'));
    }

    return RefreshIndicator(
      onRefresh: _refreshCategories, // Trigger refresh logic
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (index) {
                final category = categories[index];
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;  // Update the selected index when category is tapped
                    });

                    widget.onCategorySelected(category.categoryId);  // Notify parent widget

                    ProductFilterRequest payload = ProductFilterRequest(
                      categoryId: category.categoryId.toString(),
                      subCategoryId: category.subcategoryId.toString(),
                      productTitle: '',
                      brand: [],
                      priceFrom: '',
                      priceTo: '',
                      colour: [],
                      priceSort: '',
                    );

                    subcategoryViewModel.fetchProducts(payload);  // Fetch products for selected category
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? Colors.green.withOpacity(0.5)
                                    : Colors.grey.withOpacity(0.3),
                                spreadRadius: 4,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: isSelected ? Colors.green : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Center(
                              child: Text(
                                category.subcategoryTitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isSelected ? Colors.green : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(categories.length, (index) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 4,
                width: _selectedIndex == index ? 16 : 8,
                decoration: BoxDecoration(
                  color: _selectedIndex == index ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

