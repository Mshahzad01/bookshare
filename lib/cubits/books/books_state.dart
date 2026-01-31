import 'package:equatable/equatable.dart';
import '../../models/book.dart';

abstract class BooksState extends Equatable {
  const BooksState();

  @override
  List<Object> get props => [];
}

class BooksLoading extends BooksState {}

class BooksLoaded extends BooksState {
  final List<Book> books;
  final String? selectedCategory;

  const BooksLoaded({
    required this.books,
    this.selectedCategory,
  });

  @override
  List<Object> get props => [books, selectedCategory ?? ''];
}

class BooksError extends BooksState {
  final String message;

  const BooksError(this.message);

  @override
  List<Object> get props => [message];
}
