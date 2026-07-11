import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';
import '../database_service.dart';

class ServiceDetailScreen extends StatefulWidget {
  final bool isArabic;
  final String serviceId;

  const ServiceDetailScreen({
    super.key,
    required this.isArabic,
    required this.serviceId,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  Map<String, dynamic>? _service;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServiceDetail();
  }

  Future<void> _loadServiceDetail() async {
    try {
      final services = await DatabaseService.instance.getServices();
      final service = services.firstWhere(
        (s) => s['id'] == widget.serviceId,
        orElse: () => {},
      );
      setState(() {
        _service = service.isEmpty ? null : service;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: DentalColors.background,
        body: Center(
          child: CircularProgressIndicator(color: DentalColors.primaryAccent),
        ),
      );
    }

    if (_service == null) {
      return Scaffold(
        backgroundColor: DentalColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              widget.isArabic ? 'الخدمة غير متوفرة' : 'Service not available',
              style: const TextStyle(color: DentalColors.textSecondary, fontSize: 16),
            ),
          ),
        ),
      );
    }

    final title = widget.isArabic 
        ? (_service!['title_ar'] ?? _service!['title_en'] ?? '')
        : (_service!['title_en'] ?? _service!['title_ar'] ?? '');
    
    final details = widget.isArabic 
        ? (_service!['details_ar'] ?? _service!['short_ar'] ?? '')
        : (_service!['details_en'] ?? _service!['short_en'] ?? '');
    
    final benefits = widget.isArabic 
        ? (_service!['benefits_ar'] ?? '')
        : (_service!['benefits_en'] ?? '');
    
    final imageUrl = _service!['image_url'];
    final serviceId = _service!['id'];

    return Scaffold(
      backgroundColor: DentalColors.background,
      appBar: AppBar(
        backgroundColor: DentalColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: DentalColors.primaryAccent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isArabic ? 'تفاصيل الخدمة' : 'Service Details',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (imageUrl != null)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 220,
                      color: DentalColors.cardBg,
                      child: const Icon(Icons.broken_image, size: 60, color: Colors.white10),
                    ),
                  ),
                ),
              ).animate().fadeIn().scale(),
            
            const SizedBox(height: 24),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                height: 1.4,
              ),
              textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
            ).animate().fadeIn(delay: 100.ms),
            
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DentalColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: DentalColors.primaryAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.isArabic ? 'الوصف' : 'Description',
                        style: TextStyle(
                          color: DentalColors.primaryAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    details,
                    style: const TextStyle(
                      color: DentalColors.textSecondary,
                      fontSize: 14,
                      height: 1.7,
                    ),
                    textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 20),

            if (benefits.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: DentalColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: DentalColors.primaryAccent,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.isArabic ? 'الفوائد' : 'Benefits',
                          style: TextStyle(
                            color: DentalColors.primaryAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      benefits,
                      style: const TextStyle(
                        color: DentalColors.textSecondary,
                        fontSize: 14,
                        height: 1.7,
                      ),
                      textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms),
            
            const SizedBox(height: 32),

            // Book Now Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: DentalColors.buttonGradient,
                boxShadow: [
                  BoxShadow(
                    color: DentalColors.primaryAccent.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  // Navigate back with service ID for booking
                  Navigator.pop(context, serviceId);
                },
                child: Text(
                  widget.isArabic ? 'احجز هذه الخدمة' : 'Book This Service',
                  style: const TextStyle(
                    color: DentalColors.background,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}