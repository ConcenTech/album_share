import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/user_detail.dart';
import '../../services/database/database_service.dart';

// ignore: must_be_immutable
class UserAvatar extends StatelessWidget {
  final UserDetail user;
  double radius;
  double size;

  UserAvatar({
    super.key,
    this.radius = 22,
    this.size = 44,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final endpoint = DatabaseService.instance.getEndpointSync();
    final token = DatabaseService.instance.getAuthTokenSync();
    final profileImageUrl =
        '${endpoint.serverUrl}/api/users/${user.id}/profile-image?d=1';
    final headers = <String, String>{'x-immich-user-token': token};

    final textIcon = Center(
      child: Text(
        user.name[0].toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: isDarkTheme && user.avatarColor == AvatarColor.primary
              ? Colors.black
              : Colors.white,
        ),
      ),
    );
    return CircleAvatar(
      backgroundColor: user.avatarColor.value(isDarkTheme),
      radius: radius,
      child: user.profileImagePath.isEmpty
          ? textIcon
          : ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                cacheKey: user.profileImagePath,
                width: size,
                height: size,
                imageUrl: profileImageUrl,
                httpHeaders: headers,
                fadeInDuration: const Duration(milliseconds: 300),
                errorWidget: (context, error, stackTrace) {
                  return textIcon;
                },
              ),
            ),
    );
  }
}
