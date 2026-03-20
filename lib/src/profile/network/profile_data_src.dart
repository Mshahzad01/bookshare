import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileDataSource {
  final FirebaseFirestore _firestore;

  ProfileDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
    return null;
  }

  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? location,
    String? avatarUrl,
    String? phoneNumber,
    String? accountType,
  }) async {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (location != null) data['location'] = location;
    if (avatarUrl != null) data['avatarUrl'] = avatarUrl;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (accountType != null) data['accountType'] = accountType;
    
    data['updatedAt'] = FieldValue.serverTimestamp();

    // Use FirebaseAuth current user UID if available, otherwise fallback to the provided uid
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;
    final finalDocId = (currentUserUid != null && currentUserUid.isNotEmpty) ? currentUserUid : uid;
    
    // Store the document id inside the document as requested
    data['document_id'] = finalDocId;

    await _firestore.collection('users').doc(finalDocId).set(data, SetOptions(merge: true));
  }
}
