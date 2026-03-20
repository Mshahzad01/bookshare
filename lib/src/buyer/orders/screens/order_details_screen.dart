import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../models/order.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (order.status.toLowerCase()) {
      case 'confirmed':
        statusColor = Colors.blue;
        break;
      case 'delivered':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange; // Pending
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: statusColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Status', style: GoogleFonts.poppins(fontSize: 12, color: statusColor)),
                        Text(order.status, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: statusColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Order Info
            Text('Order Information', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildInfoRow('Order ID', '#${order.id.toUpperCase()}'),
            _buildInfoRow('Date', DateFormat('MMM dd, yyyy - hh:mm a').format(order.createdAt)),
            _buildInfoRow('Payment Method', order.paymentMethod),
            
            const Divider(height: 32),
            
            // Shipping Details
            Text('Shipping Details', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(order.shippingAddress, style: GoogleFonts.poppins(fontSize: 14)),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Text(order.contactPhone, style: GoogleFonts.poppins(fontSize: 14)),
              ],
            ),
            
            const Divider(height: 32),
            
            // Items List
            Text('Items (${order.items.length})', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: item.imageUrl.startsWith('http')
                                ? NetworkImage(item.imageUrl) as ImageProvider
                                : const AssetImage('assets/images/book_placeholder.jpg'),
                            fit: BoxFit.cover,
                          )
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                            Text('Seller: ${item.sellerName}', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Text(
                        item.isDonation ? 'FREE' : 'Rs.${item.price?.toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      )
                    ],
                  ),
                );
              },
            ),
            
            const Divider(height: 32),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  'Rs. ${order.totalAmount.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 48), // Padding bottom
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 14)),
          Text(value, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}
