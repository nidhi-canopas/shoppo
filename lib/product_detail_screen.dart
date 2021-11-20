import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {

  final int product_id;

  const ProductDetailScreen({Key? key,required this.product_id}) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class ProductDetail {
  final int id;
  final String title;
  final String image;
  final String category;
  final String description;

  ProductDetail(this.id, this.title, this.image, this.category, this.description);
  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(json["id"], json["title"], json["image"], json["category"], json["description"]);
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
      appBar: AppBar(title: Text('Products')),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (productInfo.isEmpty) {
      print("productInfo is empty");
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(productInfo["title"]),
          automaticallyImplyLeading: false,
        ),
        body: Column(
            children: <Widget>[
              Expanded(
                  child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.all(10.0),
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 35,
                      child: ClipOval(
                        child:
                        Image.network(productInfo["image"],
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ),
                  )
              ),
            ]
        ),);
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

