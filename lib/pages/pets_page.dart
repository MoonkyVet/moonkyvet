import 'package:flutter/material.dart';

class PetsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pets'),
      ),
      body: Center(
        child: Text('This is the Pets page.'),
      ),
    );
  }
}
