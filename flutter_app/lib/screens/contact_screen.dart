import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class ContactScreen extends StatelessWidget {
  final bool isArabic;

  const ContactScreen({super.key, required this.isArabic});

  Future<void> _launch(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildContactCard(
            Icons.phone,
            isArabic ? 'اتصل بنا' : 'Call Us',
            '+971 4 555 1234',
            () => _launch(context, 'tel:+97145551234'),
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            Icons.message,
            isArabic ? 'واتساب' : 'WhatsApp',
            '+971 50 987 6543',
            () => _launch(context, 'https://wa.me/971509876543'),
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            Icons.location_on,
            isArabic ? 'موقع العيادة' : 'Location',
            isArabic ? 'دبي مارينا، دبي' : 'Dubai Marina, Dubai',
            () => _launch(context, 'https://maps.google.com/?q=Dubai+Marina'),
          ),
          const SizedBox(height: 32),
          const Text(
            'v1.2.0-AI Clinical Support',
            style: TextStyle(color: Colors.white10, fontSize: 10, fontFamily: 'monospace'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String val, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: DentalColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: DentalColors.primaryAccent),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: DentalColors.textSecondary, fontSize: 12)),
                  Text(val, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white10, size: 14),
          ],
        ),
      ),
    );
  }
}
