import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>{
  var categoriesData;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Categories')),
      body: ListView.builder(
    itemCount: categoriesData == null ? 0 : categoriesData.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(categoriesData[index]),
          ),
        );
      },
    ),
    );
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
          Uri.parse("https://fakestoreapi.com/products/categories"));
      setState(() {
        categoriesData = json.decode(response.body);
      });
    } catch (e) {
      setState(() {
        categoriesData = [];
      });
    }
  }

}

