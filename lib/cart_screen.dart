import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product_detail_screen.dart';
import 'category_screen.dart';
import 'product_screen.dart';
import 'profile_screen.dart';
import 'dart:math';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class Product {
  final int id;
  final String title;
  final String image;

  Product(this.id, this.title, this.image);

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(json["id"], json["title"], json["image"]);
  }

  static List<Product> parseList(List<dynamic> list) {
    return list.map((i) => Product.fromJson(i)).toList();
  }
}

class _CartScreenState extends State<CartScreen> {
  late List<Product> productsData;
  var productInfo;

  @override
  void initState() {
    super.initState();
    productsData = [];
    productInfo = {};
    fetchCartProducts();
    // fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Products'),
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
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
          )
        ],
      ),
      body: getBody(),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text(''),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage("assets/logo.jpg"), fit: BoxFit.cover)),
            ),
            ListTile(
              title: const Text('Categories'),
              onTap: () {
                // Navigate to categories
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CategoryScreen()));
              },
            ),
            ListTile(
              title: const Text('Products'),
              onTap: () {
                // Redirect to products
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProductScreen()));
              },
            ),
            ListTile(
              title: const Text('Cart'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => CartScreen()));
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProductScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    if (productsData.isEmpty) {
      print("cart data is empty");
    } else {
      return ListView.separated(
        itemCount: productsData == null ? 0 : productsData.length,
        itemBuilder: (context, index) {
          final Product product = productsData[index];
          return ListTile(
            leading: Image.network(product.image),
            title: Text(product.title),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ProductDetailScreen(product_id: product.id)));
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Colors.black);
        },
      );
    }
    return Container();
  }

  Future<void> fetchCartProducts() async {
    //get cart of random user
    Random random = new Random();
    int userId = random.nextInt(3);

    try {
      final response = await http
          .get(Uri.parse("https://fakestoreapi.com/carts/user/${userId}"));

      final List<Product> cart_products = [];

      final products = json.decode(response.body)[0]["products"];
      for (var i = 0; i < products.length; i++) {
        final single_product_response = await http.get(Uri.parse(
            "https://fakestoreapi.com/products/${products[i]["productId"]}"));

        var productJson = json.decode(single_product_response.body);
        Product product = Product.fromJson(productJson);

        cart_products.add(product);
        setState(() {
          productsData = cart_products;
        });
      }
    } catch (e) {
      throw Exception("Error in getting products");
    }
  }
}
