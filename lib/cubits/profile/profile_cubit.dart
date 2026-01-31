import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_state.dart';
import '../../data/dummy_data.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileLoading());

  void loadProfile() async {
    emit(ProfileLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    
    emit(ProfileLoaded(
      user: DummyData.currentUser,
      myListings: DummyData.myListings,
    ));
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
}
