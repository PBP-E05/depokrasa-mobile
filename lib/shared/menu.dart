import 'package:flutter/material.dart';
import 'package:depokrasa_mobile/shared/left_drawer.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
      drawer: const LeftDrawer(),
    );
  }
}
