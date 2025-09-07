class ResponseModel {
  bool? success;
  String? message;
  UserData? data;
  String? token;

  ResponseModel({this.success, this.message, this.data, this.token});

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    final tokenFromData = json['data'] is Map<String, dynamic>
        ? json['data']['token'] as String?
        : null;

    // Extract token from root level if it exists there
    final tokenFromRoot = json['token'] as String?;

    return ResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? UserData.fromJson(json['data'] is Map<String, dynamic> &&
                  json['data']['user'] != null
              ? json['data']['user'] as Map<String, dynamic>
              : json['data'] as Map<String, dynamic>)
          : null,
      token: tokenFromData ?? tokenFromRoot,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
      'token': token
    };
  }
}

class UserData {
  int? id;
  String? username;
  String? email;
  String? phone;
  String? countryCode;
  String? emailVerifiedAt;
  String? phoneVerifiedAt;
  String? image;
  int? notificationsEnabled;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? token;

  UserData(
      {this.id,
      this.username,
      this.email,
      this.phone,
      this.countryCode,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.image,
      this.notificationsEnabled,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.token});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int?,
      username: json['username'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      countryCode: json['country_code'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      phoneVerifiedAt: json['phone_verified_at'] as String?,
      image: json['image'] as String?,
      notificationsEnabled: json['notifications_enabled'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      'email_verified_at': emailVerifiedAt,
      'phone_verified_at': phoneVerifiedAt,
      'image': image,
      'notifications_enabled': notificationsEnabled,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'token': token,
    };
  }
}
