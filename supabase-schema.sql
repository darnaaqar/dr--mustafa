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

-- 4. Insert Services Seed (Matching strict functional requirements)
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
);

-- 5. Insert Gallery Seed (Bilingual Categories and Titles)
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
  'e18cb8f0-15cc-4cbe-b4db-996ff2505ea3',
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
  'clinic',
  'غرفة العلاج الفاخرة المجهزة بالكامل',
  'Luxury Treatment Suite',
  'بيئة علاجية هادئة ومعقمة مزودة بأعلى معايير التكنولوجيا الطبية وسبل الراحة.',
  'A tranquil, fully sterilized environment equipped with premium state-of-the-art dental units.',
  'https://images.unsplash.com/photo-1606811971618-4486d14f3f99?auto=format&fit=crop&q=80&w=600'
),
(
  gen_random_uuid(),
  null,
  'team',
  'الدكتور مصطفى مع الفريق المساعد',
  'Dr. Mustafa with clinical support team',
  'كادر طبي وتمريضي متكامل يقدم لكم الرعاية الطبية الفائقة بروح ملؤها الود والمهنية.',
  'A highly qualified team of dental assistants and professionals dedicated to your clinical comfort.',
  'https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=600'
);

-- 6. Insert Demo Active Bookings / Appointments
insert into appointments(
  id,
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
