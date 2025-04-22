import 'package:flutter/material.dart';

class FindVetsPage extends StatelessWidget {
  const FindVetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find VETS Near Me'),
      ),
      body: const Center(
        child: Text(
          'Map with Vets Coming Soon 🐾',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}