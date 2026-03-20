import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'profile_state.dart';
import '../../data/dummy_data.dart';
import '../../models/user.dart';
import '../../src/profile/network/profile_repo.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;

  ProfileCubit({ProfileRepository? repository}) 
      : _repository = repository ?? ProfileRepository(),
        super(ProfileLoading());

  void loadProfile() async {
    emit(ProfileLoading());
    try {
      final currentUserUid = auth.FirebaseAuth.instance.currentUser?.uid;
      User? user;
      
      if (currentUserUid != null) {
        user = await _repository.getProfile(currentUserUid);
      }

      if (user == null) {
        user = DummyData.currentUser;
      }

      emit(ProfileLoaded(
        user: user,
        myListings: DummyData.myListings,
      ));
    } catch (e) {
      print("Error loading profile: $e");
      emit(ProfileLoaded(
        user: DummyData.currentUser,
        myListings: DummyData.myListings,
      ));
    }
  }

  void toggleDarkMode() {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      emit(currentState.copyWith(isDarkMode: !currentState.isDarkMode));
    }
  }

  void updateLocation(String newLocation) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedUser = currentState.user.copyWith(location: newLocation);
      emit(currentState.copyWith(user: updatedUser));
    }
  }

  void markAsSold(String bookId) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedListings = currentState.myListings.map((book) {
        if (book.id == bookId) {
          return book.copyWith(isSold: true);
        }
        return book;
      }).toList();
      emit(currentState.copyWith(myListings: updatedListings));
    }
  }

  void deleteListing(String bookId) {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final updatedListings = currentState.myListings
          .where((book) => book.id != bookId)
          .toList();
      emit(currentState.copyWith(myListings: updatedListings));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String location,
    String? avatarUrl,
    String? phoneNumber,
    String? accountType,
  }) async {
    if (state is ProfileLoaded) {
      final currentState = state as ProfileLoaded;
      final user = currentState.user;
      final newAvatarUrl = avatarUrl ?? user.avatarUrl;
      
      try {
        await _repository.updateProfile(
          uid: user.id,
          name: name,
          location: location,
          avatarUrl: newAvatarUrl,
          phoneNumber: phoneNumber,
          accountType: accountType,
        );

        final updatedUser = user.copyWith(
          name: name,
          location: location,
          avatarUrl: newAvatarUrl,
          phoneNumber: phoneNumber,
          accountType: accountType,
        );
        
        emit(currentState.copyWith(user: updatedUser));
      } catch (e) {
        print('Error updating profile: $e');
      }
    }
  }
}
