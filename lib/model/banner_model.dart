class BannerModel {
  String? success;
  String? error;
  String? message;
  List<BannerModelData>? data;

  BannerModel({this.success, this.error, this.message, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BannerModelData>[];
      json['data'].forEach((v) {
        data!.add(BannerModelData.fromJson(v));
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

class BannerModelData {
  String id;
  String title;
  String description;
  String image;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  BannerModelData({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BannerModelData.fromJson(Map<String, dynamic> json) {
    return BannerModelData(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
