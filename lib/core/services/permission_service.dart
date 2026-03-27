enum AppPermission { notification, microphone, storage, camera }

enum PermissionState { granted, denied, permanentlyDenied, limited }

abstract interface class PermissionService {
  Future<PermissionState> check(AppPermission permission);

  Future<PermissionState> request(AppPermission permission);
}

class NoopPermissionService implements PermissionService {
  const NoopPermissionService();

  @override
  Future<PermissionState> check(AppPermission permission) async {
    return PermissionState.denied;
  }

  @override
  Future<PermissionState> request(AppPermission permission) async {
    return PermissionState.denied;
  }
}
