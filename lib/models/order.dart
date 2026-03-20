import 'package:bookshare/models/book.dart';

class OrderModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final List<Book> items;
  final double totalAmount;
  final String shippingAddress;
  final String contactPhone;
  final String status;
  final String paymentMethod;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.items,
    required this.totalAmount,
    required this.shippingAddress,
    required this.contactPhone,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      buyerId: map['buyerId'] ?? '',
      sellerId: map['sellerId'] ?? '',
      items: List<Book>.from(
        (map['items'] as List? ?? []).map((x) => Book.fromMap(x as Map<String, dynamic>, x['id'] ?? '')),
      ),
      totalAmount: (map['totalAmount'] ?? 0.0).toDouble(),
      shippingAddress: map['shippingAddress'] ?? '',
      contactPhone: map['contactPhone'] ?? '',
      status: map['status'] ?? 'Pending',
      paymentMethod: map['paymentMethod'] ?? 'COD',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'buyerId': buyerId,
      'sellerId': sellerId,
      'items': items.map((x) => x.toMap()).toList(),
      'totalAmount': totalAmount,
      'shippingAddress': shippingAddress,
      'contactPhone': contactPhone,
      'status': status,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
