import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/models/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';

import 'components/home_container.dart';

class HomeStatusScreen extends StatefulWidget {
  const HomeStatusScreen({Key? key, required this.reference}) : super(key: key);

  final DocumentReference<Home> reference;

  @override
  State createState() => _HomeStatusScreenState();
}

class _HomeStatusScreenState extends State<HomeStatusScreen> {

  final ImagePicker _imagePicker = ImagePicker();

  Future uploadImageToFirebase(XFile file) async {

    File _file = File(file.path);
    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('images')
          .child(widget.reference.id)
          .child(file.name)
          .putFile(_file);
    } catch (e) {
      print(e);
    }
  }

  Future<void> retrieveImageURL(String fileName) async {
    String imageUrl = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child(widget.reference.id)
        .child(fileName)
        .getDownloadURL();

    await widget.reference.update({'imageUrl': imageUrl});
  }

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
      body: StreamBuilder<DocumentSnapshot<Home>>(
        stream: widget.reference.snapshots(),
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

          final data = snapshot.requireData.data()!;

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: data.imageUrl,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              ),
              const Divider(),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  primary: Colors.white
                ),
                onPressed: () async {
                  final pickedImage = await _imagePicker.pickImage(source: ImageSource.gallery);

                  await uploadImageToFirebase(pickedImage!);

                  await retrieveImageURL(pickedImage.name);

                  setState(() {
                  });
                },
                child: const Text('Upload Image'),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: widget.reference.get().then((value) => value.data()),
                  builder: (BuildContext context, AsyncSnapshot<Home?> snapshot) {
                    if(snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        children: [
                          Text(snapshot.data!.name),
                          const Divider(),
                          Text(snapshot.data!.address),
                          const Divider(),
                          Text(snapshot.data!.description),
                          const Divider(),
                          Text(snapshot.data!.nextCheckIn.toString()),
                          const Divider(),
                          Text(snapshot.data!.homeState),
                        ],
                      );
                    }
                    else if(snapshot.connectionState == ConnectionState.none) {
                      return const Text("No data available");
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              )
            ],
          );
        }
      )
    );
  }
}