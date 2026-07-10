import 'package:flutter/material.dart';

class DentalColors {
  static const Color background = Color(0xFF07131E);
  static const Color cardBg = Color(0xFF0F1D2A);
  static const Color primaryAccent = Color(0xFF00D8FF);
  static const Color secondaryAccent = Color(0xFF39E6FF);
  static const Color textMain = Colors.white;
  static const Color textSecondary = Color(0xFFB6D3E5);

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF00A6E6)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class DentalTranslations {
  static const Map<String, Map<String, String>> localizedValues = {
    'ar': {
      'title': 'د. مصطفى الرفاعي',
      'subtitle': 'طب وتجميل الأسنان',
      'tagline': 'Dental Care & Aesthetics',
      'book_btn': 'احجز موعدك الآن',
      'book_subtitle': 'Book Your Appointment',
      'care_smile': 'نهتم بابتسامتك',
      'we_care': 'We care about your smile',
      'our_services': 'الخدمات المميزة',
      'home': 'الرئيسية',
      'services': 'الخدمات المميزة',
      'gallery': 'معرض الصور',
      'about': 'عن الدكتور',
      'contact': 'اتصل بنا',
      'bookings': 'مواعيدي والإشعارات',
      'premium_system': 'نظام عيادة متميز',
      'all_precision': 'دقة متناهية',
      'all_precision_desc': 'استخدام المسح ثلاثي الأبعاد لضمان التوافق التام مع عظام الفك.',
      'rapid_exec': 'سرعة التنفيذ',
      'rapid_exec_desc': 'تقنيات حديثة تقلل من عدد الزيارات وفترات الانتظار الطويلة.',
      'natural_glow': 'نتائج طبيعية دائمة',
      'natural_glow_desc': 'زرعات تيتانيوم حيوية تندمج مع العظم لتدوم مدى الحياة بمظهر طبيعي 100%.',
      'name_label': 'الاسم الكامل',
      'phone_label': 'رقم الهاتف',
      'notes_label': 'ملاحظات إضافية',
      'select_service': 'اختر الخدمة',
      'select_date': 'اختر التاريخ',
      'select_time': 'اختر الوقت',
      'submit_booking': 'تأكيد الحجز الرقمي',
      'success_booking': 'تم تقديم طلب الحجز بنجاح!',
    },
    'en': {
      'title': 'Dr. Mustafa Al-Rifai',
      'subtitle': 'Dental Care & Aesthetics',
      'tagline': 'طب وتجميل الأسنان',
      'book_btn': 'Book Your Appointment',
      'book_subtitle': 'احجز موعدك الآن',
      'care_smile': 'We care about your smile',
      'we_care': 'نهتم بابتسامتك',
      'our_services': 'Our Services',
      'home': 'Home',
      'services': 'Our Services',
      'gallery': 'Gallery',
      'about': 'About Doctor',
      'contact': 'Contact Us',
      'bookings': 'My Bookings',
      'premium_system': 'Premium Clinical System',
      'all_precision': 'Absolute Precision',
      'all_precision_desc': '3D CAD-CAM modeling matches target structures with micrometric accuracy.',
      'rapid_exec': 'Rapid Execution',
      'rapid_exec_desc': 'AI fabrication trims dental waiting intervals and eliminates redundant steps.',
      'natural_glow': 'Natural Lifelong Glow',
      'natural_glow_desc': 'Bio-engineered titanium and premium porcelain deliver a natural smile engineered for life.',
      'name_label': 'Full Name',
      'phone_label': 'Phone Number',
      'notes_label': 'Additional Notes',
      'select_service': 'Select Service',
      'select_date': 'Select Date',
      'select_time': 'Select Time',
      'submit_booking': 'Confirm Digital Booking',
      'success_booking': 'Appointment submitted successfully!',
    }
  };
}
