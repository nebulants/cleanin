
import 'package:cleanin/screens/components/home_container.dart';

enum HomeState {
  clean,
  dirty,
  occupied
}

class Home
{
  late String name;
  late String address;
  late String description;
  late DateTime nextCheckIn;
  late String homeState;
  late String icalPermalink;

  Home({
    required this.name,
    required this.address,
    required this.description,
    required this.nextCheckIn,
    required this.homeState,
    required this.icalPermalink
  });


  Home.fromMap(Map<String, dynamic> data) {
    name = data["name"] as String;
    address = data["address"] as String;
    description = data["description"] as String;
    nextCheckIn = data["nextCheckIn"].toDate() as DateTime;
    homeState = data["homeState"] as String;
    icalPermalink = data["icalPermalink"] as String;
  }

  Map<String, dynamic> toMap() {
    return {
      "name" : name,
      "address" : address,
      "description" : description,
      "nextCheckIn" : nextCheckIn,
      "homeState" : homeState,
      "icalPermalink" : icalPermalink,
    };
  }
}