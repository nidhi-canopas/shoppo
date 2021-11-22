import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class ProfileDetail {
}

class _ProfileScreenState extends State<ProfileScreen> {
  var profileInfo;

  @override
  void initState() {
    super.initState();
    profileInfo = {};
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
    );
  }

  Widget getBody() {
    if (profileInfo.isEmpty) {
      print("profileInfo is empty");
    } else {
      return Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red, Colors.deepOrange.shade300],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.9],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      // CircleAvatar(
                      //   backgroundColor: Colors.red.shade300,
                      //   minRadius: 35.0,
                      //   child: Icon(
                      //       Icons.call,
                      //       size: 30.0
                      //   ),
                      // ),
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                          AssetImage('assets/profile.jpg'),
                        ),
                      ),
                      // CircleAvatar(
                      //   backgroundColor: Colors.red.shade300,
                      //   minRadius: 35.0,
                      //   child: Icon(
                      //       Icons.message,
                      //       size: 30.0
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    profileInfo["username"],
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    profileInfo["email"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
            // Container(
            //   child: Row(
            //     children: <Widget>[
            //       Expanded(
            //         child: Container(
            //           color: Colors.deepOrange.shade300,
            //           child: ListTile(
            //             title: Text(
            //               '5000',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 30,
            //                 color: Colors.white,
            //               ),
            //             ),
            //             subtitle: Text(
            //               'Followers',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 fontSize: 20,
            //                 color: Colors.white70,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(
            //           color: Colors.red,
            //           child: ListTile(
            //             title: Text(
            //               '5000',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 30,
            //                 color: Colors.white,
            //               ),
            //             ),
            //             subtitle: Text(
            //               'Following',
            //               textAlign: TextAlign.center,
            //               style: TextStyle(
            //                 fontSize: 20,
            //                 color: Colors.white70,
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Phone',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      profileInfo["phone"],
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Address',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${profileInfo["address"]["number"].toString() + ', ' + profileInfo["address"]["street"] + ', ' + profileInfo["address"]["city"] + ', ' + profileInfo["address"]["zipcode"]}',
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Full name',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      profileInfo["name"]["firstname"] + ' ' + profileInfo["name"]["lastname"],
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await http.get(
          Uri.parse("https://fakestoreapi.com/users/1"));
      Map<String, dynamic> result = json.decode(response.body);
      setState(() {
        profileInfo = result;
      });
    } catch (e) {
      throw Exception("Error in getting user profile");
    }
  }
}
