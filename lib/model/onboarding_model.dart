class OnboardingModel {
  final String? success;
  final String? error;
  final String? message;
  final List<OnboardingData>? data;

  OnboardingModel({
    this.success,
    this.error,
    this.message,
    this.data,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<OnboardingData> dataList = list.map((i) => OnboardingData.fromJson(i)).toList();

    return OnboardingModel(
      success: json['success'],
      error: json['error'],
      message: json['message'],
      data: dataList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'error': error,
      'message': message,
      'data': data?.map((screen) => screen.toJson()).toList(),
    };
  }
}

class OnboardingData {
  final String? id;
  final String? type;
  final String? title;
  final String? description;
  final String? image;

  OnboardingData({
    this.id,
    this.type,
    this.title,
    this.description,
    this.image,
  });

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      id: json['id'],
      type: json['type'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
