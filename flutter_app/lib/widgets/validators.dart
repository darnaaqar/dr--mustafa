class FormValidators {
  static String? validatePhone(String? value, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'رقم الهاتف مطلوب' : 'Phone number is required';
    }
    
    // Remove all non-digit characters except leading +
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Iraq phone validation: 07XXXXXXXX or 9647XXXXXXXX or +9647XXXXXXXX
    final iraqRegex = RegExp(r'^(07|9647|\+9647)\d{9}$');
    
    if (!iraqRegex.hasMatch(cleaned) && !iraqRegex.hasMatch(value)) {
      return isArabic 
        ? 'رقم هاتف غير صحيح. مثال: 07701234567'
        : 'Invalid phone. Example: 07701234567';
    }
    
    return null;
  }

  static String? validateEmail(String? value, bool isArabic) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    
    if (!emailRegex.hasMatch(value)) {
      return isArabic 
        ? 'البريد الإلكتروني غير صحيح'
        : 'Invalid email address';
    }
    
    return null;
  }

  static String? validateName(String? value, bool isArabic) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'الاسم مطلوب' : 'Name is required';
    }
    
    if (value.trim().length < 3) {
      return isArabic 
        ? 'الاسم يجب أن يكون 3 أحرف على الأقل'
        : 'Name must be at least 3 characters';
    }
    
    return null;
  }
}