
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  // Apne Cloudinary dashboard se "Cloud Name" yahan likhein
  final String cloudName = "dr7a9clpq"; 
  // Jo preset hum ne step 1 mein banaya tha
  final String uploadPreset = "BookShare"; 

  Future<void> uploadImage() async {
    final ImagePicker picker = ImagePicker();
    
    // 1. Gallery se image pick karein
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        final cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);

        // 2. Image upload karein
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(image.path, resourceType: CloudinaryResourceType.Image),
        );

        // 3. Upload ke baad URL mil jayega
        print("Image URL: ${response.secureUrl}");
        
      } on CloudinaryException catch (e) {
        print("Error: ${e.message}");
      }
    }
  }
}