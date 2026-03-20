import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../../../models/business.dart';
import '../../../../models/book.dart';
import '../network/seller_repo.dart';
import 'seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  final SellerRepository _repository;

  SellerCubit({SellerRepository? repository})
      : _repository = repository ?? SellerRepository(),
        super(SellerLoading());

  Future<void> checkBusinessStatus() async {
    emit(SellerLoading());
    try {
      final uid = auth.FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(const SellerError("User not logged in"));
        return;
      }

      final business = await _repository.getBusiness(uid);
      if (business == null) {
        emit(SellerNoBusiness());
      } else {
        final books = await _repository.getSellerBooks(uid);
        emit(SellerDashboardReady(business: business, books: books));
      }
    } catch (e) {
      emit(SellerError(e.toString()));
    }
  }

  Future<void> registerBusiness({
    required String businessName,
    required String businessAddress,
    required String phoneNumber,
    required String businessType,
    String? logoUrl,
  }) async {
    emit(SellerLoading());
    try {
      final uid = auth.FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        emit(const SellerError("User not logged in"));
        return;
      }

      final newBusiness = Business(
        id: uid, 
        ownerId: uid,
        businessName: businessName,
        businessAddress: businessAddress,
        phoneNumber: phoneNumber,
        businessType: businessType,
        logoUrl: logoUrl,
        createdAt: DateTime.now(),
      );

      await _repository.createBusiness(newBusiness);
      emit(SellerDashboardReady(business: newBusiness, books: []));
    } catch (e) {
      emit(SellerError(e.toString()));
    }
  }

  Future<bool> postBook({
    required String title,
    required String author,
    required String description,
    required String condition,
    required String category,
    required double price,
    required bool isDonation,
    List<File>? imageFiles,
  }) async {
    if (state is SellerDashboardReady) {
      final currentState = state as SellerDashboardReady;
      emit(currentState.copyWith(isUploadingBook: true));

      try {
        final business = currentState.business;
        
        List<String> uploadedUrls = [];
        
        if (imageFiles != null) {
          for (var file in imageFiles) {
            final url = await _repository.uploadBookImage(file);
            if (url != null) uploadedUrls.add(url);
          }
        }

        if (uploadedUrls.isEmpty) {
           uploadedUrls.add("https://ui-avatars.com/api/?name=Book+Image&background=random"); 
        }

        final newBook = Book(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          author: author, 
          description: description,
          imageUrl: uploadedUrls.first,
          imageUrls: uploadedUrls,
          price: isDonation ? 0.0 : price,
          isDonation: isDonation,
          condition: condition,
          category: category,
          sellerId: business.ownerId,
          sellerName: business.businessName,
          location: business.businessAddress,
          distance: 0.0,
          postedDate: DateTime.now(),
        );

        await _repository.addBook(newBook);
        
        final updatedBooks = List<Book>.from(currentState.books)..insert(0, newBook);
        emit(currentState.copyWith(books: updatedBooks, isUploadingBook: false));
        return true;
      } catch (e) {
        print("Error posting book: $e");
        emit(currentState.copyWith(isUploadingBook: false));
        return false;
      }
    }
    return false;
  }

  Future<bool> editBook({
    required Book existingBook,
    required String title,
    required String author,
    required String description,
    required String condition,
    required String category,
    required double price,
    required bool isDonation,
    required List<String> keptImageUrls,
    List<File>? newImageFiles,
  }) async {
    if (state is SellerDashboardReady) {
      final currentState = state as SellerDashboardReady;
      emit(currentState.copyWith(isUploadingBook: true));

      try {
        List<String> finalUrls = List<String>.from(keptImageUrls);
        
        if (newImageFiles != null) {
          for (var file in newImageFiles) {
            final url = await _repository.uploadBookImage(file);
            if (url != null) finalUrls.add(url);
          }
        }

        if (finalUrls.isEmpty) {
           finalUrls.add("https://ui-avatars.com/api/?name=Book+Image&background=random"); 
        }

        final updatedBook = existingBook.copyWith(
          title: title,
          author: author,
          description: description,
          condition: condition,
          category: category,
          price: isDonation ? 0.0 : price,
          isDonation: isDonation,
          imageUrl: finalUrls.first,
          imageUrls: finalUrls,
        );

        await _repository.updateBook(updatedBook);
        
        final updatedBooks = currentState.books.map((b) => b.id == updatedBook.id ? updatedBook : b).toList();
        
        emit(currentState.copyWith(books: updatedBooks, isUploadingBook: false));
        return true;
      } catch (e) {
        print("Error editing book: $e");
        emit(currentState.copyWith(isUploadingBook: false));
        return false;
      }
    }
    return false;
  }

  Future<bool> updateBusinessDetails({
    required String businessName,
    required String businessAddress,
    required String phoneNumber,
    String? logoUrl,
  }) async {
    if (state is SellerDashboardReady) {
      final currentState = state as SellerDashboardReady;
      final currentBusiness = currentState.business;
      
      final updatedBusiness = currentBusiness.copyWith(
        businessName: businessName,
        businessAddress: businessAddress,
        phoneNumber: phoneNumber,
        logoUrl: logoUrl ?? currentBusiness.logoUrl,
      );

      try {
        await _repository.updateBusiness(updatedBusiness);
        emit(currentState.copyWith(business: updatedBusiness));
        return true;
      } catch (e) {
        print("Error updating business: $e");
        return false;
      }
    }
    return false;
  }
}
