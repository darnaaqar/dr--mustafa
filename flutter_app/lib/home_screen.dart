import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'constants.dart';
import 'database_service.dart';
import 'screens/services_screen.dart';
import 'screens/service_detail_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/appointments_screen.dart';
import 'widgets/validators.dart';

class HomeScreen extends StatefulWidget {
  final bool isArabic;
  final VoidCallback onLanguageToggle;

  const HomeScreen({
    super.key,
    required this.isArabic,
    required this.onLanguageToggle,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentTabIndex = 0;
  
  // Dynamic data from Supabase
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _loadServices();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadServices() async {
    try {
      final services = await DatabaseService.instance.getServices();
      setState(() {
        _services = services;
      });
    } catch (e) {
      print("Failed to load services for home grid: $e");
    }
  }

  // Booking Form Controller states
  final _formKey = GlobalKey<FormState>();
  String _patientName = '';
  String _patientPhone = '';
  String? _selectedService;
  late String _selectedDate;
  late String _selectedTime;
  String _notes = '';
  bool _isBookingSubmitting = false;

  void _openBookingWizard(BuildContext context, {String? serviceId}) {
    if (serviceId != null) {
      setState(() {
        _selectedService = serviceId;
      });
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            final trans = DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!;
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: DentalColors.cardBg,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                border: Border(
                  top: BorderSide(color: DentalColors.primaryAccent, width: 1.5),
                ),
              ),
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header of wizard modal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: DentalColors.textSecondary),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Text(
                            trans['book_btn']!,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: DentalColors.primaryAccent,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 48), // Spacer
                        ],
                      ),
                      const Divider(color: Colors.white10, height: 24),
                      
                      // Full Name input field
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: trans['name_label'],
                          labelStyle: const TextStyle(color: DentalColors.textSecondary),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white10),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: DentalColors.primaryAccent),
                          ),
                          prefixIcon: const Icon(Icons.person, color: DentalColors.primaryAccent),
                        ),
                        validator: (val) => FormValidators.validateName(val, widget.isArabic),
                        onSaved: (val) => _patientName = val ?? '',
                      ),
                      const SizedBox(height: 16),

                      // Phone Number input field
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: trans['phone_label'],
                          labelStyle: const TextStyle(color: DentalColors.textSecondary),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white10),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: DentalColors.primaryAccent),
                          ),
                          prefixIcon: const Icon(Icons.phone, color: DentalColors.primaryAccent),
                        ),
                        validator: (val) => FormValidators.validatePhone(val, widget.isArabic),
                        onSaved: (val) => _patientPhone = val ?? '',
                      ),
                      const SizedBox(height: 16),

                      // Dropdown selection for clinical service (from Supabase)
                      DropdownButtonFormField<String>(
                        dropdownColor: DentalColors.cardBg,
                        value: _selectedService,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: trans['select_service'],
                          labelStyle: const TextStyle(color: DentalColors.textSecondary),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white10),
                          ),
                          prefixIcon: const Icon(Icons.medical_services, color: DentalColors.primaryAccent),
                        ),
                        items: _services.isEmpty
                            ? [
                                DropdownMenuItem<String>(
                                  value: null,
                                  child: Text(
                                    widget.isArabic ? 'لا توجد خدمات' : 'No services available',
                                    style: TextStyle(color: DentalColors.textSecondary),
                                  ),
                                ),
                              ]
                            : [
                                ..._services.map((service) {
                                  final title = widget.isArabic 
                                      ? (service['title_ar'] ?? service['title_en'] ?? '') 
                                      : (service['title_en'] ?? service['title_ar'] ?? '');
                                  return DropdownMenuItem<String>(
                                    value: service['id'],
                                    child: Text(title),
                                  );
                                }).toList(),
                              ],
                        onChanged: (val) => setModalState(() => _selectedService = val),
                        validator: (val) => val == null ? 'Required' : null,
                      ),
                      const SizedBox(height: 20),

                      // Selection row for Date & Time slots
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().add(const Duration(days: 1)),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(const Duration(days: 30)),
                                );
                                if (date != null) {
                                  setModalState(() {
                                    _selectedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16, color: DentalColors.primaryAccent),
                                    Text(_selectedDate, style: const TextStyle(color: Colors.white, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: const TimeOfDay(hour: 11, minute: 0),
                                );
                                if (time != null) {
                                  setModalState(() {
                                    _selectedTime = time.format(context);
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white10),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.access_time, size: 16, color: DentalColors.primaryAccent),
                                    Text(_selectedTime, style: const TextStyle(color: Colors.white, fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Notes input field
                      TextFormField(
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: trans['notes_label'],
                          labelStyle: const TextStyle(color: DentalColors.textSecondary),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white10),
                          ),
                          prefixIcon: const Icon(Icons.notes, color: DentalColors.primaryAccent),
                        ),
                        onSaved: (val) => _notes = val ?? '',
                      ),
                      const SizedBox(height: 24),

                      // Digital confirmation trigger button
                      _isBookingSubmitting
                          ? const Center(child: CircularProgressIndicator(color: DentalColors.primaryAccent))
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                gradient: DentalColors.buttonGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: DentalColors.primaryAccent.withOpacity(0.35),
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
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    setModalState(() => _isBookingSubmitting = true);
                                    
                                    bool isSuccess = await DatabaseService.instance.bookAppointment(
                                      name: _patientName,
                                      phone: _patientPhone,
                                      serviceId: _selectedService,
                                      date: _selectedDate,
                                      time: _selectedTime,
                                      notes: _notes,
                                      preferredLanguage: widget.isArabic ? 'ar' : 'en',
                                    );

                                    setModalState(() => _isBookingSubmitting = false);
                                    Navigator.pop(context); // Close sheet

                                    if (isSuccess) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: DentalColors.cardBg,
                                          content: Text(
                                            trans['success_booking']!,
                                            style: const TextStyle(color: DentalColors.primaryAccent, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                      
                                      // Request app review after successful booking
                                      Future.delayed(const Duration(seconds: 2), () async {
                                        if (mounted) {
                                          final InAppReview inAppReview = InAppReview.instance;
                                          try {
                                            if (await inAppReview.isAvailable()) {
                                              await inAppReview.requestReview();
                                            }
                                          } catch (e) {
                                            print("Review request error: $e");
                                          }
                                        }
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: DentalColors.cardBg,
                                          content: Text(
                                            widget.isArabic ? 'فشل الحجز. يرجى المحاولة مرة أخرى' : 'Booking failed. Please try again.',
                                            style: const TextStyle(color: Colors.redAccent),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  trans['submit_booking']!,
                                  style: const TextStyle(color: DentalColors.background, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToTab(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    _scaffoldKey.currentState?.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!;
    return Directionality(
      textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: DentalColors.background,
        
        // Premium sliding drawer loaded with full categories
        drawer: Drawer(
          backgroundColor: DentalColors.background,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: widget.isArabic ? Colors.white10 : Colors.transparent,
                  width: widget.isArabic ? 1 : 0,
                ),
                right: BorderSide(
                  color: !widget.isArabic ? Colors.white10 : Colors.transparent,
                  width: !widget.isArabic ? 1 : 0,
                ),
              ),
            ),
            child: Column(
              children: [
                // Drawer Header
                DrawerHeader(
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white10, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.medical_services_outlined, size: 28, color: DentalColors.primaryAccent),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "DENTAL AI",
                            style: TextStyle(
                              color: DentalColors.primaryAccent,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Text(
                            trans['premium_system']!,
                            style: const TextStyle(color: DentalColors.textSecondary, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Populated drawer list categories
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _buildDrawerItem(Icons.home, trans['home']!, _currentTabIndex == 0, () => _navigateToTab(0)),
                      _buildDrawerItem(Icons.health_and_safety, trans['services']!, _currentTabIndex == 1, () => _navigateToTab(1)),
                      _buildDrawerItem(Icons.photo_library, trans['gallery']!, _currentTabIndex == 2, () => _navigateToTab(2)),
                      _buildDrawerItem(Icons.person, trans['about']!, _currentTabIndex == 3, () => _navigateToTab(3)),
                      _buildDrawerItem(Icons.phone, trans['contact']!, _currentTabIndex == 4, () => _navigateToTab(4)),
                      _buildDrawerItem(Icons.calendar_month, trans['bookings']!, _currentTabIndex == 5, () => _navigateToTab(5), isBadge: true),
                    ],
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "v1.2.0-AI Client",
                    style: TextStyle(color: Colors.white10, fontSize: 10, fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ),

        body: SafeArea(
          child: Column(
            children: [
              // Fixed Top Custom App Bar Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: DentalColors.primaryAccent, size: 24),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    
                    // Arabic/English Toggle Button Container matching the uploaded design
                    GestureDetector(
                      onTap: widget.onLanguageToggle,
                      child: Container(
                        height: 38,
                        width: 130,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white10, width: 0.8),
                        ),
                        child: Row(
                          children: [
                            // Arabic label
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: widget.isArabic ? DentalColors.primaryAccent.withOpacity(0.12) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Text(
                                  "عربي",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: widget.isArabic ? DentalColors.primaryAccent : DentalColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                            // English label
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: !widget.isArabic ? DentalColors.primaryAccent.withOpacity(0.12) : Colors.transparent,
                                  borderRadius: BorderRadius.circular(17),
                                ),
                                child: Text(
                                  "English",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: !widget.isArabic ? DentalColors.primaryAccent : DentalColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab View Content
              Expanded(
                child: IndexedStack(
                  index: _currentTabIndex,
                  children: [
                    _buildHomeTab(trans),
                    ServicesScreen(
                      isArabic: widget.isArabic,
                      onBookClick: (id) => _openBookingWizard(context, serviceId: id),
                    ),
                    GalleryScreen(isArabic: widget.isArabic),
                    AboutScreen(isArabic: widget.isArabic),
                    ContactScreen(isArabic: widget.isArabic),
                    AppointmentsScreen(
                      isArabic: widget.isArabic,
                      onBookClick: () => _openBookingWizard(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String msg) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.upcoming, size: 64, color: Colors.white10),
          const SizedBox(height: 16),
          Text(
            msg,
            style: const TextStyle(color: DentalColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          const Text(
            "This feature is currently being engineered.",
            style: TextStyle(color: Colors.white10, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab(Map<String, String> trans) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _selectedDate = DateFormat('yyyy-MM-dd').format(tomorrow);
    _selectedTime = "11:00 AM";

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Clinical Identity Header
          const Icon(
            Icons.medical_services_outlined,
            size: 48,
            color: DentalColors.primaryAccent,
          ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
          const SizedBox(height: 12),
          
          Text(
            trans['title']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 0.5,
            ),
          ).animate().fadeIn(delay: 300.ms).moveY(begin: 10, end: 0),
          const SizedBox(height: 4),
          Text(
            trans['subtitle']!,
            style: const TextStyle(
              color: DentalColors.primaryAccent,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            trans['tagline']!,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 24),

          // Doctor Profile Image with Premium Outline
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
                backgroundImage: const AssetImage('assets/images/doctor_profile.png'),
              ),
            ),
          ).animate().fadeIn().scale(),

          const SizedBox(height: 32),

          const SizedBox(height: 24),

          // Translation Slogan Section
          const Text(
            "إبتسامة صحية.. مظهر أجمل.. حياة أفضل",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          const Text(
            "Healthy smile.. Beautiful look.. Better life",
            style: TextStyle(
              color: DentalColors.textSecondary,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 36),

          // Services Bento Grid Layout (Dynamic from Supabase)
          _services.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      trans['no_services']!,
                      style: const TextStyle(color: DentalColors.textSecondary, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 1.45,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    for (int i = 0; i < _services.length && i < 4; i++)
                      _buildBentoCard(
                        _services[i],
                        i,
                      ),
                  ],
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1, end: 0),

          const SizedBox(height: 36),

          // Glowing Interactive Appointment Action Button
          GestureDetector(
            onTap: () => _openBookingWizard(context),
            child: Container(
              width: double.infinity,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: DentalColors.buttonGradient,
                boxShadow: [
                  BoxShadow(
                    color: DentalColors.primaryAccent.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        trans['book_btn']!,
                        style: const TextStyle(
                          color: DentalColors.background,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        trans['book_subtitle']!,
                        style: TextStyle(
                          color: DentalColors.background.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.calendar_month,
                    color: DentalColors.background,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Centered Premium Slogan Footer (Synchronized with uploaded design requirements)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("✦", style: TextStyle(color: DentalColors.primaryAccent, fontSize: 12)),
                    const SizedBox(width: 8),
                    const Text("🛡️", style: TextStyle(fontSize: 15)),
                    const SizedBox(width: 8),
                    Text(
                      trans['care_smile']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("✦", style: TextStyle(color: DentalColors.primaryAccent, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  trans['we_care']!,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Builder for the drawer list elements
  Widget _buildDrawerItem(IconData icon, String label, bool isActive, VoidCallback onTap, {bool isBadge = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isActive ? DentalColors.primaryAccent.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? DentalColors.primaryAccent.withOpacity(0.15) : Colors.transparent,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: isActive ? DentalColors.primaryAccent : DentalColors.textSecondary, size: 20),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : DentalColors.textSecondary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13.5,
          ),
        ),
        trailing: isBadge
            ? Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  // Builder for beautiful premium bento cards in the grid (Dynamic from Supabase)
  Widget _buildBentoCard(Map<String, dynamic> service, int index) {
    final primaryTitle = widget.isArabic ? (service['title_ar'] ?? '') : (service['title_en'] ?? '');
    final secondaryTitle = widget.isArabic ? (service['title_en'] ?? '') : (service['title_ar'] ?? '');
    
    // Map icon names to icons
    IconData icon = Icons.health_and_safety;
    switch(service['icon']) {
      case 'sparkles':
        icon = Icons.star_half;
        break;
      case 'smile':
        icon = Icons.layers;
        break;
      case 'shield':
        icon = Icons.shield_outlined;
        break;
      case 'activity':
        icon = Icons.grid_3x3;
        break;
      default:
        icon = Icons.health_and_safety;
    }
    final imageUrl = service['image_url'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceDetailScreen(
              isArabic: widget.isArabic,
              serviceId: service['id'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: DentalColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl != null)
              Container(
                height: 60,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.white10,
                      child: Icon(icon, color: DentalColors.primaryAccent, size: 22),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(icon, color: DentalColors.primaryAccent, size: 22),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    secondaryTitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 9,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).scale(begin: const Offset(0.9, 0.9));
  }
}