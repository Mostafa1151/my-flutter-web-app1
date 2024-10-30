import 'dart:convert';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:dashboard_quality_team/HomePage.dart';
import 'package:dashboard_quality_team/main.dart';
import 'package:dashboard_quality_team/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;

class Banners extends StatefulWidget {
  const Banners({super.key});

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  @override
  void initState() {
    fetchBenners();
    super.initState();
  }

  List<dynamic> BennersData = [];
  Future<void> fetchBenners() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://quality-ui.onrender.com/api/cards?populate[photo][fields][0]=url"),
        headers: {
          "Authorization":
              "Bearer 3c08b6f0ca2cb019b3cc33a2c7eacbde7642c3333f6d8a39fc69bc2ace376427a84c69ebd7717b70dc08f8154602a21b4876d0b995c9d298d05fcb799a1a266ac2fde64b230e0f9d67a20cbfd5a0b3715e3c050468f4b2fca59ea3b3e895c5a6f1252223e4e8b99d6ba269a3b7f0cab56ac0b17d8e372c199749889c394ffec8",
          "x-api-key": "gfjvbrjrs2z5fa0lsjmtenumv1a99k",
        },
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        var Data = responseBody['data'];
        setState(() {
          BennersData = [...Data];
        });
        print('BennersData :${BennersData}');
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01),
                          child: Image.asset("images/لوكو-111111.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                    "DashBoard Quality team",
                    style: TextStyle(
                      fontFamily: "Arfont",
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.02,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 300,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "لوحة التحكم",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.02,
                        fontFamily: "Arfont",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  label: "الرئيسية",
                  icon: "images/house.svg",
                  onTap: () {
                    Get.off(HomePage());
                  },
                ),
                _buildMenuItem(
                  context,
                  label: "المستخدمين",
                  icon: "images/users.svg",
                  onTap: () {
                    Get.off(users());
                  },
                ),
                _buildMenuItem(
                  context,
                  label: "لافتات",
                  icon: "images/users.svg",
                  onTap: () {
                    // Get.off(Account_Page());
                  },
                ),
              ],
            ),
          ),
          Expanded(
              child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, // عدد الأعمدة
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.7, // نسبة عرض العناصر إلى ارتفاعها
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      BennersData[index]['Title'],
                                      style: TextStyle(
                                        fontFamily: "Arfont",
                                        color: Colors.white,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      BennersData[index]['photo']['url'],
                                      fit: BoxFit.cover, // تكييف حجم الصورة
                                      width:
                                          double.infinity, // ملء العرض بالكامل
                                      height: double
                                          .infinity, // ملء الارتفاع بالكامل
                                    ),
                                  ),
                                  Container(
                                    color: Colors.white,
                                    child: Text(BennersData[index]['Body']),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: BennersData.length,
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required String label,
      required String icon,
      required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.width * 0.004),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.002),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: "Arfont",
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                SizedBox(
                  height: 30,
                  child: SvgPicture.asset(
                    icon,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
