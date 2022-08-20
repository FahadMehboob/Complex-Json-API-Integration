import 'dart:convert';

import 'package:complex_json_api/Models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Users> userList = [];
  Future<List<Users>> getUsers() async {
    final responce =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(responce.body.toString());

    if (responce.statusCode == 200) {
      for (Map i in data) {
        userList.add(Users.fromJson(i));
      }
      return userList;
    } else {
      return userList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Users API'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getUsers(),
                builder: (context, AsyncSnapshot<List<Users>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                ReusuableRow(
                                    title: 'Name',
                                    value:
                                        snapshot.data![index].name.toString()),
                                ReusuableRow(
                                    title: 'Email',
                                    value:
                                        snapshot.data![index].email.toString()),
                                ReusuableRow(
                                    title: 'Phone',
                                    value:
                                        snapshot.data![index].phone.toString()),
                                ReusuableRow(
                                    title: 'Website',
                                    value: snapshot.data![index].website
                                        .toString()),
                                ReusuableRow(
                                    title: 'Address',
                                    value:
                                        "${snapshot.data![index].address!.city}   ${snapshot.data![index].address!.zipcode}"),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class ReusuableRow extends StatelessWidget {
  final String title, value;
  const ReusuableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Text(value),
      ],
    );
  }
}
