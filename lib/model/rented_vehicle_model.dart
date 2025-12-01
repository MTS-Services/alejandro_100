class RentedVehicleModel {
  String? success;
  String? error;
  String? message;
  List<RentedVehicleData>? data;

  RentedVehicleModel({this.success, this.error, this.message, this.data});

  RentedVehicleModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RentedVehicleData>[];
      json['data'].forEach((v) {
        data!.add(RentedVehicleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RentedVehicleData {
  String? id;
  String? nbJour;
  String? dateDebut;
  String? dateFin;
  String? contact;
  String? idVehiculeRental;
  String? statut;
  String? prix;
  String? noOfPassenger;
  String? creer;
  String? modifier;
  String? image;
  String? libTypeVehicule;

  RentedVehicleData(
      {this.id,
      this.nbJour,
      this.dateDebut,
      this.dateFin,
      this.contact,
      this.idVehiculeRental,
      this.statut,
      this.prix,
      this.noOfPassenger,
      this.creer,
      this.modifier,
      this.image,
      this.libTypeVehicule});

  RentedVehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nbJour = json['nb_jour'].toString();
    dateDebut = json['date_debut'].toString();
    dateFin = json['date_fin'].toString();
    contact = json['contact'].toString();
    idVehiculeRental = json['id_vehicule_rental'].toString();
    statut = json['statut'].toString();
    prix = json['prix'].toString();
    noOfPassenger = json['no_of_passenger'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    image = json['image'].toString();
    libTypeVehicule = json['libTypeVehicule'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nb_jour'] = nbJour;
    data['date_debut'] = dateDebut;
    data['date_fin'] = dateFin;
    data['contact'] = contact;
    data['id_vehicule_rental'] = idVehiculeRental;
    data['statut'] = statut;
    data['prix'] = prix;
    data['no_of_passenger'] = noOfPassenger;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['image'] = image;
    data['libTypeVehicule'] = libTypeVehicule;
    return data;
  }
}
