import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';
import '../../data/dummy_data.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeLoading());

  void loadHomeData() async {
    emit(HomeLoading());
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    emit(HomeLoaded(
      banners: DummyData.banners,
      categories: DummyData.categories,
      donateBooks: DummyData.donateBooks,
      nearbyBooks: DummyData.nearbyBooks,
      currentLocation: DummyData.currentUser.location,
    ));
  }

  void updateLocation(String newLocation) {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      emit(HomeLoaded(
        banners: currentState.banners,
        categories: currentState.categories,
        donateBooks: currentState.donateBooks,
        nearbyBooks: currentState.nearbyBooks,
        currentLocation: newLocation,
      ));
    }
  }
}
