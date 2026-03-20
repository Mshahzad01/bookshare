import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/book.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addToCart(Book book) {
    if (state.items.any((b) => b.id == book.id)) {
      return; // Already in cart (avoid duplicates since books are unique items)
    }
    final updatedList = List<Book>.from(state.items)..add(book);
    emit(state.copyWith(items: updatedList));
  }

  void removeFromCart(String bookId) {
    final updatedList = state.items.where((b) => b.id != bookId).toList();
    emit(state.copyWith(items: updatedList));
  }

  void clearCart() {
    emit(const CartState(items: []));
  }
}
