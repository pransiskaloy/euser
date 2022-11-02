class PetStore {
  String? placeID;
  String? vetname;
  String? vicinity;

  PetStore({
    this.placeID,
    this.vetname,
    this.vicinity,
  });
  PetStore.fromJson(Map<String, dynamic> json) {
    placeID = json['place_id'];
    vetname = json['name'];
    vicinity = json['vicinity'];
  }
}
