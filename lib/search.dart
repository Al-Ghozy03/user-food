// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_import, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, sized_box_for_whitespace, avoid_print

import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Search extends StatefulWidget {
  final String data;
  Search({required this.data});
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> food =
        FirebaseFirestore.instance.collection("makanan").snapshots();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: food,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return Text("terjadi kesalahan");
          if (snapshot.connectionState == ConnectionState.active) {
            var allData = snapshot.data!.docs;
            var view = allData
                .where((element) => element["nama"]
                    .toLowerCase()
                    .contains(widget.data.toLowerCase()))
                .toList();
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
                    Text(
                      "Search for ${widget.data} ",
                      style: TextStyle(fontSize: width / 30),
                    ),
                    SizedBox(
                      height: height / 50,
                    ),
                   view.isEmpty?Text("kosong",style: TextStyle(fontSize: width/10,color: Colors.grey,fontWeight: FontWeight.w700),): Container(
                      height: height,
                      width: width,
                      child: ListView.builder(
                        itemCount: view.length,
                        itemBuilder: (context, i) {
                          Map<String, dynamic> data =
                              view[i].data()! as Map<String, dynamic>;
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
        },
      ),
    );
  }

  
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
            )
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
