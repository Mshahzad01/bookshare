import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String location;
  final String? phoneNumber;
  final String? accountType; // Student or Shopkeeper
  final double trustScore;
  final int totalListings;
  final int completedTransactions;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.location,
    this.phoneNumber,
    this.accountType,
    this.trustScore = 0.0,
    this.totalListings = 0,
    this.completedTransactions = 0,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? location,
    String? phoneNumber,
    String? accountType,
    double? trustScore,
    int? totalListings,
    int? completedTransactions,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      accountType: accountType ?? this.accountType,
      trustScore: trustScore ?? this.trustScore,
      totalListings: totalListings ?? this.totalListings,
      completedTransactions: completedTransactions ?? this.completedTransactions,
    );
  }

  factory User.fromMap(Map<String, dynamic> map, String id) {
    return User(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'],
      location: map['location'] ?? '',
      phoneNumber: map['phoneNumber'],
      accountType: map['accountType'],
      trustScore: (map['trustScore'] ?? 0.0).toDouble(),
      totalListings: map['totalListings'] ?? 0,
      completedTransactions: map['completedTransactions'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        location,
        phoneNumber,
        accountType,
        trustScore,
        totalListings,
        completedTransactions,
      ];
}
