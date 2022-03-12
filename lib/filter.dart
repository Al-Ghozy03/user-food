// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unnecessary_string_interpolations, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  final String data;
  Filter({required this.data});
  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  String? dropDownValue;
  List<String> ratings = ['1', '2', "3", "4", "5", "6", "7", "8", "9", "10"];
  int rate = 10;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> food = FirebaseFirestore.instance
        .collection("makanan")
        .orderBy("harga",
            descending: widget.data == "harga terendah" ? false : true)
        .where("rating", isEqualTo: rate)
        .snapshots();
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
                        "Search: ${widget.data}",
                        style: TextStyle(
                            fontSize: width / 13, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: height / 60,
                      ),
                      DropdownButton(
                        hint: Text('Select by'),
                        value: dropDownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropDownValue = newValue!;
                            rate = int.parse(dropDownValue.toString());
                          });
                        },
                        items: ratings.map((location) {
                          return DropdownMenuItem(
                            child: Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                      SizedBox(
                        height: height / 40,
                      ),
                      Container(
                        height: height,
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
