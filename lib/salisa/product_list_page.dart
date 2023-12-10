import 'package:flutter/material.dart';
import 'package:scrapyart_home/salisa/model/product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<String> categories = [
    'Food',
    'Fruits',
    'Sports',
    'Vehicle',
  ];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    final filterProducts = productList.where((product) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(product.category);
    }).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Record using Chip'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(16.0),
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: 15.0,
              children: categories
                  .map((category) => FilterChip(
                        selected: selectedCategories.contains(category),
                        label: Text(category),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedCategories.add(category);
                            } else {
                              selectedCategories.remove(category);
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 10.0, // Spacing between rows
              ),
              itemCount: filterProducts.length,
              itemBuilder: (context, index) {
                final product = filterProducts[index];
                return Card(
                  elevation: 8.0,
                  margin: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 5,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      title: Text(
                        product.name, // Display the product name
                        style: const TextStyle(
                          color: Colors.black, // Changed text color to black
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        product.category, // Display the product category
                        style: const TextStyle(
                          color: Colors.black, // Changed text color to black
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Add your other content here
        ],
      ),
    );
  }
}
