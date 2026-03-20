import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum UserRole { buyer, seller, driver }

class ProfileRoleState extends Equatable {
  final UserRole selectedRole;
  final int appNavIndex;

  const ProfileRoleState({
    this.selectedRole = UserRole.buyer,
    this.appNavIndex = 0,
  });

  ProfileRoleState copyWith({
    UserRole? selectedRole,
    int? appNavIndex,
  }) {
    return ProfileRoleState(
      selectedRole: selectedRole ?? this.selectedRole,
      appNavIndex: appNavIndex ?? this.appNavIndex,
    );
  }

  @override
  List<Object> get props => [selectedRole, appNavIndex];
}

class ProfileRoleCubit extends Cubit<ProfileRoleState> {
  ProfileRoleCubit() : super(const ProfileRoleState());

  void setRole(UserRole role) => emit(state.copyWith(selectedRole: role));
  void setAppNavIndex(int index) => emit(state.copyWith(appNavIndex: index));
}
