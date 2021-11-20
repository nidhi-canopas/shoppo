import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  final int product_id;

  const ProductDetailScreen({Key? key, required this.product_id})
      : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class ProductDetail {
  final int id;
  final String title;
  final String image;
  final String category;
  final String description;

  ProductDetail(
      this.id, this.title, this.image, this.category, this.description);

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(json["id"], json["title"], json["image"],
        json["category"], json["description"]);
  }
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var productInfo;

  @override
  void initState() {
    super.initState();
    productInfo = {};
    fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
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
      body: getBody(),
    );
  }

  Widget titleSection = Container(
    padding: const EdgeInsets.all(32),
    child: Row(
      children: [
        Expanded(
          /*1*/
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /*2*/
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                child: const Text(
                  'Oeschinen Lake Campground',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                'Kandersteg, Switzerland',
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        /*3*/
        Icon(
          Icons.star,
          color: Colors.red[500],
        ),
        const Text('41'),
      ],
    ),
  );

  Widget getBody() {
    if (productInfo.isEmpty) {
      print("productInfo is empty");
    } else {
      return Scaffold(
        body: Column(
          children: [
            Image.network(productInfo["image"],
                width: 600, height: 240, fit: BoxFit.cover),
            Container(
              padding: const EdgeInsets.all(32),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            productInfo["title"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          productInfo["category"],
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.red[500],
                  ),
                  const Text('41'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                productInfo["description"],
                softWrap: true,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: Icon(Icons.shopping_cart),
          label: Text("Add to cart"),
          backgroundColor: Colors.deepOrangeAccent,
        ),
      );
    }
    return Container();
  }

  Future<void> fetchProduct() async {
    try {
      final response = await http.get(
          Uri.parse("https://fakestoreapi.com/products/${widget.product_id}"));
      Map<String, dynamic> result = json.decode(response.body);
      setState(() {
        productInfo = result;
      });
    } catch (e) {
      throw Exception("Error in getting product");
    }
  }
}
