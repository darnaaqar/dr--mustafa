import React, { useState, useEffect } from 'react';
import { motion } from 'motion/react';
import { db } from '../lib/db';
import { ClinicSettings } from '../types';
import { Language, translations } from '../utils/i18n';
import { Phone, MessageSquare, Clock, MapPin, ExternalLink, Calendar } from 'lucide-react';

interface ContactTabProps {
  lang: Language;
  onBookClick: () => void;
}

export default function ContactTab({ lang, onBookClick }: ContactTabProps) {
  const t = translations[lang];

  // States
  const [settings, setSettings] = useState<ClinicSettings | null>(null);

  // Fetch Settings
  useEffect(() => {
    async function loadSettings() {
      const srvs = await db.getClinicSettings();
      setSettings(srvs);
    }
    loadSettings();
  }, []);

  if (!settings) return null;

  return (
    <div className="space-y-6 pb-12">
      {/* Header Section */}
      <header className="mb-2 text-right">
        <p className="font-label-sm text-[10px] text-[#00D8FF] uppercase tracking-[0.2em] mb-1">
          {t.contact}
        </p>
        <h2 className="font-arabic-headline text-2xl font-bold text-white mb-2 leading-tight">
          {lang === 'ar' ? (
            <>نحن هنا للعناية <span className="text-[#00D8FF] drop-shadow-[0_0_8px_rgba(0,216,255,0.4)]">بابتسامتك المستقبلية</span></>
          ) : (
            <>We are here for your <span className="text-[#00D8FF] drop-shadow-[0_0_8px_rgba(0,216,255,0.4)]">future smile</span></>
          )}
        </h2>
        <div className="h-[1.5px] w-20 bg-gradient-to-l from-[#00D8FF] to-transparent rounded-full"></div>
      </header>

      {/* Styled Satellite Map Card */}
      <div className="glass-card rounded-2xl aspect-[4/3] relative overflow-hidden group border border-[#00D8FF]/15">
        <div className="absolute inset-0 z-0 bg-[#07131e] opacity-70">
          <img 
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuCoKXEcyqsem-IaThQzsPTZCFqph6F-vKKg5i4UALBiIW_N8xQlgkcMYO1DVaILF_RUAHOV3V0ni8eC1h_MELEdklkAEJx1oe0aD1LxOi-Ra7tJOdqFG5zFamuLjYvh2RY2NRicITOAP3XQDG8j5w9e-k6d6h1yLxMIfo2f43nxdSTnbahhZfGjdeg33ovIOXIQ2Nx_35NAouGSx45MmKiAalwxiHdsnojpfJWaIn1SQzl-IrxA3UWDgtUutL2A2bbkKB2mj9uEF3c" 
            alt="Dubai Satellite Map" 
            className="w-full h-full object-cover opacity-60 scale-105 group-hover:scale-100 transition-transform duration-1000"
          />
        </div>

        {/* HUD Pulse Location Marker */}
        <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-10">
          <div className="relative w-12 h-12 flex items-center justify-center">
            <span className="absolute w-full h-full rounded-full border border-[#00D8FF]/40 animate-ping opacity-75"></span>
            <span className="absolute w-2/3 h-2/3 rounded-full border border-[#00D8FF]/60 animate-pulse opacity-50"></span>
            <div className="relative w-8 h-8 rounded-full bg-[#0F1D2A] border-2 border-[#00D8FF] flex items-center justify-center text-[#00D8FF] shadow-[0_0_15px_rgba(0,216,255,0.6)]">
              <MapPin size={16} fill="currentColor" className="text-[#00D8FF]" />
            </div>
          </div>
        </div>

        {/* Scanning horizontal line */}
        <div className="absolute top-0 left-0 w-full h-[1px] bg-gradient-to-r from-transparent via-[#00D8FF] to-transparent shadow-[0_0_8px_rgba(0,216,255,0.8)] animate-[scan_3s_linear_infinite]"></div>

        {/* Live Location Box Overlay */}
        <div className="absolute top-4 right-4 z-10 max-w-[240px]">
          <div className="bg-[#0F1D2A]/90 backdrop-blur-md p-3 rounded-xl border border-white/5 flex flex-col items-end text-right">
            <span className="text-[9px] font-bold text-[#00D8FF] uppercase tracking-wider mb-1">{t.live_location}</span>
            <div className="flex items-center gap-1.5">
              <span className="text-[11px] font-semibold text-white leading-tight font-arabic-body">
                {lang === 'ar' ? settings.address_ar : settings.address_en}
              </span>
              <span className="w-1.5 h-1.5 rounded-full bg-[#00D8FF] animate-pulse shrink-0"></span>
            </div>
          </div>
        </div>

        {/* External Link */}
        <div className="absolute bottom-4 left-4 z-10">
          <a 
            href={settings.google_map || '#'} 
            target="_blank" 
            referrerPolicy="no-referrer"
            className="bg-[#00D8FF] text-[#07131E] font-bold text-[10px] uppercase tracking-widest px-4 py-2.5 rounded-full shadow-lg hover:shadow-[0_0_12px_rgba(0,216,255,0.5)] active:scale-95 transition-all flex items-center gap-1.5 cursor-pointer decoration-none"
          >
            <span>{t.open_maps}</span>
            <ExternalLink size={10} />
          </a>
        </div>
      </div>

      {/* Contact Cards */}
      <div className="space-y-3">
        {/* Phone Card */}
        <a 
          href={`tel:${settings.phone}`}
          className="glass-card p-4 rounded-xl flex items-center gap-4 border border-[#00D8FF]/15 hover:border-[#00D8FF]/30 hover:bg-[#0F1D2A]/80 transition-all cursor-pointer group text-right flex-row-reverse justify-between"
        >
          <div className="w-12 h-12 rounded-xl bg-[#00D8FF]/10 flex items-center justify-center text-[#00D8FF] group-hover:scale-105 transition-transform duration-300">
            <Phone size={20} />
          </div>
          <div className="flex-1">
            <p className="text-[9px] text-[#B6D3E5] font-bold uppercase tracking-wider mb-0.5">{t.direct_phone}</p>
            <h3 className="text-sm md:text-base font-bold text-white font-mono" dir="ltr">{settings.phone}</h3>
          </div>
        </a>

        {/* WhatsApp Card */}
        <a 
          href={`https://wa.me/${settings.whatsapp?.replace(/[^0-9]/g, '')}`}
          target="_blank"
          referrerPolicy="no-referrer"
          className="glass-card p-4 rounded-xl flex items-center gap-4 border border-white/5 hover:border-green-500/30 hover:bg-[#0F1D2A]/80 transition-all cursor-pointer group text-right flex-row-reverse justify-between"
        >
          <div className="w-12 h-12 rounded-xl bg-green-500/10 flex items-center justify-center text-green-400 group-hover:scale-105 transition-transform duration-300">
            <MessageSquare size={20} />
          </div>
          <div className="flex-1">
            <p className="text-[9px] text-[#B6D3E5] font-bold uppercase tracking-wider mb-0.5">{t.doctor_whatsapp}</p>
            <h3 className="text-sm md:text-base font-bold text-white font-mono" dir="ltr">{settings.whatsapp}</h3>
          </div>
        </a>
      </div>

      {/* Working Hours Card */}
      <div className="glass-card p-5 rounded-2xl border border-white/5 space-y-4">
        <div className="flex items-center gap-2 border-r-2 border-[#00D8FF] pr-3">
          <Clock size={18} className="text-[#00D8FF]" />
          <h3 className="font-arabic-headline text-base font-bold text-white">{t.working_hours}</h3>
        </div>
        <ul className="space-y-3">
          {[
            { days_ar: 'الأحد - الخميس', days_en: 'Sunday - Thursday', hours: '09:00 - 20:00' },
            { days_ar: 'الجمعة', days_en: 'Friday', hours: '10:00 - 18:00' },
            { days_ar: 'السبت', days_en: 'Saturday', hours: t.closed, closed: true },
          ].map((item, idx) => (
            <li 
              key={idx} 
              className={`flex justify-between items-center text-xs pb-2 border-b border-white/5 font-arabic-body ${
                idx === 2 ? 'border-none pb-0' : ''
              }`}
            >
              <span className={`font-semibold font-mono ${item.closed ? 'text-[#00D8FF]' : 'text-white'}`}>{item.hours}</span>
              <span className="text-[#B6D3E5]">{lang === 'ar' ? item.days_ar : item.days_en}</span>
            </li>
          ))}
        </ul>
        <div className="pt-3 border-t border-[#00D8FF]/15">
          <p className="font-arabic-body text-[10px] text-[#00D8FF] italic font-semibold">
            {lang === 'ar' ? 'نظام حجز المواعيد متاح على مدار ٢٤ ساعة طوال الأسبوع.' : 'Appointment registration engine is active 24/7 online.'}
          </p>
        </div>
      </div>

      {/* CGI Dental jaw decorative illustration */}
      <div className="flex justify-center opacity-15 pt-2">
        <img 
          src="https://lh3.googleusercontent.com/aida-public/AB6AXuCfZw2vTS3gi5OeKNNR92rZkscTY0B9F2ZJb0ALTqKYHSPZ6Ttp1YqjCwMEAW4UckMa1R1bFyhB05EXZCB7uHc3v_tKtjrMXSxsehgCAdqyc4tgHGKqwCyHLCXKBJDw9kkHvFOvE6wwMRttAznaNuDQeQLb4NgrgVr4Nw60j9_uzGNSbtnpERg8kI0w4dMPiIuo6iXqPx0PBXbayobNLbTpAnrI5JOdt1juNsVIupEMBzPiKjNDG8WIV9n9I6P7ZM3RldZP3wS176Y" 
          alt="Translucent CGI Jaw" 
          className="max-w-[140px] object-contain drop-shadow-[0_0_10px_rgba(0,216,255,0.4)]"
        />
      </div>

      {/* Floating Action Button */}
      <div className="fixed bottom-24 left-4 z-40">
        <button 
          onClick={onBookClick}
          className="w-14 h-14 rounded-full bg-gradient-to-tr from-[#00D4FF] to-[#00A6E6] text-[#07131E] shadow-[0_0_20px_rgba(0,216,255,0.45)] hover:shadow-[0_0_25px_rgba(0,216,255,0.6)] hover:scale-105 active:scale-90 transition-all flex items-center justify-center cursor-pointer"
        >
          <Calendar size={24} />
        </button>
      </div>
    </div>
  );
}
