import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();

  bool _isInitialized = false;

  void markInitialized() {
    _isInitialized = true;
  }

  // Fallback fallback premium service data in case Supabase is offline/unreachable
  final List<Map<String, dynamic>> fallbackServices = [
    {
      'id': 'srv-1',
      'title_ar': 'تبييض الأسنان بالليزر',
      'title_en': 'Laser Teeth Whitening',
      'short_ar': 'ابتسامة ناصعة البياض خلال جلسة واحدة بأحدث تقنيات الليزر البارد.',
      'short_en': 'Bright white smile in one session using clinical laser systems.',
      'icon': 'sparkles',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8IhJhiFXgCJoUCUhdnc489Z5-t5f73w8_vrm1xpYXedmkJ03q-koJmRfbOUzS_KQB0wsM6NaXDIHtJwV0K5zDDPGeUiBqxJ1vahCOg4L_EOFtulSHKST682LV0CZ5esHQYRSk_GGGGfRSBitnzecYBWkSCsJoqy8_nsg06W7xEsAhpHHHrHBwqXslITJ85aSDIxTyNuG8ThD74NSybCASpY9V3MVWaet_3GWL3yhamaVQj4dbDGJVwpsxnrt-nByMJbCOw2YSxps',
    },
    {
      'id': 'srv-2',
      'title_ar': 'الفينير والعدسات التجميلية',
      'title_en': 'Premium Veneers',
      'short_ar': 'تصميم ابتسامة هوليوود مخصصة تناسب ملامح وجهك بدقة متناهية.',
      'short_en': 'Custom designed porcelain teeth tailored to your face structure.',
      'icon': 'smile',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8IhJhiFXgCJoUCUhdnc489Z5-t5f73w8_vrm1xpYXedmkJ03q-koJmRfbOUzS_KQB0wsM6NaXDIHtJwV0K5zDDPGeUiBqxJ1vahCOg4L_EOFtulSHKST682LV0CZ5esHQYRSk_GGGGfRSBitnzecYBWkSCsJoqy8_nsg06W7xEsAhpHHHrHBwqXslITJ85aSDIxTyNuG8ThD74NSybCASpY9V3MVWaet_3GWL3yhamaVQj4dbDGJVwpsxnrt-nByMJbCOw2YSxps',
    },
    {
      'id': 'srv-3',
      'title_ar': 'زراعة الأسنان الرقمية',
      'title_en': 'Digital Dental Implants',
      'short_ar': 'غرسات تيتانيوم فورية موجهة بالكمبيوتر وبدون ألم.',
      'short_en': 'Computer-guided painless instant titanium crown implants.',
      'icon': 'shield',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8IhJhiFXgCJoUCUhdnc489Z5-t5f73w8_vrm1xpYXedmkJ03q-koJmRfbOUzS_KQB0wsM6NaXDIHtJwV0K5zDDPGeUiBqxJ1vahCOg4L_EOFtulSHKST682LV0CZ5esHQYRSk_GGGGfRSBitnzecYBWkSCsJoqy8_nsg06W7xEsAhpHHHrHBwqXslITJ85aSDIxTyNuG8ThD74NSybCASpY9V3MVWaet_3GWL3yhamaVQj4dbDGJVwpsxnrt-nByMJbCOw2YSxps',
    },
    {
      'id': 'srv-4',
      'title_ar': 'تقويم الأسنان غير المرئي',
      'title_en': 'Invisalign Orthodontics',
      'short_ar': 'تعديل اصطفاف الأسنان بأحدث القوالب الشفافة والمريحة.',
      'short_en': 'Seamless, comfortable teeth aligning using crystal clear aligners.',
      'icon': 'activity',
      'image_url': 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8IhJhiFXgCJoUCUhdnc489Z5-t5f73w8_vrm1xpYXedmkJ03q-koJmRfbOUzS_KQB0wsM6NaXDIHtJwV0K5zDDPGeUiBqxJ1vahCOg4L_EOFtulSHKST682LV0CZ5esHQYRSk_GGGGfRSBitnzecYBWkSCsJoqy8_nsg06W7xEsAhpHHHrHBwqXslITJ85aSDIxTyNuG8ThD74NSybCASpY9V3MVWaet_3GWL3yhamaVQj4dbDGJVwpsxnrt-nByMJbCOw2YSxps',
    }
  ];

  // Retrieve list of services
  Future<List<Map<String, dynamic>>> getServices() async {
    if (!_isInitialized) return fallbackServices;
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('services')
          .select('*')
          .eq('active', true)
          .order('sort_order', ascending: true);
      
      final list = List<Map<String, dynamic>>.from(response);
      return list.map((item) {
        return {
          ...item,
          'title_ar': item['name_ar'] ?? item['title_ar'] ?? '',
          'title_en': item['name_en'] ?? item['title_en'] ?? '',
          'short_ar': item['short_desc_ar'] ?? item['short_ar'] ?? '',
          'short_en': item['short_desc_en'] ?? item['short_en'] ?? '',
          'details_ar': item['details_ar'] ?? '',
          'details_en': item['details_en'] ?? '',
        };
      }).toList();
    } catch (e) {
      print("Supabase connection error, loading premium local backup services.");
      return fallbackServices;
    }
  }

  // Save booked appointment to database
  Future<bool> bookAppointment({
    required String name,
    required String phone,
    required String? serviceId,
    required String date,
    required String time,
    required String notes,
    String preferredLanguage = 'ar',
  }) async {
    if (!_isInitialized) {
      print("Offline mode: Simulated successful booking for $name on $date at $time");
      return true;
    }
    try {
      final client = Supabase.instance.client;
      await client.from('appointments').insert({
        'patient_name': name,
        'phone': phone,
        'service_id': serviceId,
        'preferred_language': preferredLanguage,
        'appointment_date': date,
        'appointment_time': time,
        'notes': notes,
        'status': 'pending',
      });
      return true;
    } catch (e) {
      print("Booking insert error: $e");
      return false;
    }
  }
}
