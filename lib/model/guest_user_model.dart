class GuestUserModel {
  String? fullName;
  String? phone;
  String? email;
  String? idNumber;
  String? address;
  
  GuestUserModel({
    this.fullName, 
    this.phone, 
    this.email, 
    this.idNumber, 
    this.address
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['guest_fullname'] = fullName;
    data['guest_phone'] = phone;
    data['guest_email'] = email;
    data['guest_id_number'] = idNumber;
    data['guest_address'] = address;
    data['is_guest_order'] = true;
    return data;
  }
  
  GuestUserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['guest_fullname'];
    phone = json['guest_phone'];
    email = json['guest_email'];
    idNumber = json['guest_id_number'];
    address = json['guest_address'];
  }
} 