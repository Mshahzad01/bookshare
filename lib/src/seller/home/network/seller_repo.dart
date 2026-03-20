import 'dart:io';
import '../../../../models/business.dart';
import '../../../../models/book.dart';
import '../../../services/cloudnary_services.dart';
import 'seller_data_src.dart';

class SellerRepository {
  final SellerDataSource _dataSource;
  final CloudinaryService _cloudinaryService;

  SellerRepository({
    SellerDataSource? dataSource,
    CloudinaryService? cloudinaryService,
  })  : _dataSource = dataSource ?? SellerDataSource(),
        _cloudinaryService = cloudinaryService ?? CloudinaryService();

  Future<Business?> getBusiness(String uid) async {
    return await _dataSource.getBusiness(uid);
  }

  Future<void> createBusiness(Business business) async {
    await _dataSource.createBusiness(business);
  }

  Future<void> updateBusiness(Business business) async {
    await _dataSource.updateBusiness(business);
  }

  Future<String?> uploadBookImage(File imageFile) async {
    return await _cloudinaryService.uploadImage(imageFile);
  }

  Future<void> addBook(Book book) async {
    await _dataSource.addBook(book);
  }

  Future<void> updateBook(Book book) async {
    await _dataSource.updateBook(book);
  }

  Future<List<Book>> getSellerBooks(String sellerId) async {
    return await _dataSource.getSellerBooks(sellerId);
  }
}
