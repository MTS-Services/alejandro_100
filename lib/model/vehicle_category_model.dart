class VehicleCategoryModel {
  String? success;
  String? error;
  String? message;
  List<VehicleData>? data;

  VehicleCategoryModel({this.success, this.error, this.message, this.data});

  VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <VehicleData>[];
      json['data'].forEach((v) {
        data!.add(VehicleData.fromJson(v));
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

class VehicleData {
  String? id;
  String? libelle;
  String? prix;
  String? image;
  String? selectedImage;
  String? status;
  String? creer;
  String? modifier;
  String? updatedAt;
  String? deletedAt;
  String? selectedImagePath;
  String? statutCommissionPerc;
  String? commissionPerc;
  String? typePerc;
  String? deliveryCharges;
  String? minimumDeliveryCharges;
  String? minimumDeliveryChargesWithin;

  VehicleData(
      {this.id,
      this.libelle,
      this.prix,
      this.image,
      this.selectedImage,
      this.status,
      this.creer,
      this.modifier,
      this.updatedAt,
      this.deletedAt,
      this.selectedImagePath,
      this.statutCommissionPerc,
      this.commissionPerc,
      this.typePerc,
      this.deliveryCharges,
      this.minimumDeliveryCharges,
      this.minimumDeliveryChargesWithin});

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    libelle = json['libelle'].toString();
    prix = json['prix'].toString();
    image = json['image'].toString();
    selectedImage = json['selected_image'].toString();
    status = json['status'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    selectedImagePath = json['selected_image_path'].toString();
    statutCommissionPerc = json['statut_commission_perc'].toString();
    commissionPerc = json['commission_perc'].toString();
    typePerc = json['type_perc'].toString();
    deliveryCharges = json['delivery_charges'].toString();
    minimumDeliveryCharges = json['minimum_delivery_charges'].toString();
    minimumDeliveryChargesWithin = json['minimum_delivery_charges_within'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['libelle'] = libelle;
    data['prix'] = prix;
    data['image'] = image;
    data['selected_image'] = selectedImage;
    data['status'] = status;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['selected_image_path'] = selectedImagePath;
    data['statut_commission_perc'] = statutCommissionPerc;
    data['commission_perc'] = commissionPerc;
    data['type_perc'] = typePerc;
    data['delivery_charges'] = deliveryCharges;
    data['minimum_delivery_charges'] = minimumDeliveryCharges;
    data['minimum_delivery_charges_within'] = minimumDeliveryChargesWithin;
    return data;
  }
}
