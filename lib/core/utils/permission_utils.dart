import 'package:lumos/core/services/permission_service.dart';

abstract final class PermissionUtils {
  static bool isGranted(PermissionState state) {
    return state == PermissionState.granted || state == PermissionState.limited;
  }

  static bool isDenied(PermissionState state) {
    return state == PermissionState.denied;
  }

  static bool requiresManualEnable(PermissionState state) {
    return state == PermissionState.permanentlyDenied;
  }

  static bool canRequestAgain(PermissionState state) {
    return state == PermissionState.denied;
  }
}
