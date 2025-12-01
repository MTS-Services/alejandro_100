class FavoriteModel {
  String? success;
  String? error;
  List<Data>? data;

  FavoriteModel({this.success, this.error, this.data});

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? libelle;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? departName;
  String? destinationName;
  String? distance;
  String? distanceUnit;
  String? statut;
  String? creer;
  String? modifier;
  String? idUserApp;

  Data(
      {this.id,
      this.libelle,
      this.latitudeDepart,
      this.longitudeDepart,
      this.latitudeArrivee,
      this.longitudeArrivee,
      this.departName,
      this.destinationName,
      this.distance,
      this.distanceUnit,
      this.statut,
      this.creer,
      this.modifier,
      this.idUserApp});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    libelle = json['libelle'].toString();
    latitudeDepart = json['latitude_depart'].toString();
    longitudeDepart = json['longitude_depart'].toString();
    latitudeArrivee = json['latitude_arrivee'].toString();
    longitudeArrivee = json['longitude_arrivee'].toString();
    departName = json['depart_name'].toString();
    destinationName = json['destination_name'].toString();
    distance = json['distance'].toString();
    distanceUnit = json['distance_unit'].toString();
    statut = json['statut'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    idUserApp = json['id_user_app'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['distance'] = distance;
    data['distance_unit'] = distanceUnit;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['id_user_app'] = idUserApp;
    return data;
  }
}
