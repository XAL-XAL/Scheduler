import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DirectoryPage extends StatefulWidget {
  const DirectoryPage({Key? key}) : super(key: key);

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text("Directory"),
      ),
      body: Center(child: Text("Directory Page")),
    );
  }
}
