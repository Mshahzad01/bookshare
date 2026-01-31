import 'package:equatable/equatable.dart';
import '../../models/user.dart';
import '../../models/book.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final List<Book> myListings;
  final bool isDarkMode;

  const ProfileLoaded({
    required this.user,
    required this.myListings,
    this.isDarkMode = false,
  });

  ProfileLoaded copyWith({
    User? user,
    List<Book>? myListings,
    bool? isDarkMode,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      myListings: myListings ?? this.myListings,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }

  @override
  List<Object> get props => [user, myListings, isDarkMode];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}
