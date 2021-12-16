import 'dart:ui';

import 'package:cleanin/screens/home_container_screen.dart';
import 'package:flutter/material.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> with AutomaticKeepAliveClientMixin{
  bool isClean = true;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeContainerScreen()));
      },
      child: Container(
        key: UniqueKey(),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: isClean ? Colors.green : Colors.amber,
          borderRadius: const BorderRadius.all(Radius.circular(10)),

        ),
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
      )
    );
  }

}