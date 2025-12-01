import 'package:cabme/model/tax_model.dart';

class RideModel {
  String? success;
  String? error;
  String? message;
  List<RideData>? data;

  RideModel({this.success, this.error, this.message, this.data});

  RideModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RideData>[];
      json['data'].forEach((v) {
        data!.add(RideData.fromJson(v));
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

class RideData {
  String? id;
  String? idUserApp;
  String? departName;
  String? distanceUnit;
  String? destinationName;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? numberPoeple;
  String? place;
  String? statut;
  String? idConducteur;
  String? creer;
  List<Stops>? stops;
  String? trajet;
  String? tripObjective;
  String? tripCategory;
  String? nom;
  String? prenom;
  String? otp;
  String? distance;
  String? phone;
  String? nomConducteur;
  String? prenomConducteur;
  String? driverPhone;
  String? photoPath;
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  String? montant;
  String? duree;
  String? statutPaiement;
  String? payment;
  String? paymentImage;
  String? idVehicule;
  String? brand;
  String? model;
  String? carMake;
  String? milage;
  String? km;
  String? color;
  String? numberplate;
  String? passenger;
  String? moyenne;
  String? moyenneDriver;
  String? rideType;
  List<TaxModel>? taxModel;

  RideData(
      {this.id,
      this.idUserApp,
      this.departName,
      this.distanceUnit,
      this.destinationName,
      this.latitudeDepart,
      this.longitudeDepart,
      this.latitudeArrivee,
      this.longitudeArrivee,
      this.numberPoeple,
      this.place,
      this.statut,
      this.idConducteur,
      this.creer,
      this.trajet,
      this.tripObjective,
      this.tripCategory,
      this.nom,
      this.prenom,
      this.otp,
      this.distance,
      this.phone,
      this.nomConducteur,
      this.prenomConducteur,
      this.driverPhone,
      this.photoPath,
      this.dateRetour,
      this.heureRetour,
      this.statutRound,
      this.montant,
      this.duree,
      this.statutPaiement,
      this.payment,
      this.paymentImage,
      this.idVehicule,
      this.brand,
      this.model,
      this.carMake,
      this.milage,
      this.km,
      this.color,
      this.numberplate,
      this.passenger,
      this.stops,
      this.moyenne,
      this.taxModel,
      this.rideType,
      this.moyenneDriver});

  RideData.fromJson(Map<String, dynamic> json) {
    List<TaxModel>? taxList = [];
    if (json['tax'] != null) {
      taxList = <TaxModel>[];
      json['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    id = json['id'].toString();
    idUserApp = json['id_user_app'].toString();
    departName = json['depart_name'].toString();
    distanceUnit = json['distance_unit'].toString();
    destinationName = json['destination_name'].toString();
    latitudeDepart = json['latitude_depart'].toString();
    longitudeDepart = json['longitude_depart'].toString();
    latitudeArrivee = json['latitude_arrivee'].toString();
    longitudeArrivee = json['longitude_arrivee'].toString();
    numberPoeple = json['number_poeple'].toString();
    place = json['place'].toString();
    statut = json['statut'].toString();
    idConducteur = json['id_conducteur'].toString();
    creer = json['creer'].toString();
    trajet = json['trajet'].toString();
    tripObjective = json['trip_objective'].toString();
    tripCategory = json['trip_category'].toString();
    nom = json['nom'].toString();
    prenom = json['prenom'].toString();
    if (json['stops'] != null && json['stops'].isNotEmpty && json['stops'].toString() != "[]") {
      stops = <Stops>[];
      json['stops'].forEach((v) {
        stops!.add(Stops.fromJson(v));
      });
    } else {
      stops = [];
    }
    otp = json['otp'].toString();
    distance = json['distance'].toString();
    phone = json['phone'].toString();
    nomConducteur = json['nomConducteur'].toString();
    prenomConducteur = json['prenomConducteur'].toString();
    driverPhone = json['driverPhone'].toString();
    photoPath = json['photo_path'].toString();
    dateRetour = json['date_retour'].toString();
    heureRetour = json['heure_retour'].toString();
    statutRound = json['statut_round'].toString();
    montant = json['montant'].toString();
    duree = json['duree'].toString();
    statutPaiement = json['statut_paiement'].toString();
    payment = json['payment'].toString();
    paymentImage = json['payment_image'].toString();
    idVehicule = json['idVehicule'].toString();
    brand = json['brand'].toString();
    model = json['model'].toString();
    carMake = json['car_make'].toString();
    milage = json['milage'].toString();
    km = json['km'].toString();
    color = json['color'].toString();
    numberplate = json['numberplate'].toString();
    passenger = json['passenger'].toString();
    driverPhone = json['driver_phone'].toString();
    moyenne = json['moyenne'].toString();
    moyenneDriver = json['moyenne_driver'].toString();
    taxModel = taxList;
    rideType = json['ride_type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['depart_name'] = departName;
    data['distance_unit'] = distanceUnit;
    data['destination_name'] = destinationName;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['number_poeple'] = numberPoeple;
    data['place'] = place;
    data['statut'] = statut;
    data['id_conducteur'] = idConducteur;
    data['creer'] = creer;
    data['trajet'] = trajet;
    data['trip_objective'] = tripObjective;
    data['trip_category'] = tripCategory;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['otp'] = otp;
    data['distance'] = distance;
    data['phone'] = phone;
    data['nomConducteur'] = nomConducteur;
    data['prenomConducteur'] = prenomConducteur;
    data['driverPhone'] = driverPhone;
    data['photo_path'] = photoPath;
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['montant'] = montant;
    data['duree'] = duree;
    data['statut_paiement'] = statutPaiement;
    data['payment'] = payment;
    data['payment_image'] = paymentImage;
    data['idVehicule'] = idVehicule;
    data['brand'] = brand;
    data['model'] = model;
    data['car_make'] = carMake;
    data['milage'] = milage;
    data['km'] = km;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['driver_phone'] = driverPhone;
    data['moyenne'] = moyenne;
    data['moyenne_driver'] = moyenneDriver;
    data['ride_type'] = rideType;
    if (stops!.isNotEmpty) {
      data['stops'] = stops!.map((v) => v.toJson()).toList();
    } else {
      data['stops'] = [];
    }
    data['tax'] = taxModel?.map((v) => v.toJson()).toList();
    return data;
  }
}

class Stops {
  String? latitude;
  String? location;
  String? longitude;

  Stops({this.latitude, this.location, this.longitude});

  Stops.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'].toString();
    location = json['location'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['location'] = location;
    data['longitude'] = longitude;
    return data;
  }
}
