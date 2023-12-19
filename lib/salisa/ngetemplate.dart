// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:scrapyart_home/salisa/model/template.dart';
import 'package:scrapyart_home/salisa/ngetemplate/template_board.dart';

class NgeTemplate extends StatefulWidget {
  const NgeTemplate({super.key});

  @override
  State<NgeTemplate> createState() => NgeTemplateState();
}

class NgeTemplateState extends State<NgeTemplate> {
  final List<String> categories = [
    'vintage',
    'animals',
    'modren',
  ];

  List<String> selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    /// ambil templateList dari template.dart
    final filterTemplates = templateList.where((product) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(product.category);
    }).toList();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('NgeTemplate',
              style: Theme.of(context).textTheme.titleLarge),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
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
                itemCount: filterTemplates.length,
                itemBuilder: (context, index) {
                  final product = filterTemplates[index];
                  return Card(
                    elevation: 8.0,
                    margin: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TemplateBoard(
                            assetImage: product.image,
                            id: product.id,
                            placeholder: product.placeholder,
                          ),
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage(product.image),
                              fit: BoxFit.cover),
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: 5,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
