import 'package:equatable/equatable.dart';
import '../../../../models/business.dart';
import '../../../../models/book.dart';

abstract class SellerState extends Equatable {
  const SellerState();

  @override
  List<Object?> get props => [];
}

class SellerLoading extends SellerState {}

class SellerNoBusiness extends SellerState {}

class SellerDashboardReady extends SellerState {
  final Business business;
  final List<Book> books;
  final bool isUploadingBook;

  const SellerDashboardReady({
    required this.business,
    required this.books,
    this.isUploadingBook = false,
  });

  SellerDashboardReady copyWith({
    Business? business,
    List<Book>? books,
    bool? isUploadingBook,
  }) {
    return SellerDashboardReady(
      business: business ?? this.business,
      books: books ?? this.books,
      isUploadingBook: isUploadingBook ?? this.isUploadingBook,
    );
  }

  @override
  List<Object?> get props => [business, books, isUploadingBook];
}

class SellerError extends SellerState {
  final String message;

  const SellerError(this.message);

  @override
  List<Object?> get props => [message];
}
