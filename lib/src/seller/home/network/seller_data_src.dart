import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../models/business.dart';
import '../../../../models/book.dart';

class SellerDataSource {
  final FirebaseFirestore _firestore;

  SellerDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Business?> getBusiness(String uid) async {
    try {
      final doc = await _firestore.collection('businesses').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return Business.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print("Error fetching business: $e");
    }
    return null;
  }

  Future<void> createBusiness(Business business) async {
    await _firestore
        .collection('businesses')
        .doc(business.id)
        .set(business.toMap(), SetOptions(merge: true));
  }

  Future<void> updateBusiness(Business business) async {
    await _firestore
        .collection('businesses')
        .doc(business.id)
        .update(business.toMap());
  }

  Future<void> addBook(Book book) async {
    await _firestore.collection('books').doc(book.id).set(book.toMap());
  }

  Future<void> updateBook(Book book) async {
    await _firestore.collection('books').doc(book.id).update(book.toMap());
  }

  Future<List<Book>> getSellerBooks(String sellerId) async {
    try {
      final snapshot = await _firestore
          .collection('books')
          .where('sellerId', isEqualTo: sellerId)
          .get();
          
      final books = snapshot.docs
          .map((doc) => Book.fromMap(doc.data(), doc.id))
          .toList();
          
      // Local descending sort to avoid needing a Firestore Composite Index
      books.sort((a, b) => b.postedDate.compareTo(a.postedDate));
      
      return books;
    } catch (e) {
      print("Error fetching seller books: $e");
      return [];
    }
  }
}
