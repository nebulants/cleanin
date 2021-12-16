import 'dart:ui';

import 'package:flutter/material.dart';

class HomeCard extends StatefulWidget {
  const HomeCard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  bool isClean = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: UniqueKey(),
      color: isClean ? Colors.green : Colors.amber,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: isClean ? Icon(Icons.check) : Icon(Icons.cleaning_services),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(width: 8),
              TextButton(
                child: const Text('TOOGLE CLEANING STATE'),
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  setState(() {
                    isClean = !isClean;
                  });
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

}