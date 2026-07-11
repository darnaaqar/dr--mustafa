import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';
import '../database_service.dart';

class AboutScreen extends StatefulWidget {
  final bool isArabic;

  const AboutScreen({super.key, required this.isArabic});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  Map<String, dynamic>? _doctorInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorInfo();
  }

  Future<void> _loadDoctorInfo() async {
    try {
      final info = await DatabaseService.instance.getDoctorInfo();
      setState(() {
        _doctorInfo = info;
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
      return const Center(
        child: CircularProgressIndicator(color: DentalColors.primaryAccent),
      );
    }

    final fullName = widget.isArabic 
        ? (_doctorInfo?['full_name_ar'] ?? trans['title']!) 
        : (_doctorInfo?['full_name_en'] ?? trans['title']!);
    
    final title = widget.isArabic 
        ? (_doctorInfo?['title_ar'] ?? 'طب وتجميل الأسنان') 
        : (_doctorInfo?['title_en'] ?? 'Dental Care & Aesthetics');
    
    final about = widget.isArabic 
        ? (_doctorInfo?['about_ar'] ?? 'د. مصطفى الرفاعي هو رائد في مجال طب وتجميل الأسنان الرقمي بأكثر من 15 عاماً من الخبرة السريرية المتقدمة. متخصص في الجراحات الدقيقة والزراعة الفورية والابتسامات الرقمية المتطورة المدعومة بالذكاء الاصطناعي.')
        : (_doctorInfo?['about_en'] ?? 'Dr. Mustafa Al-Rifai is a leader in digital cosmetic dentistry with over 15 years of advanced clinical experience. Specializes in precision micro-surgery, immediate loading implants, and AI-powered smile design.');
    
     final experience = _doctorInfo?['experience_years']?.toString() ?? '15';
     final imageUrl = _doctorInfo?['image_url'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  DentalColors.primaryAccent,
                  DentalColors.secondaryAccent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: DentalColors.primaryAccent.withOpacity(0.4),
                  blurRadius: 25,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: DentalColors.background,
              ),
              child: CircleAvatar(
                radius: 58,
                backgroundImage: imageUrl != null 
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/images/doctor_profile.png') as ImageProvider,
              ),
            ),
          ).animate().fadeIn().scale(),
          const SizedBox(height: 24),
          Text(
            fullName,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 200.ms),
          Text(
            title,
            style: const TextStyle(color: DentalColors.primaryAccent, fontSize: 14),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DentalColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              about,
              style: const TextStyle(color: DentalColors.textSecondary, fontSize: 14, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('$experience+', widget.isArabic ? 'سنوات خبرة' : 'Years Exp'),
              _buildStat('5000+', widget.isArabic ? 'حالة ناجحة' : 'Success Cases'),
            ],
          ).animate().fadeIn(delay: 500.ms),
        ],
      ),
    );
  }

  Widget _buildStat(String val, String label) {
    return Column(
      children: [
        Text(val, style: const TextStyle(color: DentalColors.primaryAccent, fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: DentalColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}