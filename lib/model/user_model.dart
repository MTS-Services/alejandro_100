class UserModel {
  String? success;
  dynamic error;
  String? message;
  User? data;

  UserModel({this.success, this.error, this.message, this.data});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    success: json["success"]?.toString(),
    error: json["error"],
    message: json["message"]?.toString(),
    data: json["data"] != null ? User.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "message": message,
    "data": data?.toJson(),
  };
}

class User {
  String? id;
  String? nom;
  String? prenom;
  String? email;
  String? phone;
  String? loginType;
  dynamic photo;
  String? photoPath;
  dynamic photoNic;
  dynamic photoNicPath;
  String? statut;
  dynamic statutNic;
  String? tonotify;
  dynamic deviceId;
  dynamic fcmId;
  DateTime? creer;
  DateTime? updatedAt;
  DateTime? modifier;
  dynamic amount;
  dynamic resetPasswordOtp;
  dynamic resetPasswordOtpModifier;
  String? age;
  String? gender;
  dynamic deletedAt;
  dynamic createdAt;
  String? userCat;
  String? online;
  String? country;
  String? accesstoken;
  String? adminCommission;

  User({
    this.id,
    this.nom,
    this.prenom,
    this.email,
    this.phone,
    this.loginType,
    this.photo,
    this.photoPath,
    this.photoNic,
    this.photoNicPath,
    this.statut,
    this.statutNic,
    this.tonotify,
    this.deviceId,
    this.fcmId,
    this.creer,
    this.updatedAt,
    this.modifier,
    this.amount,
    this.resetPasswordOtp,
    this.resetPasswordOtpModifier,
    this.age,
    this.gender,
    this.deletedAt,
    this.createdAt,
    this.userCat,
    this.online,
    this.country,
    this.accesstoken,
    this.adminCommission,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"]?.toString(),
    nom: json["nom"]?.toString(),
    prenom: json["prenom"]?.toString(),
    email: json["email"]?.toString(),
    phone: json["phone"]?.toString(),
    loginType: json["login_type"]?.toString(),
    photo: json["photo"],
    photoPath: json["photo_path"]?.toString(),
    photoNic: json["photo_nic"],
    photoNicPath: json["photo_nic_path"],
    statut: json["statut"]?.toString(),
    statutNic: json["statut_nic"],
    tonotify: json["tonotify"]?.toString(),
    deviceId: json["device_id"],
    fcmId: json["fcm_id"],
    creer: _parseDate(json["creer"]),
    updatedAt: _parseDate(json["updated_at"]),
    modifier: _parseDate(json["modifier"]),
    amount: json["amount"],
    resetPasswordOtp: json["reset_password_otp"],
    resetPasswordOtpModifier: json["reset_password_otp_modifier"],
    age: json["age"]?.toString(),
    gender: json["gender"]?.toString(),
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"],
    userCat: json["user_cat"]?.toString(),
    online: json["online"]?.toString(),
    country: json["country"]?.toString(),
    accesstoken: json["accesstoken"]?.toString(),
    adminCommission: json["admin_commission"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom": nom,
    "prenom": prenom,
    "email": email,
    "phone": phone,
    "login_type": loginType,
    "photo": photo,
    "photo_path": photoPath,
    "photo_nic": photoNic,
    "photo_nic_path": photoNicPath,
    "statut": statut,
    "statut_nic": statutNic,
    "tonotify": tonotify,
    "device_id": deviceId,
    "fcm_id": fcmId,
    "creer": creer?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "modifier": modifier?.toIso8601String(),
    "amount": amount,
    "reset_password_otp": resetPasswordOtp,
    "reset_password_otp_modifier": resetPasswordOtpModifier,
    "age": age,
    "gender": gender,
    "deleted_at": deletedAt,
    "created_at": createdAt,
    "user_cat": userCat,
    "online": online,
    "country": country,
    "accesstoken": accesstoken,
    "admin_commission": adminCommission,
  };
}

/// Safe Date Parsing
DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.tryParse(value.toString());
  } catch (e) {
    return null;
  }
}
