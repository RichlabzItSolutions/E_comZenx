import 'package:flutter/material.dart';
import 'package:hygi_health/common/Utils/app_colors.dart';
import 'package:hygi_health/common/constants/constans.dart';
import 'package:provider/provider.dart';
import '../../routs/Approuts.dart';
import '../../viewmodel/subcategory_view_model.dart';

class SubcategoryListPage extends StatefulWidget {
  final int categoryId;
  final String searchSubCategory; // Optional parameter to filter subcategories

  SubcategoryListPage({required this.categoryId, required this.searchSubCategory});

  @override
  _SubcategoryListPageState createState() => _SubcategoryListPageState();
}

class _SubcategoryListPageState extends State<SubcategoryListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch subcategories when the page is initialized
    context.read<SubcategoryViewModel>().fetchSubcategories(widget.categoryId, widget.searchSubCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SubcategoryViewModel>(
      builder: (context, viewModel, child) {
        final subcategoryCount = viewModel.isLoading ? null : viewModel.subcategories.length;

        return Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Navigate back
              },
              child: Container(
                padding: EdgeInsets.all(8),
                child: Image.asset(
                  'assets/backarrow.png', // Path to your custom back arrow asset
                  height: 24, // Adjust size as needed
                  width: 24,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sub Category', // Main title
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                if (!viewModel.isLoading)
                  Text(
                    '$subcategoryCount items', // Subtitle with count
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 2.0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          body: viewModel.isLoading
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppConstants.capitalizeFirstLetter(subcategory.subcategoryTitle),
                        style: TextStyle(
                          fontSize: 16.0,
                          color: AppColors.subcategory,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
