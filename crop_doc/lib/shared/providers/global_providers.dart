import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crop_doc/core/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});
