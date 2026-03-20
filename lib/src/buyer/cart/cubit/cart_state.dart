import 'package:equatable/equatable.dart';
import '../../../../models/book.dart';

class CartState extends Equatable {
  final List<Book> items;

  const CartState({this.items = const []});

  double get subtotal {
    return items.fold(0.0, (sum, book) => sum + (book.price ?? 0.0));
  }

  CartState copyWith({List<Book>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
