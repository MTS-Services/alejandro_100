// ignore_for_file: file_names

class CoupanCodeModel {
  String? success;
  String? error;
  String? message;
  List<CoupanCodeData>? data;

  CoupanCodeModel({this.success, this.error, this.message, this.data});

  CoupanCodeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CoupanCodeData>[];
      json['data'].forEach((v) {
        data!.add(CoupanCodeData.fromJson(v));
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

class CoupanCodeData {
  String? id;
  String? code;
  String? discount;
  String? discription;
  String? expireAt;
  String? statut;
  String? creer;
  String? modifier;
  String? type;

  CoupanCodeData({this.id, this.code, this.discount, this.discription, this.expireAt, this.statut, this.creer, this.type, this.modifier});

  CoupanCodeData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    code = json['code'].toString();
    discount = json['discount'].toString();
    discription = json['discription'].toString();
    expireAt = json['expire_at'].toString();
    statut = json['statut'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    type = json['type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['discount'] = discount;
    data['discription'] = discription;
    data['expire_at'] = expireAt;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['type'] = type;
    return data;
  }
}
