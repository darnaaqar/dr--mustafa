import { createClient } from '@supabase/supabase-js';
import { Doctor, Service, GalleryItem, Appointment, ClinicSettings } from '../types';

// Supabase configuration
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL || '';
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY || '';

const isSupabaseConfigured = supabaseUrl && supabaseAnonKey;
export const supabase = isSupabaseConfigured 
  ? createClient(supabaseUrl, supabaseAnonKey) 
  : null;

// Initial Seed Data for fallback database
const defaultSettings: ClinicSettings = {
  id: true,
  clinic_name_ar: 'عيادة د. مصطفى الرفاعي لطب الأسنان',
  clinic_name_en: 'Dr. Mustafa Al-Rifai Dental Clinic',
  address_ar: 'دبي، الإمارات العربية المتحدة، دبي مارينا، برج النخبة طبقة 12',
  address_en: 'Dubai Marina, Elite Tower Floor 12, Dubai, UAE',
  phone: '+971 4 555 1234',
  whatsapp: '+971 50 987 6543',
  email: 'info@mustafaalrifai.com',
  working_hours_ar: 'الأحد - الخميس: 09:00 - 20:00، الجمعة: 10:00 - 18:00، السبت: مغلق',
  working_hours_en: 'Sun - Thu: 09:00 - 20:00, Fri: 10:00 - 18:00, Sat: Closed',
  google_map: 'https://maps.google.com/?q=Dubai+Marina',
  logo_url: 'https://lh3.googleusercontent.com/aida/AP1WRLvgpJuNbz7ZGBSUud_zbYaRxgvpRkXubIr9UDnaFKaCeDZH5fWaQtfNJE9WRNmtOJeAjeGXfGK_iajc4akHDTJjiyZC5ATTuYC--1l7gOgaq35HTTNE0KiTX9vlW-WthJ87N_OAxlXAR7grSPmEisQhtU6Obp9FNyv6SKR4dad81sTNF8-0sKgWccdIiq9J9hI1HejVCC00DAP7ioDxnnWCGgNdmwyD2-MDvhpZyedHKIUXyzjdGJGNT7I',
  hero_image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8IhJhiFXgCJoUCUhdnc489Z5-t5f73w8_vrm1xpYXedmkJ03q-koJmRfbOUzS_KQB0wsM6NaXDIHtJwV0K5zDDPGeUiBqxJ1vahCOg4L_EOFtulSHKST682LV0CZ5esHQYRSk_GGGGfRSBitnzecYBWkSCsJoqy8_nsg06W7xEsAhpHHHrHBwqXslITJ85aSDIxTyNuG8ThD74NSybCASpY9V3MVWaet_3GWL3yhamaVQj4dbDGJVwpsxnrt-nByMJbCOw2YSxps'
};

const defaultDoctors: Doctor[] = [
  {
    id: 'd1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d',
    full_name: 'د. مصطفى الرفاعي',
    title_ar: 'استشاري طب وتجميل الأسنان',
    title_en: 'Consultant in Dental Care & Aesthetics',
    about_ar: 'د. مصطفى الرفاعي هو رائد في مجال طب وتجميل الأسنان الرقمي بأكثر من 15 عاماً من الخبرة السريرية المتقدمة. متخصص في الجراحات الدقيقة والزراعة الفورية والابتسامات الرقمية المتطورة المدعومة بالذكاء الاصطناعي.',
    about_en: 'Dr. Mustafa Al-Rifai is a leader in digital cosmetic dentistry with over 15 years of advanced clinical experience. Specializes in precision micro-surgery, immediate loading implants, and AI-powered smile design.',
    experience_years: 15,
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQGk9T8T-E-dTpTss5FQxeaLgfuT6D7b8knwLxoma7ZhneQUbTV6jegwf83Rz3Wsi-1ojfZUr4lObSfdbX8qJs_GRO-1BDl9AUgNUb0Z60o8xRS9X-FtvMzMNib-qoykcBsefefS1Hhaf0u5mEuLb83liLjH7sos8ZJOA7njPRorV-taMls7PyH_FyRFsPwcu0h8c2UUGlTi9rSDRoelBrHe30tc3qJpL7eQi6euwC_Dofi6FIaIkTEyIqa6zWRKrNA2ZqGbxXlPo',
    phone: '+971 4 555 1234',
    email: 'dr.mustafa@alrifaiclinic.com',
    whatsapp: '+971 50 987 6543',
    facebook: 'https://facebook.com/dr.mustafa',
    instagram: 'https://instagram.com/dr.mustafa'
  }
];

const defaultServices: Service[] = [
  {
    id: 's1-implants',
    title_ar: 'زراعة الأسنان الرقمية',
    title_en: 'Digital Dental Implants',
    short_ar: 'استعادة ابتسامتك الدائمة بأحدث تقنيات الزرع التيتانيوم الدقيق والتعويضات الفورية.',
    short_en: 'Restore your permanent smile with precision titanium implants and immediate restorations.',
    details_ar: 'نقدم زراعة الأسنان الرقمية الموجهة بالحاسوب والمصممة خصيصاً لتناسب عظام فكك بدقة متناهية. يتم استخدام الفحص ثلاثي الأبعاد والذكاء الاصطناعي لتخطيط أدق للمحاذاة وبأقل تدخل جراحي وأسرع فترة تعافٍ.',
    details_en: 'We provide computer-guided dental implants customized to perfectly fit your jawbone. Using 3D scans and AI to map alignment, we perform the procedure with minimal invasiveness and ultra-fast recovery times.',
    icon: 'implants',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA4ykSlN3SWUn5pRlkAaENPXVFJRR5isEAN6Bg1qsIa6_RYXmHCTWyobsZe3cL00ocWx26nN8XepasTrmKebv5QdLUR7LNQXgN8uEJmiBIHXlAriivM6PhxTLd0zYCiCZTTkGDZKFtIBfkakEr_3Q4CkXItBtjtBPO7Tqrd5Q2uZzsmyEjF_Y37NYPJ_YNSufleNThjjAcDyxPBeT6rcDI9vlNNJ9eAcNzxp2k_xLz2pxO-_-Do4bTFAqu-oWEys27Bf-QswboKE2w',
    sort_order: 1,
    active: true
  },
  {
    id: 's2-veneers',
    title_ar: 'فينير وتجميل الأسنان',
    title_en: 'Cosmetic Veneers',
    short_ar: 'قشور خزفية فائقة الدقة لتغيير مظهر الأسنان تماماً والحصول على ابتسامة هوليوود المتألقة.',
    short_en: 'Ultra-thin custom porcelain shells to completely transform your smile into a Hollywood glow.',
    details_ar: 'احصل على ابتسامة أحلامك مع قشور الفينير فائقة الرقة المصنوعة من السيراميك الفاخر المقاوم للتصبغ. نقوم بتصميم الابتسامة رقمياً لتتوافق مع ملامح وجهك وتمنحك مظهراً طبيعياً وجذاباً يدوم طويلاً.',
    details_en: 'Achieve your dream smile with ultra-thin porcelain veneers crafted from premium stain-resistant materials. We digitally construct your smile to harmonize with your features for a long-lasting, beautiful appearance.',
    icon: 'veneers',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBXPbsArznlWc7wjwK_KEpnD-ZD2Hz0PH9lYs-kdUg23s9csaR_aFxXxXafvaE2yjLQXqVMqLs7fSMaWHoXFJIikwrZFEpfNXlk18KzfAbgnDGjjHSvljxEja-o6kSZl9Yre8TbBxMc9kjGOoA3ZjkLGINoe0Vt6FF1lNNSh8Mu3egc6LtSN6SIMydmpTihz9GSJe5CNH10uJ2yX4mgqujmvE8ohYHHVoK2Na-aDfHkGcyG6mE7eUjqjbkMv0WNeaMeS97HDm__k6s',
    sort_order: 2,
    active: true
  },
  {
    id: 's3-whitening',
    title_ar: 'تبييض الأسنان بالليزر',
    title_en: 'Laser Teeth Whitening',
    short_ar: 'تفتيح احترافي فوري يزيل التصبغات العميقة ويمنحك ابتسامة ناصعة البياض بجلية واحدة.',
    short_en: 'Immediate professional whitening to eliminate deep stains and illuminate your teeth.',
    details_ar: 'باستخدام أحدث أجهزة الليزر الطبية، نقوم بتبييض الأسنان بآمان وفعالية، مما يضمن تفتيحاً يصل إلى 8 درجات في جلسة واحدة مدتها 45 دقيقة فقط وبأقل حساسية ممكنة للأسنان.',
    details_en: 'Using top-tier medical lasers, we whiten your teeth safely and effectively, achieving up to 8 shades of whitening in a single 45-minute session with absolute comfort and minimal sensitivity.',
    icon: 'whitening',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAi9-BHBZ4IqwyAd1uzPjXKCBxEjyoslolcDuhaLmAEFRolltwxKs0eop7Dh0igVbizUXHxD5dU6GqjHw9Tux5qjHXj3f4pU0Cv9J0QbTgGoanij-LVCQ15YlNAb0bmUvcwLPYAj-teiulmr7ybT5F0DHKWJP2xzHLWwc7sSbVysKWvsH1xeTztkb4XNTmZVpgf9HtoY8B5tiz3r4pF5g_R6SNTNQjbO-2OQUqihKqOBHtt4bY0-RV1Id7umWNwlUAbHpmfeQxwGVw',
    sort_order: 3,
    active: true
  },
  {
    id: 's4-ortho',
    title_ar: 'تقويم الأسنان الشفاف',
    title_en: 'Clear Orthodontics (Aligners)',
    short_ar: 'تقويم ذكي غير مرئي لتصحيح اصطفاف الأسنان برفق ومظهر طبيعي يمنحك ثقة كاملة.',
    short_en: 'Smart invisible aligners to comfortably and discreetly straighten your teeth.',
    details_ar: 'ودع الأسلاك المعدنية المزعجة مع المصففات الشفافة القابلة للإزالة. نستخدم برمجيات النمذجة ثلاثية الأبعاد لتصميم سلسلة مصففات مخصصة تقوم بتحريك أسنانك بلطف إلى الموضع الصحيح وبشكل غير مرئي تماماً.',
    details_en: 'Leave metal braces behind with comfortable, removable clear aligners. We use custom 3D planning to design a sequential series of customized aligners that guide your teeth into pristine alignment invisibly.',
    icon: 'ortho',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIgQybrBw0jdVNJ2TtHXLMeA1YXxaCPaqfDfnXZAOl2WDW6IHxebg5on9BOOjfcY6P5Qb8ERySp-p25DLvdBhmgknzTaqhvBtjlR2_0_CMie_SuHBQhYHflTV4sNaPnUVVrnmPvOgeO6BXkTrpKw9PYEVyQ1CO3wqKfdqZZnR5bqUOgXT2W6MVqxJMtRAGVGFNwh-497AHrUdc35ALEDADbCDPw8XO_ZBhk5gHVI5wJYL1Ob2mjg7OarEQRKNlSzE0AFRuHi0k9uU',
    sort_order: 4,
    active: true
  },
  {
    id: 's5-rootcanal',
    title_ar: 'علاج الجذور المجهري',
    title_en: 'Microscopic Root Canal Treatment',
    short_ar: 'علاج دقيق ومريح لعصب الأسنان باستخدام المجهر الإلكتروني لضمان جودة استثنائية ونسبة نجاح كاملة.',
    short_en: 'State-of-the-art dental pulp treatment using endodontic microscopes for complete success.',
    details_ar: 'علاج جذور الأسنان لم يعد مؤلماً. مع استخدام المجاهر المتقدمة والتخدير الرقمي الموضعي، نقوم بتطهير وحشو قنوات العصب الدقيقة بمنتهى السلاسة وبدقة غير مسبوقة تضمن الحفاظ على أسنانك الطبيعية.',
    details_en: 'Root canals are no longer daunting. With high-magnification microscopes and digital anesthesia, we clean and seal microscopic pulp canals seamlessly, maximizing preservation of your natural tooth structure.',
    icon: 'biotech',
    image_url: null,
    sort_order: 5,
    active: true
  },
  {
    id: 's6-cleaning',
    title_ar: 'تنظيف وتلميع الأسنان',
    title_en: 'Dental Prophylaxis & Scaling',
    short_ar: 'إزالة الجير والترسبات العلوية وتلميع الأسطح بأحدث أجهزة الموجات فوق الصوتية لحماية اللثة ونضارة الفم.',
    short_en: 'Advanced scaling and ultrasonic polishing to prevent periodontitis and keep breath fresh.',
    details_ar: 'خدمة وقائية ممتازة تشمل إزالة التصبغات والترسبات الكلسية الصلبة من على أسطح الأسنان وتحت اللثة باستخدام الموجات فوق الصوتية، ثم التلميع بمسحوق اللؤلؤ الناعم لإعطاء أسنانك لمعاناً وصحة مثالية.',
    details_en: 'A premier preventive care session involving scaling, plaque elimination, and deep calculus extraction via advanced ultrasonic tools, followed by micro-pearl powder polishing for an incredible shine and gums vitality.',
    icon: 'clean_hands',
    image_url: null,
    sort_order: 6,
    active: true
  }
];

const defaultGallery: GalleryItem[] = [
  {
    id: 'g1',
    service_id: 's1-implants',
    category: 'before_after',
    title_ar: 'نتائج زراعة الأسنان الكاملة',
    title_en: 'Full Arch Digital Implants Transition',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBbaBoAqhXNBgoh5ecdIqXvLXkLJD5eGXJgj6xkSvSDxhz2E7rNuUN70w2W4TXps1CxOYOJ7u-DSpdrweZayddj3fPxw1ij2sx5tuh1y5Fq5kKFdU-VwT-Wly8OA76B591UWCYJb90tblgOyoT9ZVqA8pOLwbW0DFR1jESGimIEqDT60M-mza4NAVk07KAJ9iB5-sW61_NmDfEiAPpgKFxei70YHJMGxDaFx3yONX-kj9TDxq3HVMUeFoTElJV64CHxFsMCNL9Mb8Q'
  },
  {
    id: 'g2',
    service_id: 's1-implants',
    category: 'clinic',
    title_ar: 'البيئة العلاجية الفاخرة',
    title_en: 'Ultra-Modern Clinical Suite',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDR54vqULR55DeThVM_mapE-KhydWzjigm1qrAr1SJ9jodmDvyrXiC67dcuUvqNuoIBrbuqMl5GVlFUQbtxoOLZOzRT7CQ6EGIeUqZrhtW_t4e8_rHiJC8N9mgduhn5asfCbRvuucxiZZ_Gl-R023ROCgpmeEyq5du_Mc14GPdoflWOCQiZi58Z9_i6N12k7vbgbLDOc7ir9o6XQoPfiWoZ-QKOJi3OhX3K6rVeh_BW_s0WDvKnTrnHdVboDCuo7kCPjwg6oStDByI'
  },
  {
    id: 'g3',
    service_id: 's1-implants',
    category: 'technology',
    title_ar: 'تقنيات المسح ثلاثي الأبعاد',
    title_en: 'Intraoral 3D Digital Scanner',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCRBolvbl_5l2t7jfUBHQFjudqNMF-1aduORceeJJYsp4FJmHC4Chx6EpWc3mU5aL_q8J7wz9sKYzj04ILYC_IaE9W1ZSi_WKXGOAX5vE_UG1lpKaJ3gpPmfqkmZ5LUCE48zuJXpC095U7Z8NRFktND6vsW2py5FA7QlmV3wQyN76VHEnovY_rZ9P6b_pM_l_h8EnC-ct0UbJOxUTgfIwwUSKeUPv9A4FW1hJTiqFhz_T5V3WFLpuj6ADtpr6pea6KhCK88GFR84DU'
  },
  {
    id: 'g4',
    service_id: null,
    category: 'team',
    title_ar: 'د. مصطفى أثناء الجراحة الدقيقة',
    title_en: 'Dr. Mustafa Performing Micro-Surgery',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCuPWYXbjIOtJXRnmuxm-iQbL-eUvSXF5CAFCFR6bdK4-l5IfnYRHfo_nyCOTGXYF3rIVAgIEq1XmTu4Z3KPhotBBqFsVQ6G-nzQUlzHXVG4eg-A0aS_2C58tnMdEUzVT1yCSXCNzRq_KHd9ErVV_IZkA2QTvbgjMlZKag0aA_Bu707NKws4U8QfpH6yWjb5OTOonjOSn1yR_m26kgj1XwPcDBo0nHc-tk1hk81lf_CxYNIvWwTFvy1MommHTvmqUwqxuXhfB8cr1s'
  },
  {
    id: 'g5',
    service_id: 's2-veneers',
    category: 'before_after',
    title_ar: 'تصميم الابتسامة ومظهر الفينير',
    title_en: 'Veneers Cosmetic Smile Design Result',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBqMXz8MAjmjwfJgn0tKIIXduy0LG4tv8QWFn24Vo4sIoX4Jc36Rpg0MXKylJiCk9GKqRcdBBuMKXZH2zWTUAtFgrMpUVMHlcI2MhuecOCU6lENbBIOYIomrNtHFtSPRhV7J3SOklaSTquHCt_JjEMHNZlVX5S4B-wWXlGpuAKQit2CJqYHrzDZpFtTnxcX9lBsa26LKs_XGDPh9cbf4M_MmDjaxIRORLbM7PWwq79KIq_LScfwZ0lTXXxb2yeTCY2jaM2c0D4Y-G0'
  },
  {
    id: 'g6',
    service_id: 's1-implants',
    category: 'technology',
    title_ar: 'خراطة تيجان البورسلين الرقمية',
    title_en: 'Digital CAD-CAM Dental Milling',
    image_url: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCg5VrgrZucvrQeGpoz06UIFgtQurFqgG9094mSSR0k7uCuzmQLkMVNHceMZMixZnOA4DRaRnQ1eUP5NsYoIkGMFU0-mSO1Y6escYCxV61QX_evkAiiUiBC0FVL9d-ChVE76qRRjfSOPxXx4CvdsjFODq2zaGioJMw9g-XJVmAA5UbcptKXuyTHsv64l6dd2ZccW1VxMiMR5rQsAt50OjYfyTpmY6DPWaXyrAFbl7WnReMYp-LhS3jDjmhQM3SrBEkgb6f4cPoWnmA'
  }
];

// Helper to interact with LocalStorage database
const getLocalData = <T>(key: string, defaultValue: T): T => {
  const data = localStorage.getItem(key);
  if (!data) {
    localStorage.setItem(key, JSON.stringify(defaultValue));
    return defaultValue;
  }
  return JSON.parse(data) as T;
};

const setLocalData = <T>(key: string, value: T): void => {
  localStorage.setItem(key, JSON.stringify(value));
};

// Database API
export const db = {
  async getDoctors(): Promise<Doctor[]> {
    if (supabase) {
      try {
        const { data, error } = await supabase.from('doctors').select('*');
        if (error) throw error;
        if (data && data.length > 0) {
          return data.map((doc: any) => ({
            ...doc,
            full_name: doc.full_name_ar || doc.full_name_en || doc.full_name,
          }));
        }
      } catch (err) {
        console.warn('Supabase getDoctors error, falling back to local storage:', err);
      }
    }
    return getLocalData<Doctor[]>('dental_doctors', defaultDoctors);
  },

  async getServices(): Promise<Service[]> {
    if (supabase) {
      try {
        const { data, error } = await supabase
          .from('services')
          .select('*')
          .eq('active', true)
          .order('sort_order', { ascending: true });
        if (error) throw error;
        if (data && data.length > 0) {
          return data.map((srv: any) => ({
            ...srv,
            title_ar: srv.name_ar || srv.title_ar,
            title_en: srv.name_en || srv.title_en,
            short_ar: srv.short_desc_ar || srv.short_ar,
            short_en: srv.short_desc_en || srv.short_en,
          }));
        }
      } catch (err) {
        console.warn('Supabase getServices error, falling back to local storage:', err);
      }
    }
    return getLocalData<Service[]>('dental_services', defaultServices);
  },

  async getGalleryItems(): Promise<GalleryItem[]> {
    if (supabase) {
      try {
        const { data, error } = await supabase.from('gallery').select('*');
        if (error) throw error;
        if (data && data.length > 0) return data;
      } catch (err) {
        console.warn('Supabase getGalleryItems error, falling back to local storage:', err);
      }
    }
    return getLocalData<GalleryItem[]>('dental_gallery', defaultGallery);
  },

  async getClinicSettings(): Promise<ClinicSettings> {
    if (supabase) {
      try {
        const { data, error } = await supabase.from('settings').select('*').limit(1);
        if (error) throw error;
        if (data && data.length > 0) return data[0];
      } catch (err) {
        console.warn('Supabase getClinicSettings error, falling back to local storage:', err);
      }
    }
    return getLocalData<ClinicSettings>('dental_settings', defaultSettings);
  },

  async createAppointment(appointment: Omit<Appointment, 'id' | 'status' | 'created_at'>): Promise<Appointment> {
    const newAppointment: Appointment = {
      ...appointment,
      id: Math.random().toString(36).substr(2, 9),
      status: 'pending',
      created_at: new Date().toISOString()
    };

    if (supabase) {
      try {
        const { data, error } = await supabase
          .from('appointments')
          .insert([{
            patient_name: appointment.patient_name,
            phone: appointment.phone,
            email: appointment.email,
            service_id: appointment.service_id,
            preferred_language: appointment.preferred_language || 'ar',
            appointment_date: appointment.appointment_date,
            appointment_time: appointment.appointment_time,
            notes: appointment.notes,
            status: 'pending'
          }])
          .select();
        
        if (error) throw error;
        if (data && data[0]) {
          // Sync with local storage for visual record tracking
          const appointments = getLocalData<Appointment[]>('dental_appointments', []);
          appointments.push(data[0]);
          setLocalData('dental_appointments', appointments);
          return data[0];
        }
      } catch (err) {
        console.warn('Supabase createAppointment error, saving locally:', err);
      }
    }

    // Fallback to saving in LocalStorage
    const appointments = getLocalData<Appointment[]>('dental_appointments', []);
    appointments.push(newAppointment);
    setLocalData('dental_appointments', appointments);
    return newAppointment;
  },

  async getAppointments(): Promise<Appointment[]> {
    // Note: User DDL restricts public selects on appointments table (Row level security 'Public read appointments disabled' using false).
    // So we primarily read from local storage to allow the user to view their booked sessions in this demo!
    return getLocalData<Appointment[]>('dental_appointments', []);
  }
};
