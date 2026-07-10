import 'package:flutter/material.dart';
import '../constants.dart';

class AboutScreen extends StatelessWidget {
  final bool isArabic;

  const AboutScreen({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: DentalColors.primaryAccent, width: 2),
            ),
            child: const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuBQGk9T8T-E-dTpTss5FQxeaLgfuT6D7b8knwLxoma7ZhneQUbTV6jegwf83Rz3Wsi-1ojfZUr4lObSfdbX8qJs_GRO-1BDl9AUgNUb0Z60o8xRS9X-FtvMzMNib-qoykcBsefefS1Hhaf0u5mEuLb83liLjH7sos8ZJOA7njPRorV-taMls7PyH_FyRFsPwcu0h8c2UUGlTi9rSDRoelBrHe30tc3qJpL7eQi6euwC_Dofi6FIaIkTEyIqa6zWRKrNA2ZqGbxXlPo'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isArabic ? 'د. مصطفى الرفاعي' : 'Dr. Mustafa Al-Rifai',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(
            isArabic ? 'استشاري طب وتجميل الأسنان' : 'Consultant in Dental Care & Aesthetics',
            style: const TextStyle(color: DentalColors.primaryAccent, fontSize: 14),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: DentalColors.cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              isArabic 
                ? 'د. مصطفى الرفاعي هو رائد في مجال طب وتجميل الأسنان الرقمي بأكثر من 15 عاماً من الخبرة السريرية المتقدمة. متخصص في الجراحات الدقيقة والزراعة الفورية والابتسامات الرقمية المتطورة المدعومة بالذكاء الاصطناعي.'
                : 'Dr. Mustafa Al-Rifai is a leader in digital cosmetic dentistry with over 15 years of advanced clinical experience. Specializes in precision micro-surgery, immediate loading implants, and AI-powered smile design.',
              style: const TextStyle(color: DentalColors.textSecondary, fontSize: 14, height: 1.6),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat('15+', isArabic ? 'سنوات خبرة' : 'Years Exp'),
              _buildStat('5000+', isArabic ? 'حالة ناجحة' : 'Success Cases'),
            ],
          ),
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
