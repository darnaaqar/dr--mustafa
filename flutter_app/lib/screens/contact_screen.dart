import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';
import '../database_service.dart';

class ContactScreen extends StatefulWidget {
  final bool isArabic;

  const ContactScreen({super.key, required this.isArabic});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  Map<String, dynamic>? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await DatabaseService.instance.getSettings();
      setState(() {
        _settings = settings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
          SnackBar(
            backgroundColor: DentalColors.cardBg,
            content: Text(
              '$e',
              style: const TextStyle(color: DentalColors.primaryAccent),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: DentalColors.primaryAccent),
      );
    }

    final phone = _settings?['phone'] ?? '+971 4 555 1234';
    final whatsapp = _settings?['whatsapp'] ?? '+971 50 987 6543';
    final address = widget.isArabic 
        ? (_settings?['address_ar'] ?? 'دبي مارينا، دبي') 
        : (_settings?['address_en'] ?? 'Dubai Marina, Dubai');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildContactCard(
            Icons.phone,
            widget.isArabic ? 'اتصل بنا' : 'Call Us',
            phone,
            () => _launch(context, 'tel:${phone.replaceAll(' ', '').replaceAll('+', '')}'),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.1),
          const SizedBox(height: 16),
          _buildContactCard(
            Icons.message,
            widget.isArabic ? 'واتساب' : 'WhatsApp',
            whatsapp,
            () => _launch(context, 'https://wa.me/${whatsapp.replaceAll(' ', '').replaceAll('+', '').replaceAll('+', '')}'),
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
          const SizedBox(height: 16),
          _buildContactCard(
            Icons.location_on,
            widget.isArabic ? 'موقع العيادة' : 'Location',
            address,
            () => _launch(context, 'https://maps.google.com/?q=${Uri.encodeComponent(address)}'),
          ).animate().fadeIn(delay: 300.ms).slideX(begin: -0.1),
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
                  Text(
                    title,
                    style: const TextStyle(color: DentalColors.textSecondary, fontSize: 12),
                  ),
                  Text(
                    val,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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