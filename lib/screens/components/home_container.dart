import 'dart:async';
import 'dart:ui';

import 'package:cleanin/screens/home_container_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/models/home.dart';
import 'package:cleanin/screens/calendar/event_synchronizer.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key, required this.home, required this.reference, required this.displayMode}) : super(key: key);

  final Home home;
  final DocumentReference<Home> reference;
  final DisplayMode displayMode;

  @override
  State<StatefulWidget> createState() => _HomeContainerState();
}

enum DisplayMode {
  normal,
  withMedia
}

const Map<HomeState, dynamic> homeStateColor = {
  HomeState.clean : Colors.green,
  HomeState.dirty : Colors.amber,
  HomeState.occupied : Colors.grey
};

const Map<HomeState, dynamic> homeStateIcon = {
  HomeState.clean : Icon(Icons.check, size: 40.0),
  HomeState.dirty : Icon(Icons.cleaning_services, size: 35.0),
  HomeState.occupied : Icon(Icons.people_sharp, size: 40.0)
};

const List<String> homeState = [
  "clean",
  "dirty",
  "occupied"
];

class _HomeContainerState extends State<HomeContainer> with AutomaticKeepAliveClientMixin{

  HomeState _homeState = HomeState.clean;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    final synchronizer = EventSynchronizer(reference: widget.reference).getCalendarEntries;
    synchronizer();

    Timer.periodic(
      const Duration(seconds: 300), (timer) => synchronizer()
    );
  }

  Widget simpleHomeContainer() {
    return Container(
        key: UniqueKey(),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: homeStateColor[_homeState],
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: homeStateIcon[_homeState],
                title: Text(widget.home.name),
                subtitle: Text(widget.home.address),
                trailing: IconButton(
                    iconSize: 35.0,
                    onPressed: () async {
                      setState(() {
                        toggleReference();
                      });
                    },
                    icon: const Icon(Icons.compare_arrows)
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget homeContainerWithPictures() {
    return Container(
        key: UniqueKey(),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: homeStateColor[_homeState],
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.network(
                'https://media.istockphoto.com/photos/bohemian-living-room-interior-3d-render-picture-id1182454657?k=20&m=1182454657&s=612x612&w=0&h=1xEsm7BqeicA8jYk9KlerUtGsAgzzo530l5Ak1HJdnc=',
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress == null
                      ? child
                      : const Center(child: CircularProgressIndicator());
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: homeStateIcon[_homeState],
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
        )
    );
  }

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

          if(data['homeState'] == "clean") {
            _homeState = HomeState.clean;
          }
          else if(data['homeState'] == "dirty") {
            _homeState = HomeState.dirty;
          }
          else {
            _homeState = HomeState.occupied;
          }

          if(widget.displayMode == DisplayMode.withMedia) {
            return homeContainerWithPictures();
          }
          return simpleHomeContainer();
        },
      )
    );
  }

  toggleReference() async {
    int nextIndex = (_homeState.index + 1) % HomeState.values.length;
    _homeState = HomeState.values[nextIndex];

    widget.reference.update({'homeState': _homeState.name});
  }

}