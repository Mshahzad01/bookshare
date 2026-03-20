import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String id;
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final List<String> imageUrls;
  final double? price;
  final bool isDonation;
  final String condition;
  final String category;
  final String sellerId;
  final String sellerName;
  final String location;
  final double distance;
  final bool isSold;
  final DateTime postedDate;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    this.imageUrls = const [],
    this.price,
    required this.isDonation,
    required this.condition,
    required this.category,
    required this.sellerId,
    required this.sellerName,
    required this.location,
    required this.distance,
    this.isSold = false,
    required this.postedDate,
  });

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? imageUrl,
    List<String>? imageUrls,
    double? price,
    bool? isDonation,
    String? condition,
    String? category,
    String? sellerId,
    String? sellerName,
    String? location,
    double? distance,
    bool? isSold,
    DateTime? postedDate,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      price: price ?? this.price,
      isDonation: isDonation ?? this.isDonation,
      condition: condition ?? this.condition,
      category: category ?? this.category,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      isSold: isSold ?? this.isSold,
      postedDate: postedDate ?? this.postedDate,
    );
  }

  factory Book.fromMap(Map<String, dynamic> map, String id) {
    return Book(
      id: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      imageUrls: map['imageUrls'] != null 
          ? List<String>.from(map['imageUrls']) 
          : (map['imageUrl'] != null && map['imageUrl'].toString().isNotEmpty ? [map['imageUrl']] : []),
      price: map['price']?.toDouble(),
      isDonation: map['isDonation'] ?? false,
      condition: map['condition'] ?? '',
      category: map['category'] ?? '',
      sellerId: map['sellerId'] ?? '',
      sellerName: map['sellerName'] ?? '',
      location: map['location'] ?? '',
      distance: (map['distance'] ?? 0.0).toDouble(),
      isSold: map['isSold'] ?? false,
      postedDate: map['postedDate'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['postedDate']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'imageUrl': imageUrl,
      'imageUrls': imageUrls,
      'price': price,
      'isDonation': isDonation,
      'condition': condition,
      'category': category,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'location': location,
      'distance': distance,
      'isSold': isSold,
      'postedDate': postedDate.millisecondsSinceEpoch,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        author,
        description,
        imageUrl,
        imageUrls,
        price,
        isDonation,
        condition,
        category,
        sellerId,
        sellerName,
        location,
        distance,
        isSold,
        postedDate,
      ];
}
