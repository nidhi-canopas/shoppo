import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var categoriesData;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 36.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
      final response = await http
          .get(Uri.parse("https://fakestoreapi.com/products/categories"));
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
