import 'package:flutter/material.dart';

class home extends StatefulWidget {
  final String stduentname;
  const home({super.key, required this.stduentname});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Home Page"),
      ),
    );
  }
}
