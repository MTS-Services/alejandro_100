class DriverDetailsModel {
  String? success;
  dynamic error;
  String? message;
  Data? data;

  DriverDetailsModel({this.success, this.error, this.message, this.data});

  DriverDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? nom;
  String? prenom;
  String? cnib;
  String? phone;
  String? mdp;
  String? latitude;
  String? longitude;
  String? email;
  String? statut;
  String? statutVehicule;
  String? statusCarImage;
  String? online;
  String? loginType;
  dynamic photo;
  dynamic photoPath;
  dynamic photoLicence;
  dynamic photoLicencePath;
  dynamic photoNic;
  dynamic photoNicPath;
  dynamic photoCarServiceBook;
  dynamic photoCarServiceBookPath;
  dynamic photoRoadWorthy;
  dynamic photoRoadWorthyPath;
  String? tonotify;
  dynamic deviceId;
  String? fcmId;
  String? address;
  dynamic bankName;
  dynamic branchName;
  dynamic holderName;
  dynamic accountNo;
  dynamic otherInfo;
  dynamic ifscCode;
  String? creer;
  String? modifier;
  String? updatedAt;
  String? amount;
  dynamic resetPasswordOtp;
  dynamic resetPasswordOtpModifier;
  dynamic deletedAt;
  int? isVerified;
  String? parcelDelivery;
  String? zoneId;
  String? subscriptionPlanId;
  dynamic subscriptionExpiryDate;
  String? subscriptionTotalOrders;
  SubscriptionPlan? subscriptionPlan;
  AdminCommission? adminCommission;
  String? driverOnRide;
  String? photoUrl;
  String? brand;
  String? model;
  String? totalCompletedRide;
  String? moyenne;
  List<Documents>? documents;
  Vehicle? vehicle;

  Data(
      {this.id,
      this.nom,
      this.prenom,
      this.cnib,
      this.phone,
      this.mdp,
      this.latitude,
      this.longitude,
      this.email,
      this.statut,
      this.statutVehicule,
      this.statusCarImage,
      this.online,
      this.loginType,
      this.photo,
      this.photoPath,
      this.photoLicence,
      this.photoLicencePath,
      this.photoNic,
      this.photoNicPath,
      this.photoCarServiceBook,
      this.photoCarServiceBookPath,
      this.photoRoadWorthy,
      this.photoRoadWorthyPath,
      this.tonotify,
      this.deviceId,
      this.fcmId,
      this.address,
      this.bankName,
      this.branchName,
      this.holderName,
      this.accountNo,
      this.otherInfo,
      this.ifscCode,
      this.creer,
      this.modifier,
      this.updatedAt,
      this.amount,
      this.resetPasswordOtp,
      this.resetPasswordOtpModifier,
      this.deletedAt,
      this.isVerified,
      this.parcelDelivery,
      this.zoneId,
      this.subscriptionPlanId,
      this.subscriptionExpiryDate,
      this.subscriptionTotalOrders,
      this.subscriptionPlan,
      this.adminCommission,
      this.driverOnRide,
      this.photoUrl,
      this.brand,
      this.model,
      this.totalCompletedRide,
      this.moyenne,
      this.documents,
      this.vehicle});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    cnib = json['cnib'];
    phone = json['phone'];
    mdp = json['mdp'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    email = json['email'];
    statut = json['statut'];
    statutVehicule = json['statut_vehicule'];
    statusCarImage = json['status_car_image'];
    online = json['online'];
    loginType = json['login_type'];
    photo = json['photo'];
    photoPath = json['photo_path'];
    photoLicence = json['photo_licence'];
    photoLicencePath = json['photo_licence_path'];
    photoNic = json['photo_nic'];
    photoNicPath = json['photo_nic_path'];
    photoCarServiceBook = json['photo_car_service_book'];
    photoCarServiceBookPath = json['photo_car_service_book_path'];
    photoRoadWorthy = json['photo_road_worthy'];
    photoRoadWorthyPath = json['photo_road_worthy_path'];
    tonotify = json['tonotify'];
    deviceId = json['device_id'];
    fcmId = json['fcm_id'];
    address = json['address'];
    bankName = json['bank_name'];
    branchName = json['branch_name'];
    holderName = json['holder_name'];
    accountNo = json['account_no'];
    otherInfo = json['other_info'];
    ifscCode = json['ifsc_code'];
    creer = json['creer'];
    modifier = json['modifier'];
    updatedAt = json['updated_at'];
    amount = json['amount'];
    resetPasswordOtp = json['reset_password_otp'];
    resetPasswordOtpModifier = json['reset_password_otp_modifier'];
    deletedAt = json['deleted_at'];
    isVerified = json['is_verified'];
    parcelDelivery = json['parcel_delivery'];
    zoneId = json['zone_id'];
    subscriptionPlanId = json['subscriptionPlanId'];
    subscriptionExpiryDate = json['subscriptionExpiryDate'];
    subscriptionTotalOrders = json['subscriptionTotalOrders'];
    subscriptionPlan = json['subscription_plan'] != null
        ? SubscriptionPlan.fromJson(json['subscription_plan'])
        : null;
    adminCommission = json['adminCommission'] != null
        ? AdminCommission.fromJson(json['adminCommission'])
        : null;
    driverOnRide = json['driver_on_ride'];
    photoUrl = json['photo_url'];
    brand = json['brand'];
    model = json['model'];
    totalCompletedRide = json['total_completed_ride'];
    moyenne = json['moyenne'];
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['cnib'] = cnib;
    data['phone'] = phone;
    data['mdp'] = mdp;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['email'] = email;
    data['statut'] = statut;
    data['statut_vehicule'] = statutVehicule;
    data['status_car_image'] = statusCarImage;
    data['online'] = online;
    data['login_type'] = loginType;
    data['photo'] = photo;
    data['photo_path'] = photoPath;
    data['photo_licence'] = photoLicence;
    data['photo_licence_path'] = photoLicencePath;
    data['photo_nic'] = photoNic;
    data['photo_nic_path'] = photoNicPath;
    data['photo_car_service_book'] = photoCarServiceBook;
    data['photo_car_service_book_path'] = photoCarServiceBookPath;
    data['photo_road_worthy'] = photoRoadWorthy;
    data['photo_road_worthy_path'] = photoRoadWorthyPath;
    data['tonotify'] = tonotify;
    data['device_id'] = deviceId;
    data['fcm_id'] = fcmId;
    data['address'] = address;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['holder_name'] = holderName;
    data['account_no'] = accountNo;
    data['other_info'] = otherInfo;
    data['ifsc_code'] = ifscCode;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['amount'] = amount;
    data['reset_password_otp'] = resetPasswordOtp;
    data['reset_password_otp_modifier'] = resetPasswordOtpModifier;
    data['deleted_at'] = deletedAt;
    data['is_verified'] = isVerified;
    data['parcel_delivery'] = parcelDelivery;
    data['zone_id'] = zoneId;
    data['subscriptionPlanId'] = subscriptionPlanId;
    data['subscriptionExpiryDate'] = subscriptionExpiryDate;
    data['subscriptionTotalOrders'] = subscriptionTotalOrders;
    if (subscriptionPlan != null) {
      data['subscription_plan'] = subscriptionPlan!.toJson();
    }
    if (adminCommission != null) {
      data['adminCommission'] = adminCommission!.toJson();
    }
    data['driver_on_ride'] = driverOnRide;
    data['photo_url'] = photoUrl;
    data['brand'] = brand;
    data['model'] = model;
    data['total_completed_ride'] = totalCompletedRide;
    data['moyenne'] = moyenne;
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    return data;
  }
}

class SubscriptionPlan {
  String? id;
  String? name;
  String? type;
  String? image;
  String? place;
  String? price;
  String? isEnable;
  String? expiryDay;
  String? createdAt;
  String? updatedAt;
  String? description;
  List<String>? planPoints;
  String? bookingLimit;

  SubscriptionPlan(
      {this.id,
      this.name,
      this.type,
      this.image,
      this.place,
      this.price,
      this.isEnable,
      this.expiryDay,
      this.createdAt,
      this.updatedAt,
      this.description,
      this.planPoints,
      this.bookingLimit});

  SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    image = json['image'];
    place = json['place'];
    price = json['price'];
    isEnable = json['isEnable'];
    expiryDay = json['expiryDay'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    description = json['description'];
    planPoints = json['plan_points'].cast<String>();
    bookingLimit = json['bookingLimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['image'] = image;
    data['place'] = place;
    data['price'] = price;
    data['isEnable'] = isEnable;
    data['expiryDay'] = expiryDay;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['description'] = description;
    data['plan_points'] = planPoints;
    data['bookingLimit'] = bookingLimit;
    return data;
  }
}

class AdminCommission {
  String? type;
  String? value;

  AdminCommission({this.type, this.value});

  AdminCommission.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['value'] = value;
    return data;
  }
}

class Documents {
  String? id;
  String? title;
  String? documentPath;
  String? documentStatus;
  String? comment;

  Documents(
      {this.id,
      this.title,
      this.documentPath,
      this.documentStatus,
      this.comment});

  Documents.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    documentPath = json['document_path'];
    documentStatus = json['document_status'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['document_path'] = documentPath;
    data['document_status'] = documentStatus;
    data['comment'] = comment;
    return data;
  }
}

class Vehicle {
  String? id;
  String? brand;
  String? model;
  String? carMake;
  String? milage;
  String? km;
  String? color;
  String? numberplate;
  String? passenger;
  String? idConducteur;
  String? statut;
  String? creer;
  String? modifier;
  String? updatedAt;
  dynamic deletedAt;
  String? idTypeVehicule;
  VehicleType? vehicleType;

  Vehicle(
      {this.id,
      this.brand,
      this.model,
      this.carMake,
      this.milage,
      this.km,
      this.color,
      this.numberplate,
      this.passenger,
      this.idConducteur,
      this.statut,
      this.creer,
      this.modifier,
      this.updatedAt,
      this.deletedAt,
      this.idTypeVehicule,
      this.vehicleType});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    brand = json['brand'];
    model = json['model'];
    carMake = json['car_make'];
    milage = json['milage'];
    km = json['km'];
    color = json['color'];
    numberplate = json['numberplate'];
    passenger = json['passenger'];
    idConducteur = json['id_conducteur'];
    statut = json['statut'];
    creer = json['creer'];
    modifier = json['modifier'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    idTypeVehicule = json['id_type_vehicule'];
    vehicleType = json['vehicle_type'] != null
        ? VehicleType.fromJson(json['vehicle_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['model'] = model;
    data['car_make'] = carMake;
    data['milage'] = milage;
    data['km'] = km;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['id_conducteur'] = idConducteur;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['id_type_vehicule'] = idTypeVehicule;
    if (vehicleType != null) {
      data['vehicle_type'] = vehicleType!.toJson();
    }
    return data;
  }
}

class VehicleType {
  String? id;
  String? libelle;
  String? prix;
  String? image;
  String? selectedImage;
  String? status;
  String? creer;
  String? modifier;
  String? updatedAt;
  dynamic deletedAt;

  VehicleType(
      {this.id,
      this.libelle,
      this.prix,
      this.image,
      this.selectedImage,
      this.status,
      this.creer,
      this.modifier,
      this.updatedAt,
      this.deletedAt});

  VehicleType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    libelle = json['libelle'];
    prix = json['prix'];
    image = json['image'];
    selectedImage = json['selected_image'];
    status = json['status'];
    creer = json['creer'];
    modifier = json['modifier'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
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
    return data;
  }
}
