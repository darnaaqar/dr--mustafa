import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();

  bool _isInitialized = false;

  void markInitialized() {
    _isInitialized = true;
  }

  bool get isInitialized => _isInitialized;

  // Fetch settings from Supabase
  Future<Map<String, dynamic>?> getSettings() async {
    if (!_isInitialized) return null;
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('settings')
          .select('*')
          .limit(1)
          .maybeSingle();
      return response;
    } catch (e) {
      print("Settings fetch error: $e");
      return null;
    }
  }

  // Fetch doctor info from Supabase
  Future<Map<String, dynamic>?> getDoctorInfo() async {
    if (!_isInitialized) return null;
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('doctors')
          .select('*')
          .limit(1)
          .maybeSingle();
      return response;
    } catch (e) {
      print("Doctor info fetch error: $e");
      return null;
    }
  }

  // Retrieve list of services from Supabase
  Future<List<Map<String, dynamic>>> getServices() async {
    if (!_isInitialized) return [];
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
      print("Supabase services fetch error: $e");
      return [];
    }
  }

  // Fetch gallery items from Supabase
  Future<List<Map<String, dynamic>>> getGallery() async {
    if (!_isInitialized) return [];
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('gallery')
          .select('*')
          .order('created_at', ascending: false);
      
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Supabase gallery fetch error: $e");
      return [];
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
      print("Error: Supabase not initialized. Cannot book appointment.");
      return false;
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