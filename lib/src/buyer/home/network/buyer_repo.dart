import '../../../../models/book.dart';
import '../../../../models/business.dart';
import 'buyer_data_src.dart';

class BuyerRepository {
  final BuyerDataSource _dataSource;

  BuyerRepository({BuyerDataSource? dataSource}) 
      : _dataSource = dataSource ?? BuyerDataSource();

  Future<List<Book>> getAllBooks() async {
    return await _dataSource.getAllBooks();
  }

  Future<List<Business>> getAllBusinesses() async {
    return await _dataSource.getAllBusinesses();
  }
}
