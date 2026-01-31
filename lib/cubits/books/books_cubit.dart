import 'package:flutter_bloc/flutter_bloc.dart';
import 'books_state.dart';
import '../../data/dummy_data.dart';

class BooksCubit extends Cubit<BooksState> {
  BooksCubit() : super(BooksLoading());

  void loadAllBooks() async {
    emit(BooksLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(BooksLoaded(books: DummyData.getAllBooks()));
  }

  void loadBooksByCategory(String category) async {
    emit(BooksLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    emit(BooksLoaded(
      books: DummyData.getBooksByCategory(category),
      selectedCategory: category,
    ));
  }

  void searchBooks(String query) async {
    emit(BooksLoading());
    await Future.delayed(const Duration(milliseconds: 500));
    
    final allBooks = DummyData.getAllBooks();
    final filteredBooks = allBooks.where((book) {
      return book.title.toLowerCase().contains(query.toLowerCase()) ||
             book.author.toLowerCase().contains(query.toLowerCase()) ||
             book.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
    
    emit(BooksLoaded(books: filteredBooks));
  }
}
