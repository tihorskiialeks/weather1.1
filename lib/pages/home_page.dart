import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:weather1/pages/search_page.dart';
import 'package:weather1/providers/weather_provider.dart';
import '../services/weather_api_services.dart';
import '../repositories/weather_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
        actions: [
          IconButton(
              onPressed: () async {
                _city = await Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return SearchPage();
                }));
                print(_city);
              },
              icon: Icon(Icons.search)),
        ],
      ),
      body: const Center(
        child: Text('home'),
      ),
    );
  }
}
