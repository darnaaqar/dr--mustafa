import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:before_after/before_after.dart';
import '../constants.dart';
import '../database_service.dart';

class GalleryDetailScreen extends StatefulWidget {
  final bool isArabic;
  final String galleryId;

  const GalleryDetailScreen({
    super.key,
    required this.isArabic,
    required this.galleryId,
  });

  @override
  State<GalleryDetailScreen> createState() => _GalleryDetailScreenState();
}

class _GalleryDetailScreenState extends State<GalleryDetailScreen> {
  Map<String, dynamic>? _galleryItem;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGalleryItem();
  }

  Future<void> _loadGalleryItem() async {
    try {
      final items = await DatabaseService.instance.getGallery();
      final item = items.firstWhere(
        (g) => g['id'] == widget.galleryId,
        orElse: () => {},
      );
      setState(() {
        _galleryItem = item.isEmpty ? null : item;
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

    if (_galleryItem == null) {
      return Scaffold(
        backgroundColor: DentalColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              widget.isArabic ? 'العنصر غير متوفر' : 'Item not available',
              style: const TextStyle(color: DentalColors.textSecondary, fontSize: 16),
            ),
          ),
        ),
      );
    }

    final title = widget.isArabic 
        ? (_galleryItem!['title_ar'] ?? _galleryItem!['title_en'] ?? '')
        : (_galleryItem!['title_en'] ?? _galleryItem!['title_ar'] ?? '');
    
    final description = widget.isArabic 
        ? (_galleryItem!['description_ar'] ?? _galleryItem!['description_en'] ?? '')
        : (_galleryItem!['description_en'] ?? _galleryItem!['description_ar'] ?? '');
    
    final imageUrl = _galleryItem!['image_url'];
    final category = _galleryItem!['category'] ?? '';

    String categoryLabel = '';
    switch (category) {
      case 'clinic':
        categoryLabel = widget.isArabic ? 'العيادة' : 'Clinic';
        break;
      case 'before_after':
        categoryLabel = widget.isArabic ? 'قبل وبعد' : 'Before & After';
        break;
      case 'technology':
        categoryLabel = widget.isArabic ? 'التقنية' : 'Technology';
        break;
      case 'team':
        categoryLabel = widget.isArabic ? 'الفريق' : 'Team';
        break;
      default:
        categoryLabel = category;
    }

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
          categoryLabel,
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
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 300,
                      color: DentalColors.cardBg,
                      child: const Icon(Icons.broken_image, size: 60, color: Colors.white10),
                    ),
                  ),
                ),
              ).animate().fadeIn().scale(),
            
            // Before/After slider for before_after category
            if (category == 'before_after') ...[
              const SizedBox(height: 24),
              Text(
                widget.isArabic ? 'قبل وبعد' : 'Before / After',
                style: TextStyle(
                  color: DentalColors.primaryAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ).animate().fadeIn(delay: 150.ms),
              const SizedBox(height: 12),
              Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BeforeAfter(
                    before: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: DentalColors.cardBg,
                        child: const Icon(Icons.broken_image, size: 60, color: Colors.white10),
                      ),
                    ),
                    after: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: DentalColors.cardBg,
                        child: const Icon(Icons.broken_image, size: 60, color: Colors.white10),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ],
            
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

            if (description.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: DentalColors.cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: DentalColors.textSecondary,
                    fontSize: 14,
                    height: 1.7,
                  ),
                  textAlign: widget.isArabic ? TextAlign.right : TextAlign.left,
                ),
              ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}