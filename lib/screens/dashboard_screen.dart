import 'package:cleanin/models/home.dart';
import 'package:cleanin/screens/components/home_container.dart';
import 'package:flutter/material.dart';
import 'package:cleanin/forms/add_home_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/screens/side_menu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

final homesRef = FirebaseFirestore.instance
    .collection("homes")
    .withConverter<Home>(
      fromFirestore: (snapshots, _) => Home.fromMap(snapshots.data()!),
      toFirestore: (home, _) => home.toMap()
);

class _DashboardScreenState extends State<DashboardScreen> {
  String _orderBy = 'nextCheckIn';
  DisplayMode _displayMode = DisplayMode.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: const [
            Center(child: Text("CleanIn Dashboard")),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: _displayMode == DisplayMode.normal
                ? const Icon(Icons.view_carousel_outlined)
                : const Icon(Icons.view_agenda_outlined),
            onPressed: () {
              setState(() {
                _displayMode = _displayMode == DisplayMode.normal
                ? DisplayMode.withMedia
                : DisplayMode.normal;
              });
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.sort),
            onSelected: (value) => setState(() {
              _orderBy = value as String;
            }),
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  child: Text('Sort by cleaning state'),
                  value: 'homeState'
                ),
                const PopupMenuItem(
                  child: Text('Sort by closest check-in'),
                  value: 'nextCheckIn',
                ),
                const PopupMenuItem(
                  child: Text('Sort name'),
                  value: 'name'
                )
              ];
            },
          )
        ],
      ),
      drawer: const SideMenu(),
      body: StreamBuilder<QuerySnapshot>(
          stream: homesRef.orderBy(_orderBy).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if(!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final data = snapshot.requireData;

            return ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                return HomeContainer(
                    home: data.docs[index].data() as Home,
                    reference: data.docs[index].reference as DocumentReference<Home>,
                    displayMode: _displayMode,
                );
              },
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddHomeForm()));
        },
      ),
    );
  }
}