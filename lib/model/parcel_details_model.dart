import 'package:cabme/model/tax_model.dart';

class ParcelDetailsModel {
  String? success;
  String? error;
  String? message;
  ParcelDetailsData? rideDetailsdata;

  ParcelDetailsModel({this.success, this.error, this.message, this.rideDetailsdata});

  ParcelDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    rideDetailsdata = json['data'] != null ? ParcelDetailsData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (rideDetailsdata != null) {
      data['data'] = rideDetailsdata!.toJson();
    }
    return data;
  }
}

class ParcelDetailsData {
  String? id;
  String? idUserApp;
  String? idConducteur;
  String? source;
  String? destination;
  String? latSource;
  String? lngSource;
  String? latDestination;
  String? lngDestination;
  String? sourceCity;
  String? destinationCity;
  String? senderName;
  String? senderPhone;
  String? receiverName;
  String? receiverPhone;
  String? parcelWeight;
  List<String>? parcelImage;
  String? parcelType;
  String? parcelDate;
  String? parcelTime;
  String? receiveDate;
  String? receiveTime;
  String? status;
  String? note;
  String? paymentStatus;
  String? idPaymentMethod;
  String? duration;
  String? distance;
  String? distanceUnit;
  String? amount;
  String? discount;
  List<TaxModel>? taxModel;
  String? adminCommission;
  String? otp;
  String? rejectedDriverId;
  String? createdAt;
  String? updatedAt;
  String? libelle;
  String? paymentImage;
  String? title;
  String? phone;
  String? nomConducteur;
  String? prenomConducteur;
  String? driverPhone;
  String? photoPath;
  String? moyenne;
  String? moyenneDriver;
  String? userPhone;
  String? userPhoto;
  String? userName;
  String? driverName;
  String? driverId;
  String? tip;
  String? driverPhoto;

  ParcelDetailsData({
    this.id,
    this.idUserApp,
    this.idConducteur,
    this.source,
    this.destination,
    this.latSource,
    this.lngSource,
    this.latDestination,
    this.lngDestination,
    this.sourceCity,
    this.destinationCity,
    this.senderName,
    this.senderPhone,
    this.receiverName,
    this.receiverPhone,
    this.parcelWeight,
    this.parcelImage,
    this.parcelType,
    this.parcelDate,
    this.parcelTime,
    this.receiveDate,
    this.receiveTime,
    this.status,
    this.note,
    this.paymentStatus,
    this.idPaymentMethod,
    this.duration,
    this.distance,
    this.distanceUnit,
    this.amount,
    this.discount,
    this.taxModel,
    this.adminCommission,
    this.otp,
    this.rejectedDriverId,
    this.createdAt,
    this.updatedAt,
    this.libelle,
    this.paymentImage,
    this.title,
    this.phone,
    this.nomConducteur,
    this.prenomConducteur,
    this.driverPhone,
    this.photoPath,
    this.moyenne,
    this.moyenneDriver,
    this.userPhone,
    this.userPhoto,
    this.userName,
    this.driverName,
    this.driverId,
    this.driverPhoto,
    this.tip,
  });

  ParcelDetailsData.fromJson(Map<String, dynamic> json) {
    List<TaxModel>? taxList = [];
    if (json['tax'] != null) {
      taxList = <TaxModel>[];
      json['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    id = json['id'].toString();
    idUserApp = json['id_user_app'];
    idConducteur = json['id_conducteur'];
    source = json['source'];
    destination = json['destination'];
    latSource = json['lat_source'];
    lngSource = json['lng_source'];
    latDestination = json['lat_destination'];
    lngDestination = json['lng_destination'];
    sourceCity = json['source_city'];
    destinationCity = json['destination_city'];
    senderName = json['sender_name'];
    senderPhone = json['sender_phone'];
    receiverName = json['receiver_name'];
    receiverPhone = json['receiver_phone'];
    parcelWeight = json['parcel_weight'];
    parcelImage = json['parcel_image'].cast<String>();
    parcelType = json['parcel_type'];
    parcelDate = json['parcel_date'];
    parcelTime = json['parcel_time'];
    receiveDate = json['receive_date'];
    receiveTime = json['receive_time'];
    status = json['status'];
    note = json['note'].toString();
    paymentStatus = json['payment_status'];
    idPaymentMethod = json['id_payment_method'];
    duration = json['duration'];
    distance = json['distance'];
    distanceUnit = json['distance_unit'];
    amount = json['amount'];
    discount = json['discount'];
    taxModel = taxList;
    adminCommission = json['admin_commission'];
    otp = json['otp'].toString();
    rejectedDriverId = json['rejected_driver_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    libelle = json['libelle'];
    paymentImage = json['payment_image'];
    title = json['title'];
    phone = json['phone'];
    nomConducteur = json['nomConducteur'];
    prenomConducteur = json['prenomConducteur'];
    driverPhone = json['driver_phone'];
    photoPath = json['photo_path'];
    moyenne = json['moyenne'];
    moyenneDriver = json['moyenne_driver'];
    userPhone = json['user_phone'];
    userPhoto = json['user_photo'];
    userName = json['user_name'];
    driverId = json['driver_id'];
    driverName = json['driver_name'];
    driverPhoto = json['driver_photo'];
    tip = json['tip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['id_conducteur'] = idConducteur;
    data['source'] = source;
    data['destination'] = destination;
    data['lat_source'] = latSource;
    data['lng_source'] = lngSource;
    data['lat_destination'] = latDestination;
    data['lng_destination'] = lngDestination;
    data['source_city'] = sourceCity;
    data['destination_city'] = destinationCity;
    data['sender_name'] = senderName;
    data['sender_phone'] = senderPhone;
    data['receiver_name'] = receiverName;
    data['receiver_phone'] = receiverPhone;
    data['parcel_weight'] = parcelWeight;
    data['parcel_image'] = parcelImage;
    data['parcel_type'] = parcelType;
    data['parcel_date'] = parcelDate;
    data['parcel_time'] = parcelTime;
    data['receive_date'] = receiveDate;
    data['receive_time'] = receiveTime;
    data['status'] = status;
    data['note'] = note;
    data['payment_status'] = paymentStatus;
    data['id_payment_method'] = idPaymentMethod;
    data['duration'] = duration;
    data['distance'] = distance;
    data['distance_unit'] = distanceUnit;
    data['amount'] = amount;
    data['discount'] = discount;
    data['tax'] = taxModel?.map((v) => v.toJson()).toList();
    data['admin_commission'] = adminCommission;
    data['otp'] = otp;
    data['rejected_driver_id'] = rejectedDriverId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['libelle'] = libelle;
    data['payment_image'] = paymentImage;
    data['title'] = title;
    data['phone'] = phone;
    data['nomConducteur'] = nomConducteur;
    data['prenomConducteur'] = prenomConducteur;
    data['photo_path'] = photoPath;
    data['moyenne'] = moyenne;
    data['moyenne_driver'] = moyenneDriver;
    data['user_phone'] = userPhone;
    data['user_photo'] = userPhoto;
    data['user_name'] = userName;
    data['driver_id'] = driverId;
    data['driver_name'] = driverName;
    data['driver_phone'] = driverPhone;
    data['driver_photo'] = driverPhoto;
    data['tip'] = tip;
    return data;
  }
}
