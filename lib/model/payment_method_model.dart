class PaymentMethodModel {
  String? success;
  String? error;
  String? message;
  List<PaymentMethodData>? data;

  PaymentMethodModel({this.success, this.error, this.message, this.data});

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PaymentMethodData>[];
      json['data'].forEach((v) {
        data!.add(PaymentMethodData.fromJson(v));
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

class PaymentMethodData {
  String? id;
  String? libelle;
  String? image;
  String? statut;
  String? creer;
  String? modifier;

  PaymentMethodData({this.id, this.libelle, this.image, this.statut, this.creer, this.modifier});

  PaymentMethodData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    libelle = json['libelle'];
    image = json['image'];
    statut = json['statut'];
    creer = json['creer'];
    modifier = json['modifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['image'] = image;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    return data;
  }
}
