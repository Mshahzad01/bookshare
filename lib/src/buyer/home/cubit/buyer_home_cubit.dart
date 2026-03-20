import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/buyer_repo.dart';
import 'buyer_home_state.dart';

class BuyerHomeCubit extends Cubit<BuyerHomeState> {
  final BuyerRepository _repository;

  BuyerHomeCubit({BuyerRepository? repository})
      : _repository = repository ?? BuyerRepository(),
        super(BuyerHomeLoading());

  Future<void> fetchHomeData() async {
    emit(BuyerHomeLoading());
    try {
      final books = await _repository.getAllBooks();
      final stores = await _repository.getAllBusinesses();
      
      final donateBooks = books.where((b) => b.isDonation).toList();
      
      // Extract unique categories dynamically, but ensure we maintain standard order or just show what's available
      final categoriesSet = books.map((b) => b.category).toSet();
      final categories = categoriesSet.toList()..sort();

      emit(BuyerHomeLoaded(
        allBooks: books,
        donateBooks: donateBooks,
        stores: stores,
        categories: categories,
      ));
    } catch (e) {
      emit(BuyerHomeError(e.toString()));
    }
  }
}
