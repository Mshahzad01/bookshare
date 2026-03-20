import 'package:equatable/equatable.dart';

class Business extends Equatable {
  final String id;
  final String ownerId;
  final String businessName;
  final String businessAddress;
  final String phoneNumber;
  final String businessType; // Student or Shopkeeper
  final String? logoUrl;
  final double totalEarnings;
  final DateTime createdAt;

  const Business({
    required this.id,
    required this.ownerId,
    required this.businessName,
    required this.businessAddress,
    required this.phoneNumber,
    required this.businessType,
    this.logoUrl,
    this.totalEarnings = 0.0,
    required this.createdAt,
  });

  factory Business.fromMap(Map<String, dynamic> map, String id) {
    return Business(
      id: id,
      ownerId: map['ownerId'] ?? '',
      businessName: map['businessName'] ?? '',
      businessAddress: map['businessAddress'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      businessType: map['businessType'] ?? '',
      logoUrl: map['logoUrl'],
      totalEarnings: (map['totalEarnings'] ?? 0.0).toDouble(),
      createdAt: map['createdAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'businessName': businessName,
      'businessAddress': businessAddress,
      'phoneNumber': phoneNumber,
      'businessType': businessType,
      'logoUrl': logoUrl,
      'totalEarnings': totalEarnings,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  Business copyWith({
    String? id,
    String? ownerId,
    String? businessName,
    String? businessAddress,
    String? phoneNumber,
    String? businessType,
    String? logoUrl,
    double? totalEarnings,
    DateTime? createdAt,
  }) {
    return Business(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      businessType: businessType ?? this.businessType,
      logoUrl: logoUrl ?? this.logoUrl,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ownerId,
        businessName,
        businessAddress,
        phoneNumber,
        businessType,
        logoUrl,
        totalEarnings,
        createdAt,
      ];
}
