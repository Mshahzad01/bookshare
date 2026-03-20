import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/book.dart';
import '../../../../models/business.dart';

class BuyerDataSource {
  final FirebaseFirestore _firestore;

  BuyerDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Book>> getAllBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();
      final books = snapshot.docs
          .map((doc) => Book.fromMap(doc.data(), doc.id))
          .toList();
      books.sort((a, b) => b.postedDate.compareTo(a.postedDate));
      return books;
    } catch (e) {
      print("Error fetching all books: $e");
      return [];
    }
  }

  Future<List<Business>> getAllBusinesses() async {
    try {
      final snapshot = await _firestore.collection('businesses').get();
      final businesses = snapshot.docs
          .map((doc) => Business.fromMap(doc.data(), doc.id))
          .toList();
      businesses.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return businesses;
    } catch (e) {
      print("Error fetching businesses: $e");
      return [];
    }
  }
}
