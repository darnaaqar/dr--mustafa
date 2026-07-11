-- Supabase PostgreSQL Schema (Bilingual Arabic/English) with Premium Demo Data

-- 1. Setup Extensions & Tables
create extension if not exists pgcrypto;

drop table if exists appointments cascade;
drop table if exists gallery cascade;
drop table if exists services cascade;
drop table if exists doctors cascade;
drop table if exists settings cascade;

create table doctors(
 id uuid primary key default gen_random_uuid(),
 full_name_ar text not null,
 full_name_en text not null,
 title_ar text,
 title_en text,
 about_ar text,
 about_en text,
 qualifications_ar text,
 qualifications_en text,
 experience_years int default 0,
 image_url text,
 phone text,
 email text,
 whatsapp text,
 facebook text,
 instagram text,
 created_at timestamptz default now()
);

create table services(
 id uuid primary key default gen_random_uuid(),
 name_ar text not null,
 name_en text not null,
 short_desc_ar text,
 short_desc_en text,
 details_ar text,
 details_en text,
 benefits_ar text,
 benefits_en text,
 icon text,
 image_url text,
 sort_order int default 1,
 active boolean default true
);

create table gallery(
 id uuid primary key default gen_random_uuid(),
 service_id uuid references services(id) on delete set null,
 category text check(category in ('clinic','before_after','technology','team')),
 title_ar text,
 title_en text,
 description_ar text,
 description_en text,
 image_url text not null,
 created_at timestamptz default now()
);

create table appointments(
  id uuid primary key default gen_random_uuid(),
  device_id text not null,
  patient_name text not null,
  phone text not null,
  email text,
  service_id uuid references services(id),
  preferred_language text default 'ar' check(preferred_language in ('ar','en')),
  appointment_date date not null,
  appointment_time time not null,
  notes text,
  status text default 'pending' check(status in ('pending','approved','completed','cancelled')),
  created_at timestamptz default now()
);

create table settings(
 id boolean primary key default true,
 clinic_name_ar text,
 clinic_name_en text,
 slogan_ar text,
 slogan_en text,
 address_ar text,
 address_en text,
 working_hours_ar text,
 working_hours_en text,
 phone text,
 whatsapp text,
 email text,
 website text,
 google_map text,
 logo_url text,
 hero_image_url text,
 facebook text,
 instagram text,
 tiktok text,
 youtube text,
 constraint one_row check(id)
);

-- 2. Insert Premium Settings Data
insert into settings(
  id,
  clinic_name_ar,
  clinic_name_en,
  slogan_ar,
  slogan_en,
  address_ar,
  address_en,
  working_hours_ar,
  working_hours_en,
  phone,
  whatsapp,
  email,
  website,
  google_map,
  logo_url,
  hero_image_url,
  facebook,
  instagram,
  tiktok,
  youtube
)
values(
  true,
  'عيادة د. مصطفى الرفاعي لطب وتجميل الأسنان',
  'Dr. Mustafa Al-Rifai Dental Care & Aesthetics',
  'إبتسامة صحية.. مظهر أجمل.. حياة أفضل',
  'Healthy smile.. Beautiful look.. Better life',
  'شارع التخصصي، الرياض، المملكة العربية السعودية',
  'Takhassusi Street, Riyadh, Saudi Arabia',
  'السبت - الخميس: ٩:٠٠ صباحاً - ٩:٠٠ مساءً',
  'Saturday - Thursday: 9:00 AM - 9:00 PM',
  '+966 50 123 4567',
  '966501234567',
  'info@dr-mustafa-clinic.com',
  'https://dr-mustafa-clinic.com',
  'https://maps.google.com/?q=Riyadh',
  'https://lh3.googleusercontent.com/aida/AP1WRLvgpJuNbz7ZGBSUud_zbYaRxgvpRkXubIr9UDnaFKaCeDZH5fWaQtfNJE9WRNmtOJeAjeGXfGK_iajc4akHDTJjiyZC5ATTuYC--1l7gOgaq35HTTNE0KiTX9vlW-WthJ87N_OAxlXAR7grSPmEisQhtU6Obp9FNyv6SKR4dad81sTNF8-0sKgWccdIiq9J9hI1HejVCC00DAP7ioDxnnWCGgNdmwyD2-MDvhpZyedHKIUXyzjdGJGNT7I',
  'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=1200',
  'https://facebook.com/dr.mustafa.clinic',
  'https://instagram.com/dr.mustafa.clinic',
  'https://tiktok.com/@dr.mustafa.clinic',
  'https://youtube.com/dr.mustafa.clinic'
)
on conflict(id) do update set
  clinic_name_ar = excluded.clinic_name_ar,
  clinic_name_en = excluded.clinic_name_en,
  slogan_ar = excluded.slogan_ar,
  slogan_en = excluded.slogan_en,
  address_ar = excluded.address_ar,
  address_en = excluded.address_en,
  working_hours_ar = excluded.working_hours_ar,
  working_hours_en = excluded.working_hours_en,
  phone = excluded.phone,
  whatsapp = excluded.whatsapp,
  email = excluded.email,
  website = excluded.website,
  google_map = excluded.google_map,
  logo_url = excluded.logo_url,
  hero_image_url = excluded.hero_image_url,
  facebook = excluded.facebook,
  instagram = excluded.instagram,
  tiktok = excluded.tiktok,
  youtube = excluded.youtube;

-- 3. Insert Premium Doctor Profile Seed
insert into doctors(
  id,
  full_name_ar,
  full_name_en,
  title_ar,
  title_en,
  about_ar,
  about_en,
  qualifications_ar,
  qualifications_en,
  experience_years,
  image_url,
  phone,
  email,
  whatsapp,
  facebook,
  instagram
) values (
  '11111111-2222-3333-4444-555555555555',
  'د. مصطفى الرفاعي',
  'Dr. Mustafa Al-Rifai',
  'استشاري زراعة وتجميل الأسنان',
  'Consultant in Implantology & Aesthetic Dentistry',
  'يعد الدكتور مصطفى الرفاعي أحد رواد طب الأسنان الرقمي والتجميلي بمجموع خبرة تتجاوز 15 عاماً في تصميم الابتسامات الرقمية المتطورة وهندسة حيوية الفم لتعود بأجمل شكل وأقوى متانة.',
  'Dr. Mustafa Al-Rifai is a leading pioneer of digital and cosmetic dentistry with over 15 years of experience in advanced CAD-CAM digital smile designs and biological oral rehabilitation.',
  'البورد السويسري في تجميل الأسنان، زمالة الجمعية الدولية لزراعة الأسنان (ITI)، دكتوراه طب وجراحة الفم والأسنان.',
  'Swiss Board in Aesthetic Dentistry, Fellow of the International Team for Implantology (ITI), Ph.D. in Dental Medicine & Oral Surgery.',
  15,
  'https://lh3.googleusercontent.com/aida-public/AB6AXuA8IhJhiFXgCJoUCUhdnc489Z5-t5f73w8_vrm1xpYXedmkJ03q-koJmRfbOUzS_KQB0wsM6NaXDIHtJwV0K5zDDPGeUiBqxJ1vahCOg4L_EOFtulSHKST682LV0CZ5esHQYRSk_GGGGfRSBitnzecYBWkSCsJoqy8_nsg06W7xEsAhpHHHrHBwqXslITJ85aSDIxTyNuG8ThD74NSybCASpY9V3MVWaet_3GWL3yhamaVQj4dbDGJVwpsxnrt-nByMJbCOw2YSxps',
  '+966 50 123 4567',
  'dr.mustafa@dr-mustafa-clinic.com',
  '966501234567',
  'https://facebook.com/dr.mustafa.clinic',
  'https://instagram.com/dr.mustafa.clinic'
);

-- 4. Insert Services Seed (Matching strict functional requirements) - 8 services total
insert into services(
  id,
  name_ar,
  name_en,
  short_desc_ar,
  short_desc_en,
  details_ar,
  details_en,
  benefits_ar,
  benefits_en,
  icon,
  image_url,
  sort_order,
  active
) values 
-- Service 1: Laser Teeth Whitening
(
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea1',
  'تبييض الأسنان بالليزر',
  'Laser Teeth Whitening',
  'ابتسامة ناصعة البياض خالية من الحساسية خلال جلسة واحدة بأحدث تقنيات الليزر البارد.',
  'Bright white, sensitivity-free smile in one session using premium cold laser systems.',
  'جلسة تبييض متكاملة مدتها 45 دقيقة تجمع بين مادة التبييض النشطة وموجات الليزر البارد المتطورة لضمان إزالة تامة للتصبغات العنيدة بدون أي ألم.',
  'A complete 45-minute treatment combining state-of-the-art cold laser and customized clinical whitening agents to eliminate deepest stains painlessly.',
  'تبييض يصل إلى 8 درجات أفتح، حماية كاملة للمينا، حماية ضد حساسية اللثة والأسنان.',
  'Up to 8 shades lighter, zero-enamel wearing formula, complete defense against gum sensitivity.',
  'Sparkles',
  'https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&q=80&w=600',
  1,
  true
),
-- Service 2: Premium Veneers & Smile Design
(
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea2',
  'الفينير والعدسات التجميلية',
  'Premium Veneers & Smile Design',
  'ابتسامة هوليوود المتناسقة والمصممة خصيصاً لتناسب ملامح وجهك بدقة متناهية.',
  'Your custom-crafted Hollywood smile, designed digitally to match your facial proportions.',
  'نستخدم تقنية عدسات الإيماكس (e.Max) السويسرية فائقة الرقة لتقديم ابتسامة متناسقة مفعمة بالحيوية واللمعان تتطلب الحد الأدنى من تحضير الأسنان.',
  'We craft ultra-thin biological porcelain e.Max veneers tailored to your mouth structure to give you an extremely natural smile with minimal tooth reduction.',
  'تعديل فوري للون والاصطفاف، مظهر طبيعي 100% متناسب حيوياً، مقاوم تماماً للتصبغات.',
  'Instant shade and alignment restoration, 100% life-like translucency, highly stain-resistant finish.',
  'Smile',
  'https://images.unsplash.com/photo-1598256989800-fe5f95da9787?auto=format&fit=crop&q=80&w=600',
  2,
  true
),
-- Service 3: Digital Dental Implants
(
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea3',
  'زراعة الأسنان الرقمية',
  'Digital Dental Implants',
  'تعويض الأسنان المفقودة بغرسات تيتانيوم حيوية موجهة بالكمبيوتر وبدون ألم.',
  'Replace missing teeth with computer-guided, biological titanium implants painlessly.',
  'نعتمد على التخطيط ثلاثي الأبعاد الموجه بالكمبيوتر لوضع الغرسات بدقة متناهية وتفادي الشقوق الجراحية الكبيرة، مما يضمن شفاءً فائق السرعة واستعادة فورية للابتسامة.',
  'Using fully digital 3D CAD-CAM surgical guides, we place premium biocompatible titanium implants with high micrometric precision and minimal healing downtime.',
  'إجراء بدون ألم، ثبات دائم مدى الحياة، استعادة كاملة لوظيفة وصحة الفك.',
  'Painless clinical setup, lifelong structural durability, flawless natural chewing and health restoration.',
  'Shield',
  'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&q=80&w=600',
  3,
  true
),
-- Service 4: Invisalign Clear Aligners
(
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea4',
  'تقويم الأسنان غير المرئي',
  'Invisalign Clear Aligners',
  'اصطفاف أسنان مثالي مع قوالب شفافة ومريحة قابلة للإزالة دون حديد أو أسلاك.',
  'Achieve perfect alignment with fully removable, transparent clear aligners without metal braces.',
  'تعديل اصطفاف الأسنان باستخدام تقنية Invisalign الرائدة وسلسلة من القوالب الشفافة التي يتم تصميمها خصيصاً بنمذجة ثلاثية الأبعاد لتتحرك أسنانك برفق للمكان الصحيح.',
  'Straighten teeth with Invisalign advanced technology, featuring custom-crafted clear aligner series built via high-precision 3D digital scans for active, gentle tooth motion.',
  'شفاف وغير مرئي تماماً، مريح جداً وقابل للإزالة لتناول الطعام، حماية تامة للثة والأسنان.',
  'Virtually invisible, comfortable and removable, promotes excellent oral hygiene and wellness.',
  'Activity',
  'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=600',
  4,
  true
),
-- Service 5: Gum Treatment
(
  'a11cb8f0-15cc-4cbe-b4db-996ff2505b01',
  'علاج اللثة المتقدمة',
  'Advanced Gum Treatment',
  'علاج متكامل لمشاكل اللثة من التهاب إلى إعادة بناء Anastamosis utilizingone techniques.',
  'Comprehensive gum disease treatment from inflammation to regenerative procedures.',
  'علاج متخصص للالتهابات اللثوية باستخدام تقنيات التنظيف العميق Regenerative therapy知识和 التئام الجروح.',
  'Specialized periodontal treatment using deep cleaning techniques and regenerative therapy for optimal healing.',
  'علاج جذور متكامل، إعادة نمو أنسجة، حماية دائمة من الالتهاب.',
  'Full root planing treatment, tissue regeneration therapy, permanent inflammation protection.',
  'MedicalServices',
  'https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&q=80&w=600',
  5,
  true
),
-- Service 6: Cosmetic Dentistry
(
  'b22cb8f0-15cc-4cbe-b4db-996ff2505b02',
  'التجميل الشامل',
  'Comprehensive Cosmetic Dentistry',
  'تحويل كامل لمظهر الابتسامة باستخدام تقنيات التجميل المتقدمة المتعددة.',
  'Complete smile transformation using multiple advanced cosmetic dentistry techniques.',
  'نقدم حزمة شاملة من treatments التجميلية تشمل التبييض والفينير والعدسات في خطة علاجية موحدة.',
  'We provide a comprehensive package of cosmetic treatments including whitening, veneers, and lenses in a unified treatment plan.',
  'نتائج فورية، ابتسامة جديدة كلياً، تحسن كبير في المظهر العام.',
  'Instant results, completely new smile, significant improvement in overall appearance.',
  'Sparkles',
  'https://images.unsplash.com/photo-1598256989800-fe5f95da9787?auto=format&fit=crop&q=80&w=600',
  6,
  true
),
-- Service 7: Emergency Dental Care
(
  'c33cb8f0-15cc-4cbe-b4db-996ff2505b03',
  'رعاية طوارئ الأسنان',
  'Emergency Dental Care',
  'خدمات طوارئ أسنان متاحة على مدار الساعة لإدارة الألم والحالات الطارئة.',
  '24/7 emergency dental services available for pain management and urgent cases.',
  'فريق متخصص جاهز للتعامل مع حالات الطوارئ مثل ألم الأسنان الحاد، الكسور، والعدوى.',
  'Specialized team ready to handle emergency cases like severe tooth pain, fractures, and infections.',
  'خدمة 24/7، استجابة سريعة، تخفيف فوري للألم.',
  '24/7 service, rapid response, immediate pain relief.',
  'Shield',
  'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&q=80&w=600',
  7,
  true
),
-- Service 8: Pediatric Dentistry
(
  'd44cb8f0-15cc-4cbe-b4db-996ff2505b04',
  'طب أسنان الأطفال',
  'Pediatric Dentistry',
  'رعاية أسنان مخصصة للأطفال في بيئة ودية ومريحة لضمان تجربة إيجابية.',
  'Specialized dental care for children in a friendly and comfortable environment ensuring positive experience.',
  'نستخدم تقنيات خاصة للتعامل مع الأطفال وتجعل زيارتهم للعيادة تجربة ممتعة وخالية من الخوف.',
  'We use special techniques for children making their clinic visit an enjoyable and fear-free experience.',
  'بيئة صديقة للأطفال، معالجة لطيفة، تعليمات صحية ممتعة.',
  'Kid-friendly environment, gentle treatment, fun health education.',
  'Activity',
  'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=600',
  8,
  true
);

-- 5. Insert Gallery Seed (Bilingual Categories and Titles) - 12 items total (3 per category)
insert into gallery(
  id,
  service_id,
  category,
  title_ar,
  title_en,
  description_ar,
  description_en,
  image_url
) values
-- Before & After (3 items)
(
  gen_random_uuid(),
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea2',
  'before_after',
  'حالة تجميل كامل بالفينير',
  'Full Veneers Smile Makeover',
  'حالة مذهلة لابتسامة هوليوود باستخدام 16 عدسة إيماكس تجميلية فائقة الدقة.',
  'Incredible Hollywood smile makeover utilizing 16 premium ultra-thin e.Max veneers.',
  'https://images.unsplash.com/photo-1598256989800-fe5f95da9787?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea1',
  'before_after',
  'تبييض ليزر احترافي',
  'Professional Laser Whitening Results',
  'نتائج مذهلة لتبييض الأسنان بالليزر البارد - 8 درجات أفتح في جلسة واحدة.',
  'Amazing results from cold laser whitening - 8 shades lighter in a single session.',
  'https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea3',
  'before_after',
  'زراعة فورية كاملة',
  'Full Immediate Load Implants',
  'استعادة كاملة للابتسامة باستخدام الزراعات الفورية - تحول مذهل في يوم واحد.',
  'Complete smile restoration using immediate load implants - amazing transformation in one day.',
  'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&q=80&w=600'
),

-- Technology (3 items)
(
  gen_random_uuid(),
  null,
  'technology',
  'المسح الرقمي ثلاثي الأبعاد CAD-CAM',
  'High-Precision 3D CAD-CAM Scan',
  'أجهزة المسح الرقمية المتقدمة لأخذ طبعات دقيقة وتصميم التركيبات والزراعات فورياً.',
  'Cutting-edge intraoral 3D scanner for printing high-accuracy mockups and planning implants.',
  'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  null,
  'technology',
  'روبوت الجراحة الرقمية',
  'Digital Surgical Robot',
  'نظام الجراحة الرقمية الموجه بالكمبيوتر لزراعة الأسنان بدقة متناهية.',
  'Computer-guided digital surgical system for dental implants with micrometric precision.',
  'https://images.unsplash.com/photo-1551076805-e1869033e561?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  null,
  'technology',
  'تصميم الابتسامة بالذكاء الاصطناعي',
  'AI Smile Design Technology',
  'برامج ذكية متطورة لتصميم الابتسامة المثالية قبل بدء العلاج.',
  'Advanced AI software for designing the perfect smile before treatment begins.',
  'https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&q=80&w=600'
),

-- Clinic (3 items)
(
  gen_random_uuid(),
  null,
  'clinic',
  'غرفةTreatment الفاخرة المجهزة بالكامل',
  'Luxury Treatment Suite',
  'بيئة علاجية هادئة ومعقمة مزودة بأعلى معايير التكنولوجيا الطبية وسبل الراحة.',
  'A tranquil, fully sterilized environment equipped with premium state-of-the-art dental units.',
  'https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  null,
  'clinic',
  'قسم الجراحات المتقدمة',
  'Advanced Surgery Department',
  'غرف عمليات مجهزة بأحدث التقنيات لأجراء العمليات الجراحية الدقيقة.',
  'Operating rooms equipped with latest technology for precise surgical procedures.',
  'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  null,
  'clinic',
  'استقبال المرضى الفاخر',
  'Premium Patient Reception',
  'صالة استقبال فاخرة ومريحة لتجربة علاجية مميزة من لحظة الوصول.',
  'Luxury and comfortable reception lounge for a distinctive treatment experience from arrival.',
  'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=600'
),

-- Team (3 items)
(
  gen_random_uuid(),
  null,
  'team',
  'الدكتور مصطفى مع الفريق المساعد',
  'Dr. Mustafa with clinical support team',
  'كادر طبي وتمريضي متكامل يقدم لكم الرعاية الطبية الفائقة بروح ملؤها الود والمهنية.',
  'A highly qualified team of dental assistants and professionals dedicated to your clinical comfort.',
  'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  null,
  'team',
  'فريق التخدير والرقابة',
  'Anesthesia & Monitoring Team',
  'فريق متخصص في التخدير والرقابة الحيوية لضمان راحة وأمان المرضى.',
  'Specialized anesthesia and monitoring team ensuring patient comfort and safety.',
  'https://images.unsplash.com/photo-1631815588090-4cc6959f2c2f?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  null,
  'team',
  'فريق التصميم الرقمي',
  'Digital Design Team',
  'خبراء في تصميم الابتسامات الرقمية باستخدام أحدث برامج CAD-CAM.',
  'Experts in digital smile design using latest CAD-CAM software technologies.',
  'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=600'
);

-- 6. Insert Demo Active Bookings / Appointments
insert into appointments(
  id,
  device_id,
  patient_name,
  phone,
  email,
  service_id,
  preferred_language,
  appointment_date,
  appointment_time,
  notes,
  status
) values
(
  gen_random_uuid(),
  'demo-device-001',
  'أحمد الشمري',
  '0501112233',
  'ahmed@demo.com',
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea2',
  'ar',
  current_date + interval '1 day',
  '10:30:00',
  'حالة استشارة بخصوص عدسات الفينير التجميلية وتجربة الابتسامة الافتراضية.',
  'pending'
),
(
  gen_random_uuid(),
  'demo-device-002',
  'Sarah Jenkins',
  '0553334455',
  'sarah.j@demo.com',
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea1',
  'en',
  current_date + interval '2 days',
  '15:00:00',
  'Prefers cold laser system whitening for sensitive teeth.',
  'approved'
);

-- 7. Security Policies (RLS) Configuration
alter table doctors enable row level security;
alter table services enable row level security;
alter table gallery enable row level security;
alter table appointments enable row level security;
alter table settings enable row level security;

-- Drop prior policies to avoid duplications
drop policy if exists doctors_read on doctors;
drop policy if exists services_read on services;
drop policy if exists gallery_read on gallery;
drop policy if exists settings_read on settings;
drop policy if exists appointments_insert on appointments;

-- Create Public Read Access Policies
create policy doctors_read on doctors for select using(true);
create policy services_read on services for select using(true);
create policy gallery_read on gallery for select using(true);
create policy settings_read on settings for select using(true);

-- Create Interactive Public Insert Policies
create policy appointments_insert on appointments for insert with check(true);
