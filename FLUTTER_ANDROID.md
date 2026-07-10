# 📱 Flutter Android App & Supabase Integration Guide

This guide describes how to deploy, set up, and configure your **Premium Dental Clinic App** for **Flutter Android**, and compile it into an installable `.apk` file using GitHub Actions.

---

## 💾 1. Supabase Database Re-verification

The SQL schema you provided is fully integrated with this application. Ensure you have run this in your Supabase SQL Editor:

```sql
-- Enable cryptographic extensions
create extension if not exists pgcrypto;

-- 1. Doctors table
create table doctors (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  title_ar text,
  title_en text,
  about_ar text,
  about_en text,
  experience_years int default 0,
  image_url text,
  phone text,
  email text,
  whatsapp text,
  facebook text,
  instagram text,
  created_at timestamptz default now()
);

-- 2. Services table
create table services (
  id uuid primary key default gen_random_uuid(),
  title_ar text not null,
  title_en text not null,
  short_ar text,
  short_en text,
  details_ar text,
  details_en text,
  icon text,
  image_url text,
  sort_order int default 1,
  active boolean default true
);

-- 3. Gallery table
create table gallery (
  id uuid primary key default gen_random_uuid(),
  service_id uuid references services(id) on delete set null,
  category text check (category in ('clinic','before_after','technology','team')),
  title_ar text,
  title_en text,
  image_url text not null,
  created_at timestamptz default now()
);

-- 4. Appointments table (For booking flow)
create table appointments (
  id uuid primary key default gen_random_uuid(),
  patient_name text not null,
  phone text not null,
  email text,
  service_id uuid references services(id) on delete set null,
  doctor_id uuid references doctors(id) on delete set null,
  appointment_date date not null,
  appointment_time text not null,
  notes text,
  status text default 'pending',
  created_at timestamptz default now()
);
```

---

## 🛠️ 2. Flutter App Structure & Design System

To match our **Ultra-Modern Premium theme** in Flutter, copy the configuration files below into your local Flutter project.

### 📦 `pubspec.yaml`
Add these core dependencies to your Flutter configuration:

```yaml
name: dental_clinic_app
description: "Premium Futuristic Dental Clinic App"
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.2.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  supabase_flutter: ^2.5.0         # Supabase Client SDK
  google_fonts: ^6.1.0             # For Cairo and Inter typography
  url_launcher: ^6.2.5             # For phone/whatsapp dialing
  flutter_animate: ^4.5.0          # For smooth holographic animations
  intl: ^0.19.0                    # Date formatting

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
```

---

### 🎨 3. Primary Color Palette Definition (`constants.dart`)
Create a file named `lib/constants.dart` to share style variables:

```dart
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
```

---

### 🏛️ 4. Data Models & Database Wrapper (`database_service.dart`)
Create `lib/database_service.dart` to read and write directly to your Supabase tables:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();

  bool _isInitialized = false;

  void markInitialized() {
    _isInitialized = true;
  }

  // Retrieve Doctors
  Future<List<Map<String, dynamic>>> getDoctors() async {
    if (!_isInitialized) return [];
    final response = await Supabase.instance.client
        .from('doctors')
        .select('*');
    return List<Map<String, dynamic>>.from(response);
  }

  // Retrieve active services
  Future<List<Map<String, dynamic>>> getServices() async {
    if (!_isInitialized) return [];
    final response = await Supabase.instance.client
        .from('services')
        .select('*')
        .eq('active', true)
        .order('sort_order', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  // Save new booked appointment
  Future<void> bookAppointment({
    required String name,
    required String phone,
    required String email,
    required String? serviceId,
    required String date,
    required String time,
    required String notes,
  }) async {
    if (!_isInitialized) return;
    await Supabase.instance.client.from('appointments').insert({
      'patient_name': name,
      'phone': phone,
      'email': email,
      'service_id': serviceId,
      'appointment_date': date,
      'appointment_time': time,
      'notes': notes,
      'status': 'pending',
    });
  }
}
```

---

### 📲 5. App Entry & Dark Premium Theme Setup (`main.dart`)
Create `lib/main.dart` with translations and navigation routing:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase Client
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  runApp(const PremiumDentalApp());
}

class PremiumDentalApp extends StatefulWidget {
  const PremiumDentalApp({super.key});

  @override
  State<PremiumDentalApp> createState() => _PremiumDentalAppState();
}

class _PremiumDentalAppState extends State<PremiumDentalApp> {
  bool isArabic = true; // Default language Arabic as requested

  void toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dr. Mustafa Clinic',
      debugShowCheckedModeBanner: false,
      locale: Locale(isArabic ? 'ar' : 'en'),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: DentalColors.background,
        cardColor: DentalColors.cardBg,
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
          bodyMedium: isArabic 
            ? GoogleFonts.cairo(color: DentalColors.textSecondary)
            : GoogleFonts.inter(color: DentalColors.textSecondary),
          titleLarge: isArabic
            ? GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)
            : GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomeScreen(
        isArabic: isArabic, 
        onLanguageToggle: toggleLanguage,
      ),
    );
  }
}
```

---

## 🤖 6. Compiling to APK on GitHub

We have configured a fully automated APK build pipeline for your convenience in **`.github/workflows/build_apk.yml`**.

To compile and download your APK, follow these simple steps:

1. **Commit and Push Code to GitHub**:
   Ensure you place your Flutter folder in the root or in a folder named `flutter_app` inside your repository.
2. **Watch the Builder Run**:
   Go to your GitHub repository, click on the **Actions** tab. You will see the **Build Android APK** workflow starting up automatically.
3. **Download Your APK File**:
   Once the build completes successfully (approx. 2-3 minutes), scroll to the bottom of the workflow page to find the **dental-clinic-release-apk** download link under the "Artifacts" section.
