// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unnecessary_new

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? daerah;
  List<String> listDaerah = [
    'bekasi',
    'cibitung',
    "cikarang",
    "bandung",
    "lamongan",
    "banten",
    "turki"
  ];
  String? dropDownValue;
  List<String> locations = ['harga terendah', 'harga tertinggi'];
  String? promo;
  List<String> listPromo = ['10', '20', "30", "40", "50", "60", "70", "80", "90", "100"];
  int rate = 10;
  final Stream<QuerySnapshot> food =
      FirebaseFirestore.instance.collection("makanan").snapshots();
  @override
  Widget build(BuildContext context) {
    bool filter = false;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: food,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              var listData = snapshot.data!.docs;
              return SafeArea(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Find your food",
                        style: TextStyle(
                            fontSize: width / 13, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: height / 60,
                      ),
                      TextField(
                        onSubmitted: ((value) => Navigator.pushNamed(
                            context, "/search",
                            arguments: value)),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Search",
                            prefixIcon: Icon(Iconsax.search_normal_1)),
                      ),
                      SizedBox(height: height/50,),
                      TextField(
                        onSubmitted: ((value) => Navigator.pushNamed(
                            context, "/harga",
                            arguments: value)),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "Range harga",
                            prefixIcon: Icon(Iconsax.search_normal_1)),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton(
                            hint: Text('Select by'),
                            value: dropDownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropDownValue = newValue!;
                                Navigator.pushNamed(context, "/filter",
                                    arguments: dropDownValue);
                              });
                            },
                            items: locations.map((location) {
                              return DropdownMenuItem(
                                child: Text(location),
                                value: location,
                              );
                            }).toList(),
                          ),
                          DropdownButton(
                            hint: Text('Select by promo'),
                            value: promo,
                            onChanged: (String? newValue) {
                              setState(() {
                                promo = newValue!;
                                Navigator.pushNamed(context, "/promo",
                                    arguments: promo);
                              });
                            },
                            items: listPromo.map((promo) {
                              return DropdownMenuItem(
                                child: Text(promo),
                                value: promo,
                              );
                            }).toList(),
                          ),
                          DropdownButton(
                            hint: Text('daerah'),
                            value: daerah,
                            onChanged: (String? newValue) {
                              setState(() {
                                daerah = newValue!;
                                Navigator.pushNamed(context, "/daerah",
                                    arguments: daerah);
                              });
                            },
                            items: listDaerah.map((daerah) {
                              return DropdownMenuItem(
                                child: Text(daerah),
                                value: daerah,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      Container(
                        height: width * 1.4,
                        width: width,
                        child: ListView.builder(
                          itemCount: listData.length,
                          itemBuilder: (context, i) {
                            Map<String, dynamic> data =
                                listData[i].data()! as Map<String, dynamic>;
                            return _list(height, width, data);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Widget _list(height, width, data) {
  return Container(
    margin: EdgeInsets.only(bottom: 40),
    height: height / 5,
    width: width,
    decoration: BoxDecoration(
        color: Color.fromARGB(255, 223, 223, 223),
        borderRadius: BorderRadius.circular(24)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 20, left: 10),
            margin: EdgeInsets.only(bottom: 20),
            height: height,
            width: width / 2.9,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(data["img"]), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                ),
                Text(
                  data["rating"].toString(),
                  style: TextStyle(fontSize: width / 40),
                )
              ],
            ),
          ),
          SizedBox(
            width: width / 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["nama"],
                style: TextStyle(
                    fontSize: width / 27, fontWeight: FontWeight.w700),
              ),
              Text(
                "Rp ${data["harga"]}",
                style: TextStyle(fontSize: width / 35),
              ),
              Text(
                "${data["daerah"]}, ${data["promo"]}%",
                style: TextStyle(fontSize: width / 35),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
