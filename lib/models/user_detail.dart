import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

import 'json_map.dart';

part 'user_detail.g.dart';

@embedded
class UserDetail {
  final String id;
  final String email;
  final String name;
  final String profileImagePath;
  @enumerated
  final AvatarColor avatarColor;

  const UserDetail({
    this.id = '',
    this.email = '',
    this.name = '',
    this.profileImagePath = '',
    this.avatarColor = AvatarColor.primary,
  });

  factory UserDetail.fromJson(JsonMap json) {
    return UserDetail(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      profileImagePath: json['profileImagePath'] ?? '',
      avatarColor: AvatarColor.fromString(json['avatarColor']),
    );
  }
}

enum AvatarColor {
  primary,
  pink,
  red,
  yellow,
  blue,
  green,
  purple,
  orange,
  gray,
  amber,
  ;

  Color value(bool isDarkTheme) {
    switch (this) {
      case pink:
        return const Color.fromARGB(255, 244, 114, 182);
      case red:
        return const Color.fromARGB(255, 239, 68, 68);
      case yellow:
        return const Color.fromARGB(255, 234, 179, 8);
      case blue:
        return const Color.fromARGB(255, 59, 130, 246);
      case green:
        return const Color.fromARGB(255, 22, 163, 74);
      case purple:
        return const Color.fromARGB(255, 147, 51, 234);
      case orange:
        return const Color.fromARGB(255, 234, 88, 12);
      case gray:
        return const Color.fromARGB(255, 75, 85, 99);
      case amber:
        return const Color.fromARGB(255, 217, 119, 6);
      case primary:
        return isDarkTheme ? const Color(0xFFABCBFA) : const Color(0xFF4250AF);
    }
  }

  factory AvatarColor.fromString(String value) {
    return AvatarColor.values.firstWhere((v) => v.name == value);
  }
}
