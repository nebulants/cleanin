import 'dart:ui';

import 'package:cleanin/screens/home_container_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeContainerState();
}

DatabaseReference ref = FirebaseDatabase.instance.ref("test");

// Get the Stream
Stream<DatabaseEvent> stream = ref.onValue;

class _HomeContainerState extends State<HomeContainer> with AutomaticKeepAliveClientMixin{
  bool _isClean = true;

  @override
  bool get wantKeepAlive => true;

  _HomeContainerState() {
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell (
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomeContainerScreen()));
      },
      child: Container(
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
              leading: _isClean ? Icon(Icons.check) : Icon(Icons.cleaning_services),
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
                  onPressed: () async {
                    setState(() {
                      toggleReference();
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

  startListening() async {
    // Subscribe to the stream!
    stream.listen((DatabaseEvent event) {
      print('Event Type: ${event.type}'); // DatabaseEventType.value;
      print('Snapshot: ${event.snapshot.value}'); // DataSnapshot
      setState(() {
        _isClean = event.snapshot.value as bool;
      });
    });
  }

  setReference(value) async {
    await ref.set(value);
  }

  toggleReference() async {
    DatabaseEvent event = await ref.once();
    var value = event.snapshot.value as bool;
    _isClean = !value;
    //print("isClean -> ${_isClean}");
    await ref.set(_isClean);
  }

}