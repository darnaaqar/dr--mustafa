import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'constants.dart';
import 'home_screen.dart';
import 'database_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize Supabase with actual project credentials from environment
    await Supabase.initialize(
      url: 'https://dkofobocffyzlpmqrrwo.supabase.co',
      publishableKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRrb2ZvYm9jZmZ5emxwbXFycndvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4NDY0NTIsImV4cCI6MjA5NjQyMjQ1Mn0.JmQWvPhsMjobIAWM1EuRtHOsomBJ8U5FiY20ml8dRSo',
    );
    DatabaseService.instance.markInitialized();
  } catch (e) {
    print("Supabase initialization failed: $e. App will run in offline mode.");
  }

  runApp(const PremiumDentalApp());
}

class PremiumDentalApp extends StatefulWidget {
  const PremiumDentalApp({super.key});

  @override
  State<PremiumDentalApp> createState() => _PremiumDentalAppState();
}

class _PremiumDentalAppState extends State<PremiumDentalApp> {
  bool isArabic = true; // Default to Arabic as shown in the uploaded screenshot

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
      
      // Modern High-Contrast Bioluminescent theme
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: DentalColors.background,
        cardColor: DentalColors.cardBg,
        primaryColor: DentalColors.primaryAccent,
        dividerColor: Colors.white10,
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
