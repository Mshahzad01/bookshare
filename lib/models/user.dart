import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String location;
  final double trustScore;
  final int totalListings;
  final int completedTransactions;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.location,
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
      trustScore: trustScore ?? this.trustScore,
      totalListings: totalListings ?? this.totalListings,
      completedTransactions: completedTransactions ?? this.completedTransactions,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        avatarUrl,
        location,
        trustScore,
        totalListings,
        completedTransactions,
      ];
}
