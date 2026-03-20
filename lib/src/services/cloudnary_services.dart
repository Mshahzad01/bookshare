import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  // Apne Cloudinary dashboard se "Cloud Name" yahan likhein
  final String cloudName = "dr7a9clpq"; 
  // Jo preset hum ne step 1 mein banaya tha
  final String uploadPreset = "BookShare"; 

  Future<String?> uploadImage(File imageFile) async {
    try {
      final cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);

      // 2. Image upload karein
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, resourceType: CloudinaryResourceType.Image),
      );

      // 3. Upload ke baad URL mil jayega
      print("Image URL: ${response.secureUrl}");
      return response.secureUrl;
      
    } on CloudinaryException catch (e) {
      print("Error: ${e.message}");
      return null;
    }
  }
}