// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, void_checks, avoid_print, unused_local_variable, unused_element

import 'dart:async';

import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tag = 0;
  List<String> options = [
    'Harga tertinggi',
    'Harga terendah',
  ];
  int rating = 0;
  List<int> listRating = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<int> promo = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  List<String> daerah = [
    "bekasi",
    "jakarta",
    "cibitung",
    "cikarang",
    "lamongan"
  ];
  List filterData = [];
  int getpromo = 0;
  String getdaerah = "bekasi";

  FutureOr getDataJuga(List data, int rating, int promo) async {
    getData(data, rating, promo);
  }

  void getData(List data, int rating, int promo) {
    setState(() {
      filterData = data
          .where((element) =>
              element['rating'] == rating ||
              element["promo"] == promo ||
              element["daerah"] == getdaerah)
          .toList();
    });
  }

  final Stream<QuerySnapshot> food =
      FirebaseFirestore.instance.collection("makanan").snapshots();
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: food,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text("terjadi kesalahan");
          if (snapshot.connectionState == ConnectionState.active) {
            var allData = snapshot.data!.docs;
            if (tag == 0) {
              allData.sort(
                (a, b) => b["harga"].compareTo(a["harga"]),
              );
              filterData.sort((a, b) => b["harga"].compareTo(a["harga"]));
            } else {
              filterData.sort((a, b) => a["harga"].compareTo(b["harga"]));
              allData.sort(
                (a, b) => a["harga"].compareTo(b["harga"]),
              );
            }
            return SafeArea(
                child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _circle(height, width),
                    SizedBox(
                      height: height / 35,
                    ),
                    TextField(
                      onSubmitted: (value) => Navigator.pushNamed(
                          context, "/search",
                          arguments: value),
                      decoration: InputDecoration(
                          hintText: "Search food",
                          prefixIcon: Icon(Iconsax.search_normal_1),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                              borderSide: BorderSide(color: Colors.white))),
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async => await showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      final width =
                                          MediaQuery.of(context).size.width;
                                      return Padding(
                                        padding: const EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Rating",
                                              style: TextStyle(
                                                  fontSize: width / 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Wrap(
                                                spacing: width / 20,
                                                children: listRating
                                                    .map((e) => ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                primary: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        149,
                                                                        248)),
                                                        onPressed: () {
                                                          setState(() {
                                                            rating = e;
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child:
                                                            Text(e.toString())))
                                                    .toList()),
                                            Text(
                                              "Promo",
                                              style: TextStyle(
                                                  fontSize: width / 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Wrap(
                                                spacing: width / 20,
                                                children: promo
                                                    .map((e) => ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            getpromo = e;
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: Text("$e%")))
                                                    .toList()),
                                            Text(
                                              "Daerah",
                                              style: TextStyle(
                                                  fontSize: width / 25,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Wrap(
                                                spacing: width / 20,
                                                children: daerah
                                                    .map((e) => ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            getdaerah = e;
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        child: Text(e)))
                                                    .toList()),
                                          ],
                                        ),
                                      );
                                    })
                                .then((value) =>
                                    getDataJuga(allData, rating, getpromo)),
                            icon: Icon(Iconsax.filter)),
                        ChipsChoice<int>.single(
                          value: tag,
                          onChanged: (val) => setState(() {
                            tag = val;
                          }),
                          choiceItems: C2Choice.listFrom<int, String>(
                              source: options,
                              value: (i, v) => i,
                              label: (i, v) => v),
                          choiceStyle: C2ChoiceStyle(
                              showCheckmark: false,
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                    Text(
                      "Food",
                      style: TextStyle(
                          fontSize: width / 16, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                    Container(
                      height: height / 1.5,
                      width: width,
                      child: ListView.builder(
                        itemCount: filterData.isEmpty
                            ? allData.length
                            : filterData.length,
                        itemBuilder: (context, i) {
                          Map<String, dynamic> data =
                              allData[i].data()! as Map<String, dynamic>;
                          return _list(height, width,
                              filterData.isEmpty ? data : filterData[i]);
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
        },
      ),
    );
  }
}

Widget _buttonHarga(String text, BuildContext context) {
  return ElevatedButton(
      style:
          ElevatedButton.styleFrom(primary: Color.fromARGB(255, 0, 149, 248)),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(text));
}

Widget _buttonRating(String text, BuildContext context) {
  return ElevatedButton(
      style:
          ElevatedButton.styleFrom(primary: Color.fromARGB(255, 0, 149, 248)),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(text));
}

Widget _buttonPromo(String text, BuildContext context) {
  return ElevatedButton(
      style:
          ElevatedButton.styleFrom(primary: Color.fromARGB(255, 0, 149, 248)),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(text));
}

Widget _buttonDaerah(String text, BuildContext context) {
  return ElevatedButton(
      style:
          ElevatedButton.styleFrom(primary: Color.fromARGB(255, 0, 149, 248)),
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(text));
}

Widget _list(height, width, data) {
  return Container(
    margin: EdgeInsets.only(bottom: height / 30),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height / 4,
          width: width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                  image: NetworkImage(data["img"]), fit: BoxFit.cover)),
        ),
        SizedBox(
          height: height / 75,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              data["nama"],
              style:
                  TextStyle(fontSize: width / 20, fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Color.fromARGB(255, 243, 198, 0),
                ),
                Text(
                  "${data["rating"]}",
                  style: TextStyle(fontSize: width / 35),
                )
              ],
            )
          ],
        ),
        Row(
          children: [
            Icon(
              Iconsax.location,
              color: Color.fromARGB(255, 100, 100, 100),
            ),
            SizedBox(
              width: width / 50,
            ),
            Text(
              data["daerah"],
              style: TextStyle(
                  fontSize: width / 35,
                  color: Color.fromARGB(255, 100, 100, 100)),
            ),
            SizedBox(
              width: width / 20,
            ),
            Text(
              "Promo ${data["promo"]}%",
              style: TextStyle(
                  fontSize: width / 35,
                  color: Color.fromARGB(255, 100, 100, 100)),
            ),
            SizedBox(
              width: width / 20,
            ),
            Text(
              "Rp ${data["harga"]}",
              style: TextStyle(
                  fontSize: width / 35,
                  color: Color.fromARGB(255, 100, 100, 100)),
            ),
          ],
        )
      ],
    ),
  );
}

Widget _circle(height, width) {
  return Container(
    height: width / 10,
    width: width / 10,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromARGB(255, 189, 189, 189)),
  );
}
