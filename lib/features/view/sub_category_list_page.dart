import 'package:flutter/material.dart';
import 'package:hygi_health/features/view/BaseScreen.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/subcategory_view_model.dart';
import 'ProductScreen.dart'; // Import the Product Screen

class SubcategoryListPage extends StatefulWidget {
  final int categoryId;

  // Constructor to accept categoryId
  SubcategoryListPage({required this.categoryId});

  @override
  _SubcategoryListPageState createState() => _SubcategoryListPageState();
}

class _SubcategoryListPageState extends State<SubcategoryListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch subcategories when the page is initialized
    context.read<SubcategoryViewModel>().fetchSubcategories(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Sub Category',
      cartItemCount: 3, // Set the number of cart items
      showCartIcon: true,
      showShareIcon: false,
      child: Container(
        color: Colors.white, // Apply white background
        child: Consumer<SubcategoryViewModel>(
          builder: (context, viewModel, child) {
            return viewModel.isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : viewModel.subcategories.isEmpty
                ? Center(child: Text('No Subcategories Found')) // Show no subcategories found message
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: viewModel.subcategories.length,
              itemBuilder: (context, index) {
                final subcategory = viewModel.subcategories[index];

                return GestureDetector(
                  onTap: () {
                    // Navigate to ProductScreen and pass the subcategory ID
                    Navigator.pushNamed(
                      context,
                      AppRoutes.CategoryViewAll,
                      arguments: {
                        'categoryId': subcategory.categoryId, // Pass categoryId
                        'position': index, // Pass position (index of selected category)
                      },
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                      children: [
                        // Display subcategory title aligned to the left
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between title and arrow
                          children: [
                            Text(
                              subcategory.subcategoryTitle,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.grey.shade600, // Back arrow icon on the right
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
