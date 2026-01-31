import 'package:equatable/equatable.dart';

class BannerItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? actionUrl;

  const BannerItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.actionUrl,
  });

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl, actionUrl];
}
