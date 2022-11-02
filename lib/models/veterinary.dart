class Veterinaries {
  String? placeID;
  String? vetname;
  String? vicinity;

  Veterinaries({
    this.placeID,
    this.vetname,
    this.vicinity,
  });
  Veterinaries.fromJson(Map<String, dynamic> json) {
    placeID = json['place_id'];
    vetname = json['name'];
    vicinity = json['vicinity'];
  }
}
