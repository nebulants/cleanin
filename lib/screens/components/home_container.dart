import 'dart:ui';

import 'package:cleanin/screens/home_container_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/models/home.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key, required this.home, required this.reference}) : super(key: key);

  final Home home;
  final DocumentReference<Home> reference;

  @override
  State<StatefulWidget> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> with AutomaticKeepAliveClientMixin{
  bool _isClean = true;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return InkWell (
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeContainerScreen(reference: widget.reference)));
      },
      child: StreamBuilder(
        stream: widget.reference.snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if(!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final data = snapshot.requireData;

          _isClean = data['cleaningState'];

          return Container(
            key: UniqueKey(),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: _isClean ? Colors.green : Colors.amber,
              borderRadius: const BorderRadius.all(Radius.circular(10)),

            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: _isClean ? const Icon(Icons.check, size: 35.0) : const Icon(Icons.cleaning_services, size: 30.0),
                  title: Text(widget.home.name),
                  subtitle: Text(widget.home.address),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        iconSize: 35.0,
                        onPressed: () async {
                          setState(() {
                            toggleReference();
                          });
                        },
                        icon: const Icon(Icons.compare_arrows)
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }

  toggleReference() async {
    _isClean = !_isClean;
    widget.reference.update({'cleaningState': _isClean});
  }

}