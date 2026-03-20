import 'package:equatable/equatable.dart';
import '../../../../models/book.dart';
import '../../../../models/business.dart';

abstract class BuyerHomeState extends Equatable {
  const BuyerHomeState();

  @override
  List<Object?> get props => [];
}

class BuyerHomeLoading extends BuyerHomeState {}

class BuyerHomeLoaded extends BuyerHomeState {
  final List<Book> allBooks;
  final List<Book> donateBooks;
  final List<Business> stores;
  final List<String> categories;

  const BuyerHomeLoaded({
    required this.allBooks,
    required this.donateBooks,
    required this.stores,
    required this.categories,
  });

  @override
  List<Object?> get props => [allBooks, donateBooks, stores, categories];
}

class BuyerHomeError extends BuyerHomeState {
  final String message;

  const BuyerHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
