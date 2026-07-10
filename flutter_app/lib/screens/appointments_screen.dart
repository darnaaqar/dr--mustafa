import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants.dart';
import '../database_service.dart';

class AppointmentsScreen extends StatefulWidget {
  final bool isArabic;
  final VoidCallback? onBookClick;

  const AppointmentsScreen({super.key, required this.isArabic, this.onBookClick});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  Map<String, dynamic>? _appointment;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAppointment();
  }

  Future<void> _loadAppointment() async {
    try {
      final appointment = await DatabaseService.instance.getCurrentAppointment();
      setState(() {
        _appointment = appointment;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'error';
      });
    }
  }

  Future<void> _cancelAppointment() async {
    if (_appointment == null) return;
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DentalColors.cardBg,
        title: Text(
          widget.isArabic ? 'إلغاء الموعد' : 'Cancel Appointment',
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          widget.isArabic ? 'هل أنت متأكد من إلغاء الموعد؟' : 'Are you sure you want to cancel the appointment?',
          style: TextStyle(color: DentalColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(widget.isArabic ? 'لا' : 'No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(widget.isArabic ? 'نعم' : 'Yes', style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await DatabaseService.instance.cancelAppointment(_appointment!['id']);
      if (success) {
        setState(() {
          _appointment = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: DentalColors.cardBg,
            content: Text(
              widget.isArabic ? 'تم إلغاء الموعد بنجاح' : 'Appointment cancelled successfully',
              style: TextStyle(color: DentalColors.primaryAccent),
            ),
          ),
        );
      }
    }
  }

  Future<void> _editAppointment() async {
    // Return to home screen to rebook
    widget.onBookClick?.call();
  }

  @override
  Widget build(BuildContext context) {
    final trans = DentalTranslations.localizedValues[widget.isArabic ? 'ar' : 'en']!;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: DentalColors.primaryAccent),
      );
    }

    if (_appointment == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_month, size: 64, color: Colors.white10),
              const SizedBox(height: 16),
              Text(
                trans['no_appointments'] ?? (widget.isArabic ? 'لا توجد مواعيد محجوزة' : 'No appointments booked'),
                style: const TextStyle(color: DentalColors.textSecondary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DentalColors.primaryAccent,
                ),
                onPressed: () => widget.onBookClick?.call(),
                child: Text(
                  widget.isArabic ? 'احجز موعداً جديداً' : 'Book New Appointment',
                  style: TextStyle(color: DentalColors.background),
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn();
    }

     final serviceName = widget.isArabic 
         ? (_appointment!['services'] != null ? (_appointment!['services'] as Map)['name_ar'] : null) ?? _appointment!['service_name_ar'] ?? ''
         : (_appointment!['services'] != null ? (_appointment!['services'] as Map)['name_en'] : null) ?? _appointment!['service_name_en'] ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
                Text(
                  widget.isArabic ? 'موعدك الحالي' : 'Your Appointment',
                  style: const TextStyle(
                    color: DentalColors.primaryAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  Icons.person,
                  widget.isArabic ? 'الاسم' : 'Name',
                  _appointment!['patient_name'] ?? '',
                ),
                _buildInfoRow(
                  Icons.phone,
                  widget.isArabic ? 'الهاتف' : 'Phone',
                  _appointment!['phone'] ?? '',
                ),
                _buildInfoRow(
                  Icons.medical_services,
                  widget.isArabic ? 'الخدمة' : 'Service',
                  serviceName,
                ),
                _buildInfoRow(
                  Icons.calendar_today,
                  widget.isArabic ? 'التاريخ' : 'Date',
                  _appointment!['appointment_date'] ?? '',
                ),
                _buildInfoRow(
                  Icons.access_time,
                  widget.isArabic ? 'الوقت' : 'Time',
                  _appointment!['appointment_time'] ?? '',
                ),
                if (_appointment!['notes'] != null && _appointment!['notes'].toString().isNotEmpty)
                  _buildInfoRow(
                    Icons.notes,
                    widget.isArabic ? 'ملاحظات' : 'Notes',
                    _appointment!['notes'],
                  ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(_appointment!['status']),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(_appointment!['status'], widget.isArabic),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().scale(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DentalColors.primaryAccent.withOpacity(0.2),
                    foregroundColor: DentalColors.primaryAccent,
                  ),
                  onPressed: _editAppointment,
                  icon: const Icon(Icons.edit),
                  label: Text(widget.isArabic ? 'تعديل' : 'Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.2),
                    foregroundColor: Colors.redAccent,
                  ),
                  onPressed: _cancelAppointment,
                  icon: const Icon(Icons.delete),
                  label: Text(widget.isArabic ? 'إلغاء' : 'Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: DentalColors.primaryAccent, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: DentalColors.textSecondary, fontSize: 11),
                ),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String? status, bool isArabic) {
    switch (status) {
      case 'approved':
        return isArabic ? 'مؤكد' : 'Confirmed';
      case 'cancelled':
        return isArabic ? 'ملغي' : 'Cancelled';
      default:
        return isArabic ? 'معلق' : 'Pending';
    }
  }
}