export interface Doctor {
  id: string;
  full_name: string;
  full_name_ar?: string;
  full_name_en?: string;
  title_ar: string | null;
  title_en: string | null;
  about_ar: string | null;
  about_en: string | null;
  qualifications_ar?: string | null;
  qualifications_en?: string | null;
  experience_years: number;
  image_url: string | null;
  phone: string | null;
  email: string | null;
  whatsapp: string | null;
  facebook: string | null;
  instagram: string | null;
  created_at?: string;
}

export interface Service {
  id: string;
  title_ar: string;
  title_en: string;
  name_ar?: string;
  name_en?: string;
  short_ar: string | null;
  short_en: string | null;
  short_desc_ar?: string | null;
  short_desc_en?: string | null;
  details_ar: string | null;
  details_en: string | null;
  benefits_ar?: string | null;
  benefits_en?: string | null;
  icon: string | null; // Lucide icon name or image
  image_url: string | null;
  sort_order: number;
  active: boolean;
}

export interface GalleryItem {
  id: string;
  service_id: string | null;
  category: 'clinic' | 'before_after' | 'technology' | 'team';
  title_ar: string | null;
  title_en: string | null;
  description_ar?: string | null;
  description_en?: string | null;
  image_url: string;
  created_at?: string;
}

export interface Appointment {
  id: string;
  patient_name: string;
  phone: string;
  email: string | null;
  service_id: string;
  preferred_language?: 'ar' | 'en';
  appointment_date: string; // YYYY-MM-DD
  appointment_time: string; // HH:MM
  notes: string | null;
  status: 'pending' | 'approved' | 'completed' | 'cancelled';
  created_at?: string;
}

export interface ClinicSettings {
  id: boolean;
  clinic_name_ar: string | null;
  clinic_name_en: string | null;
  slogan_ar?: string | null;
  slogan_en?: string | null;
  address_ar: string | null;
  address_en: string | null;
  phone: string | null;
  whatsapp: string | null;
  email: string | null;
  website?: string | null;
  working_hours_ar: string | null;
  working_hours_en: string | null;
  google_map: string | null;
  logo_url: string | null;
  hero_image_url: string | null;
  facebook?: string | null;
  instagram?: string | null;
  tiktok?: string | null;
  youtube?: string | null;
}
