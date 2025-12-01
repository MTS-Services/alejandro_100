class GetParcelCategoryModel {
  String? success;
  dynamic error;
  String? message;
  List<ParcelCategoryData>? data;

  GetParcelCategoryModel({this.success, this.error, this.message, this.data});

  GetParcelCategoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ParcelCategoryData>[];
      json['data'].forEach((v) {
        data!.add(ParcelCategoryData.fromJson(v));
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

class ParcelCategoryData {
  String? id;
  String? title;
  String? image;
  String? status;
  String? createdAt;
  String? updatedAt;

  ParcelCategoryData({this.id, this.title, this.image, this.status, this.createdAt, this.updatedAt});

  ParcelCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
