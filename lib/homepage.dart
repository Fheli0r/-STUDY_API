import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List> pegarUsuarios() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/users');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Erro 404, Falha ao conectar ao servidor');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: FutureBuilder<List>(
          future: pegarUsuarios(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('erro ao carregar o usuarios...'),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    trailing: Text(snapshot.data![index]['username']),
                    title: Text(snapshot.data![index]['name']),
                    subtitle: Text(snapshot.data![index]['email']),
                  );
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
