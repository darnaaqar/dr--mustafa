import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';
import '../database_service.dart';
import 'service_detail_screen.dart';

class ServicesScreen extends StatefulWidget {
  final bool isArabic;
  final Function(String?)? onBookClick;

  const ServicesScreen({
    super.key,
    required this.isArabic,
    this.onBookClick,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  List<Map<String, dynamic>> _services = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final services = await DatabaseService.instance.getServices();
      setState(() {
        _services = services;
        _isLoading = false;
        _error = services.isEmpty ? 'no_data' : null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'error';
      });
    }
  }

  Future<void> _refreshServices() async {
    setState(() {
      _isLoading = true;
    });
    await _loadServices();
  }

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: DentalColors.primaryAccent),
      );
    }

    if (_services.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            trans['no_services']!,
            style: const TextStyle(color: DentalColors.textSecondary, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshServices,
      color: DentalColors.primaryAccent,
      backgroundColor: DentalColors.cardBg,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          final title = widget.isArabic ? service['title_ar'] : service['title_en'];
          final shortDesc = widget.isArabic ? service['short_ar'] : service['short_en'];

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: DentalColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (service['image_url'] != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      service['image_url'],
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 160,
                        color: Colors.white10,
                        child: const Icon(Icons.broken_image, color: Colors.white10),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        shortDesc,
                        style: const TextStyle(
                          color: DentalColors.textSecondary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DentalColors.primaryAccent.withOpacity(0.1),
                          foregroundColor: DentalColors.primaryAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: DentalColors.primaryAccent, width: 0.5),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceDetailScreen(
                                isArabic: widget.isArabic,
                                serviceId: service['id'],
                              ),
                            ),
                          );
                          // If booking was triggered from detail screen
                          if (result != null && widget.onBookClick != null) {
                            widget.onBookClick!(result);
                          }
                        },
                        child: Text(widget.isArabic ? 'عرض التفاصيل' : 'View Details'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.1, end: 0);
        },
      ),
    );
  }
}