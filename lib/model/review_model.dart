class ReviewModel {
  String? success;
  String? error;
  Data? data;

  ReviewModel({this.success, this.error, this.data});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? rideId;
  String? niveau;
  String? idConducteur;
  String? idUserApp;
  String? statut;
  String? creer;
  String? modifier;
  String? comment;

  Data({this.id, this.rideId, this.niveau, this.idConducteur, this.idUserApp, this.statut, this.creer, this.modifier, this.comment});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    rideId = json['ride_id'].toString();
    niveau = json['niveau'].toString();
    idConducteur = json['id_conducteur'].toString();
    idUserApp = json['id_user_app'].toString();
    statut = json['statut'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    comment = json['comment'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ride_id'] = rideId;
    data['niveau'] = niveau;
    data['id_conducteur'] = idConducteur;
    data['id_user_app'] = idUserApp;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['comment'] = comment;
    return data;
  }
}
