
class Home
{
  late String name;
  late String address;
  late String description;
  late DateTime nextCheckIn;
  late bool cleaningState;
  late String icalPermalink;

  Home({
    required this.name,
    required this.address,
    required this.description,
    required this.nextCheckIn,
    required this.cleaningState,
    required this.icalPermalink
  });


  Home.fromMap(Map<String, dynamic> data) {
    name = data["name"] as String;
    address = data["address"] as String;
    description = data["description"] as String;
    nextCheckIn = data["nextCheckIn"].toDate() as DateTime;
    cleaningState = data["cleaningState"] as bool;
    icalPermalink = data["icalPermalink"] as String;
  }

  Map<String, dynamic> toMap() {
    return {
      "name" : name,
      "address" : address,
      "description" : description,
      "nextCheckIn" : nextCheckIn,
      "cleaningState" : cleaningState,
      "icalPermalink" : icalPermalink,
    };
  }
}