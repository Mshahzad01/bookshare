import 'package:equatable/equatable.dart';
import '../../models/book.dart';
import '../../models/banner_item.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<BannerItem> banners;
  final List<String> categories;
  final List<Book> donateBooks;
  final List<Book> nearbyBooks;
  final String currentLocation;

  const HomeLoaded({
    required this.banners,
    required this.categories,
    required this.donateBooks,
    required this.nearbyBooks,
    required this.currentLocation,
  });

  @override
  List<Object> get props => [banners, categories, donateBooks, nearbyBooks, currentLocation];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
