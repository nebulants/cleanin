import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/models/home.dart';

class HomeStatusScreen extends StatefulWidget {
  const HomeStatusScreen({Key? key, required this.reference}) : super(key: key);

  final DocumentReference<Home> reference;

  @override
  State createState() => _HomeStatusScreenState();
}

class _HomeStatusScreenState extends State<HomeStatusScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home status screen"),
        actions: [
          IconButton(
            onPressed: () {
              widget.reference.delete().then((value) => debugPrint("home deleted"));
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete)
          ),
        ],
      ),
      body: Column(
        children: [
          Image.network(
            'https://image.shutterstock.com/shutterstock/photos/1705541491/display_1500/stock-photo-stylish-modern-wooden-living-room-in-white-background-scandinavian-style-rattan-home-decor-d-1705541491.jpg',
            loadingBuilder: (context, child, loadingProgress) {
              return loadingProgress == null
                  ? child
                  : const Center(child: CircularProgressIndicator());
            },
          ),
          FutureBuilder(
            future: widget.reference.get().then((value) => value.data()?.description),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return Text(snapshot.data!);
              }
              else if(snapshot.connectionState == ConnectionState.none) {
                return const Text("No data available");
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      )
    );
  }
}