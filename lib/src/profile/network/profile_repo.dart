import '../../../models/user.dart';
import 'profile_data_src.dart';

class ProfileRepository {
  final ProfileDataSource _dataSource;

  ProfileRepository({
    ProfileDataSource? dataSource,
  }) : _dataSource = dataSource ?? ProfileDataSource();

  Future<User?> getProfile(String uid) async {
    final map = await _dataSource.getUserProfile(uid);
    if (map != null) {
      return User.fromMap(map, uid);
    }
    return null;
  }

  Future<void> updateProfile({
    required String uid,
    String? name,
    String? location,
    String? avatarUrl,
    String? phoneNumber,
    String? accountType,
  }) async {
    await _dataSource.updateUserProfile(
      uid: uid,
      name: name,
      location: location,
      avatarUrl: avatarUrl,
      phoneNumber: phoneNumber,
      accountType: accountType,
    );
  }
}
