import React, { useState, useEffect } from 'react';
import { motion } from 'motion/react';
import { db } from '../lib/db';
import { Doctor } from '../types';
import { Language, translations } from '../utils/i18n';
import { 
  Award, GraduationCap, Calendar, ShieldAlert, HeartHandshake, History, Check 
} from 'lucide-react';

interface AboutTabProps {
  lang: Language;
  onBookClick: () => void;
}

export default function AboutTab({ lang, onBookClick }: AboutTabProps) {
  const t = translations[lang];

  // States
  const [doctor, setDoctor] = useState<Doctor | null>(null);

  // Fetch Doctor Profile
  useEffect(() => {
    async function loadDoctor() {
      const docs = await db.getDoctors();
      if (docs.length > 0) {
        setDoctor(docs[0]);
      }
    }
    loadDoctor();
  }, []);

  if (!doctor) return null;

  return (
    <div className="space-y-8 pb-12">
      {/* Profile Header Hero */}
      <section className="flex flex-col items-center text-center space-y-4 pt-4">
        <div className="relative">
          <div className="absolute -inset-1.5 bg-[#00D8FF]/20 rounded-full blur-xl animate-pulse"></div>
          <div className="relative w-36 h-36 rounded-full border-2 border-[#00D8FF]/50 p-1 bg-[#0F1D2A] overflow-hidden shadow-[0_0_25px_rgba(0,216,255,0.3)]">
            <img 
              src={doctor.image_url || 'https://lh3.googleusercontent.com/aida-public/AB6AXuBQGk9T8T-E-dTpTss5FQxeaLgfuT6D7b8knwLxoma7ZhneQUbTV6jegwf83Rz3Wsi-1ojfZUr4lObSfdbX8qJs_GRO-1BDl9AUgNUb0Z60o8xRS9X-FtvMzMNib-qoykcBsefefS1Hhaf0u5mEuLb83liLjH7sos8ZJOA7njPRorV-taMls7PyH_FyRFsPwcu0h8c2UUGlTi9rSDRoelBrHe30tc3qJpL7eQi6euwC_Dofi6FIaIkTEyIqa6zWRKrNA2ZqGbxXlPo'} 
              alt={doctor.full_name}
              className="w-full h-full rounded-full object-cover"
            />
          </div>
          {/* Verified Badge */}
          <div className="absolute -bottom-1 -right-1 bg-[#00D8FF] text-[#07131E] p-1 rounded-full border border-white/20 shadow-lg flex items-center justify-center">
            <Check size={14} className="font-bold" />
          </div>
        </div>

        <div className="space-y-1">
          <h2 className="font-arabic-headline text-2xl font-bold text-white drop-shadow-[0_0_8px_rgba(0,216,255,0.4)]">
            {lang === 'ar' ? doctor.full_name : 'Dr. Mustafa Al-Rifai'}
          </h2>
          <p className="text-xs text-[#B6D3E5] tracking-wider font-semibold font-arabic-body">
            {lang === 'ar' ? doctor.title_ar : doctor.title_en}
          </p>
          <p className="text-[10px] text-[#00D8FF] uppercase font-mono tracking-widest mt-1">
            Consultant in Dental Care & Aesthetics
          </p>
        </div>
      </section>

      {/* Stats Bento Grid (Screenshot 5) */}
      <div className="grid grid-cols-3 gap-3">
        <div className="glass-card rounded-xl p-4 flex flex-col items-center justify-center border-l-2 border-l-[#14d8ff] border-white/5 text-center">
          <span className="text-[#14d8ff] font-bold text-lg">+{doctor.experience_years}</span>
          <span className="text-[9px] text-[#859398] font-bold uppercase mt-1 leading-tight">{t.years_exp}</span>
        </div>
        <div className="glass-card rounded-xl p-4 flex flex-col items-center justify-center border-l-2 border-l-[#03d4ed] border-white/5 text-center">
          <span className="text-[#03d4ed] font-bold text-lg">+5000</span>
          <span className="text-[9px] text-[#859398] font-bold uppercase mt-1 leading-tight">{t.success_cases}</span>
        </div>
        <div className="glass-card rounded-xl p-4 flex flex-col items-center justify-center border-l-2 border-l-tertiary-container border-white/5 text-center">
          <span className="text-tertiary font-bold text-lg">+10</span>
          <span className="text-[9px] text-[#859398] font-bold uppercase mt-1 leading-tight">{t.certificates}</span>
        </div>
      </div>

      {/* Qualifications (Screenshot 5) */}
      <section className="space-y-4">
        <div className="flex items-center gap-2">
          <GraduationCap className="text-[#14d8ff]" size={20} />
          <h3 className="font-arabic-headline text-lg font-bold text-white">{t.qualifications}</h3>
          <div className="flex-grow h-px bg-gradient-to-r from-white/5 to-transparent"></div>
        </div>
        <div className="space-y-3">
          {[
            {
              title_ar: 'ماجستير في طب الأسنان التجميلي',
              title_en: 'Master in Cosmetic Dentistry',
              desc_ar: 'الأكاديمية الدولية لطب الأسنان الحديث وتجميل الوجه.',
              desc_en: 'International Academy of Cosmetic Dentistry & Facial Aesthetics.'
            },
            {
              title_ar: 'عضو الجمعية الأمريكية لطب الأسنان (ADA)',
              title_en: 'Member of American Dental Association',
              desc_ar: 'المشاركة الدائمة في تطوير معايير الجودة الطبية والتقنية.',
              desc_en: 'Actively shaping modern safety and aesthetic guidelines globally.'
            },
            {
              title_ar: 'دورات متقدمة في زراعة وتجميل الأسنان',
              title_en: 'Advanced Courses in Implants & Aesthetics',
              desc_ar: 'تدريب سريري متكامل في جراحات الفك الدقيقة وزراعة العظام.',
              desc_en: 'Advanced clinical internships covering computer-guided bone grafting.'
            }
          ].map((q, idx) => (
            <div key={idx} className="glass-card p-4 rounded-xl flex items-start gap-4 border border-white/5 hover:border-[#14d8ff]/30 transition-all">
              <div className="bg-[#14d8ff]/10 p-2 rounded-lg text-[#14d8ff] shrink-0">
                <Award size={18} />
              </div>
              <div>
                <h4 className="font-arabic-body font-bold text-white text-sm">
                  {lang === 'ar' ? q.title_ar : q.title_en}
                </h4>
                <p className="text-xs text-outline mt-1 leading-relaxed">
                  {lang === 'ar' ? q.desc_ar : q.desc_en}
                </p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* Philosophy Card */}
      <section className="glass-card p-6 rounded-2xl relative overflow-hidden border border-white/5">
        <div className="absolute top-0 left-0 w-1 h-full bg-[#14d8ff]"></div>
        <div className="absolute -top-10 -right-10 w-40 h-40 bg-[#14d8ff]/5 rounded-full blur-3xl"></div>
        <div className="flex items-center gap-2 mb-4">
          <HeartHandshake className="text-[#14d8ff]" size={20} />
          <h3 className="font-arabic-headline text-lg font-bold text-white">{t.philosophy}</h3>
        </div>
        <p className="text-outline font-arabic-body text-xs leading-relaxed text-justify">
          {lang === 'ar' ? doctor.about_ar : doctor.about_en}
        </p>
        <div className="mt-6 flex justify-between items-center px-4 py-3 bg-[#0e1417]/50 rounded-xl border border-white/5">
          <span className="text-[9px] uppercase font-bold text-outline flex items-center gap-1">
            <span className="w-1.5 h-1.5 rounded-full bg-[#00D8FF]"></span>
            {t.precise_tech}
          </span>
          <span className="text-[9px] uppercase font-bold text-[#B6D3E5] flex items-center gap-1">
            <span className="w-1.5 h-1.5 rounded-full bg-[#00D8FF]"></span>
            {t.luxury_care}
          </span>
          <span className="text-[9px] uppercase font-bold text-[#B6D3E5] flex items-center gap-1">
            <span className="w-1.5 h-1.5 rounded-full bg-[#00D8FF]"></span>
            {t.sterile}
          </span>
        </div>
      </section>

      {/* Professional Career Timeline */}
      <section className="space-y-4">
        <div className="flex items-center gap-2">
          <History className="text-[#00D8FF]" size={20} />
          <h3 className="font-arabic-headline text-lg font-bold text-white">{t.career}</h3>
          <div className="flex-grow h-px bg-gradient-to-r from-white/5 to-transparent"></div>
        </div>
        <div className="relative pl-4 space-y-8 before:absolute before:right-3 before:top-2 before:bottom-2 before:w-0.5 before:bg-[#00D8FF]/20 text-right pr-6">
          <div className="relative pr-6">
            <div className="absolute right-[-23px] top-1.5 w-4 h-4 bg-[#0F1D2A] border-2 border-[#00D8FF] rounded-full flex items-center justify-center">
              <div className="w-1.5 h-1.5 bg-[#00D8FF] rounded-full"></div>
            </div>
            <div>
              <span className="text-[10px] font-bold text-[#00D8FF] bg-[#00D8FF]/15 px-2.5 py-0.5 rounded border border-[#00D8FF]/20 font-mono">
                2020 - {lang === 'ar' ? 'الآن' : 'Present'}
              </span>
              <h4 className="font-arabic-body font-bold text-white text-xs mt-1.5">
                {lang === 'ar' ? 'رئيس قسم التجميل في المركز التخصصي لطب الأسنان' : 'Head of Aesthetics, Premium Dental Center'}
              </h4>
              <p className="text-xs text-[#B6D3E5] mt-1 leading-relaxed">
                {lang === 'ar' 
                  ? 'إدارة وتطوير بروتوكولات تجميل الأسنان المجهري وتصميم الابتسامات ثلاثية الأبعاد.' 
                  : 'Leading computer-guided aesthetic implant and veneer fabrication protocols.'}
              </p>
            </div>
          </div>
          <div className="relative pr-6">
            <div className="absolute right-[-23px] top-1.5 w-4 h-4 bg-[#0F1D2A] border-2 border-white/10 rounded-full flex items-center justify-center">
              <div className="w-1.5 h-1.5 bg-white/20 rounded-full"></div>
            </div>
            <div>
              <span className="text-[10px] font-bold text-[#B6D3E5] bg-white/5 px-2.5 py-0.5 rounded border border-white/5 font-mono">
                2015 - 2020
              </span>
              <h4 className="font-arabic-body font-bold text-white text-xs mt-1.5">
                {lang === 'ar' ? 'محاضر ومستشار جراحي لتقنيات الزرع الفوري' : 'Clinical Lecturer & Surgical Consultant for Implants'}
              </h4>
              <p className="text-xs text-[#B6D3E5] mt-1 leading-relaxed">
                {lang === 'ar' 
                  ? 'تدريب أكثر من 500 طبيب أسنان حول العالم على تقنيات زراعة الأسنان الرقمية الفورية.' 
                  : 'Conducted advanced masterclasses on immediate loading implants across multiple clinics.'}
              </p>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Button */}
      <div className="pt-4">
        <button 
          onClick={onBookClick}
          className="w-full h-14 bg-gradient-to-r from-[#00D4FF] to-[#00A6E6] text-[#07131E] font-bold text-sm tracking-wide rounded-xl shadow-[0_0_15px_rgba(0,216,255,0.4)] active:scale-95 transition-all flex items-center justify-center gap-2 cursor-pointer"
        >
          <Calendar size={18} />
          <span>{t.book_now}</span>
        </button>
      </div>
    </div>
  );
}
