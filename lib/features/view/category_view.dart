import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_strings.dart';
import 'package:provider/provider.dart';
import 'package:hygi_health/features/view/widgets/horizontal_category_list.dart';
import 'package:hygi_health/features/view/widgets/product_list_view.dart'; // Use for ProductListView
import 'package:hygi_health/viewmodel/subcategory_view_model.dart'; // SubcategoryViewModel
import 'package:hygi_health/features/view/BaseScreen.dart';

class CategoryView extends StatefulWidget {
  final int categoryId;
  final int position; // Add position parameter

  // Constructor to accept categoryId and position dynamically
  CategoryView({required this.categoryId, required this.position});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late int currentCategoryId;
  late String searchSubCategory;

  @override
  void initState() {
    super.initState();
    // Initialize the current categoryId with the one passed from the constructor
    currentCategoryId = widget.categoryId;
    searchSubCategory = ""; // Initialize the search term
    // Fetch subcategories when the widget is initialized
    _fetchSubcategories();
  }

  @override
  void didUpdateWidget(covariant CategoryView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the categoryId changes, fetch subcategories for the new category
    if (widget.categoryId != oldWidget.categoryId) {
      setState(() {
        currentCategoryId = widget.categoryId;
      });
      _fetchSubcategories();
    }
  }

  void _fetchSubcategories() {
    final subcategoryViewModel = Provider.of<SubcategoryViewModel>(context, listen: false);
    // Fetch subcategories without using the search term
    subcategoryViewModel.fetchSubcategories(currentCategoryId, "");
  }

  @override
  Widget build(BuildContext context) {
    final subcategoryViewModel = Provider.of<SubcategoryViewModel>(context);

    return BaseScreen(
      title: AppStrings.allCategories,
      cartItemCount: 3, // Set the number of cart items
      showCartIcon: true,
      showShareIcon: false,
      child: Container(
        color: Colors.white, // Apply white background
        child: Column(
          children: [
            const SizedBox(height: 16), // Add spacing
            HorizontalCategoryList(
              onCategorySelected: (selectedCategoryId) {
                setState(() {
                  currentCategoryId = selectedCategoryId;
                });
                // Fetch subcategories for the selected category
                _fetchSubcategories();
              },
              selectedPosition: widget.position, // Pass the position to HorizontalCategoryList
            ),
            const SizedBox(height: 16), // Add spacing
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search products", // Placeholder text for search
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    searchSubCategory = value; // Update the search term
                  });
                  // Fetch products or filter based on the search term (handled in ProductListView)
                },
              ),
            ),
            const SizedBox(height: 16), // Add spacing
            Expanded(
              child: ProductListView(searchTerm: searchSubCategory), // Pass the search term to ProductListView
            ),
          ],
        ),
      ),
    );
  }
}
