import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  Search, Shield, Zap, Sparkles, Clock, Activity, HelpCircle, ChevronDown, Calendar, ArrowLeft, ArrowRight 
} from 'lucide-react';
import { db } from '../lib/db';
import { Service } from '../types';
import { Language, translations } from '../utils/i18n';

interface ServicesTabProps {
  lang: Language;
  onBookClick: (serviceId: string | null) => void;
  selectedServiceId: string | null;
  clearSelectedService: () => void;
}

export default function ServicesTab({ lang, onBookClick, selectedServiceId, clearSelectedService }: ServicesTabProps) {
  const t = translations[lang];

  // States
  const [services, setServices] = useState<Service[]>([]);
  const [searchQuery, setSearchQuery] = useState('');
  const [activeAccordion, setActiveAccordion] = useState<number | null>(null);
  const [detailedService, setDetailedService] = useState<Service | null>(null);

  // Fetch Services
  useEffect(() => {
    async function loadServices() {
      const srvs = await db.getServices();
      setServices(srvs);
    }
    loadServices();
  }, []);

  // Sync selected service if navigated from home shortcuts
  useEffect(() => {
    if (selectedServiceId && services.length > 0) {
      const match = services.find(s => s.id === selectedServiceId);
      if (match) {
        setDetailedService(match);
      }
    }
  }, [selectedServiceId, services]);

  // Filtered Services
  const filteredServices = services.filter(srv => {
    const title = lang === 'ar' ? srv.title_ar : srv.title_en;
    const short = lang === 'ar' ? (srv.short_ar || '') : (srv.short_en || '');
    const query = searchQuery.toLowerCase();
    return title.toLowerCase().includes(query) || short.toLowerCase().includes(query);
  });

  const faqs = [
    {
      q_ar: 'هل عملية زراعة الأسنان مؤلمة؟',
      q_en: 'Is the dental implant procedure painful?',
      a_ar: 'بفضل تقنيات التخدير الرقمي المتقدمة والجراحة الموجهة ثلاثية الأبعاد، تكون العملية مريحة للغاية ولا تشعر بأي ألم حقيقي بل مجرد ضغط بسيط. فترة الشفاء تكون سريعة ومصحوبة بمسكنات خفيفة.',
      a_en: 'Thanks to state-of-the-art computer-guided surgery and advanced local anesthesia, the procedure is virtually painless with only minor pressure. Healing is exceptionally fast with light analgesics.'
    },
    {
      q_ar: 'كم تدوم زرعات وفينير الأسنان؟',
      q_en: 'How long do dental implants and veneers last?',
      a_ar: 'زرعات التيتانيوم مصممة للاندماج العضوي مع الفك وتدوم مدى الحياة مع العناية الممتازة وصحة الفم الجيدة. الفينير الفاخر يدوم ما بين 10 إلى 15 عاماً ويحافظ على بياضه الناصع.',
      a_en: 'Titanium implants are structurally engineered to fuse with bone and last a lifetime with sound oral hygiene. Premium veneers usually last 10-15 years without losing their high-gloss stain resistance.'
    },
    {
      q_ar: 'هل توجد خطط تمويل للمبالغ الكبيرة؟',
      q_en: 'Are there flexible financing plans for treatment?',
      a_ar: 'نعم، نحن نوفر خطط تمويل وتقسيط مرنة ومريحة بدون فوائد لضمان حصولك على أعلى جودة علاجية وطبية دون أية أعباء مالية.',
      a_en: 'Yes, we facilitate customized zero-interest payment installments and flexible financing packages to make premium clinical treatments absolutely accessible.'
    }
  ];

  const toggleAccordion = (idx: number) => {
    setActiveAccordion(activeAccordion === idx ? null : idx);
  };

  // If detailed view of service is selected (as shown in Screenshot 3: Digital Dental Implants)
  if (detailedService) {
    const isImplant = detailedService.id === 's1-implants';
    return (
      <motion.div 
        initial={{ opacity: 0, x: lang === 'ar' ? -30 : 30 }}
        animate={{ opacity: 1, x: 0 }}
        className="space-y-6 pb-14"
      >
        {/* Back Button Header */}
        <div className="flex items-center gap-3">
          <button 
            onClick={() => {
              setDetailedService(null);
              clearSelectedService();
            }}
            className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center text-primary hover:bg-white/10 active:scale-95 transition-all cursor-pointer"
          >
            {lang === 'ar' ? <ArrowRight size={20} /> : <ArrowLeft size={20} />}
          </button>
          <span className="text-sm font-bold text-outline">{t.back}</span>
        </div>

        {/* Detailed Hero Screen (Holographic Scan look-and-feel) */}
        <section className="relative">
          <div className="relative w-full aspect-square bg-[#0F1D2A]/80 border border-[#00D8FF]/10 rounded-2xl overflow-hidden flex flex-col items-center justify-center p-6">
            {/* HUD scanline effect */}
            <div className="absolute top-0 left-0 w-full h-[2px] bg-gradient-to-r from-transparent via-[#00D8FF]/70 to-transparent shadow-[0_0_8px_rgba(0,216,255,0.8)] animate-[scan_3s_linear_infinite] z-10"></div>
            
            <motion.div 
              animate={{ y: [0, -8, 0] }}
              transition={{ duration: 5, repeat: Infinity, ease: 'easeInOut' }}
              className="w-4/5 h-4/5 flex items-center justify-center"
            >
              <img 
                src={detailedService.image_url || 'https://lh3.googleusercontent.com/aida-public/AB6AXuA8IhJhiFXgCJoUCUhdnc489Z5-t5f73w8_vrm1xpYXedmkJ03q-koJmRfbOUzS_KQB0wsM6NaXDIHtJwV0K5zDDPGeUiBqxJ1vahCOg4L_EOFtulSHKST682LV0CZ5esHQYRSk_GGGGfRSBitnzecYBWkSCsJoqy8_nsg06W7xEsAhpHHHrHBwqXslITJ85aSDIxTyNuG8ThD74NSybCASpY9V3MVWaet_3GWL3yhamaVQj4dbDGJVwpsxnrt-nByMJbCOw2YSxps'} 
                alt={detailedService.title_en}
                className="w-full h-full object-contain filter drop-shadow-[0_0_25px_rgba(0,216,255,0.5)]"
              />
            </motion.div>

            <div className="text-center mt-2 z-10">
              <h2 className="font-arabic-headline font-bold text-xl text-white">
                {lang === 'ar' ? detailedService.title_ar : detailedService.title_en}
              </h2>
              <p className="font-mono text-[10px] text-[#00D8FF] tracking-widest uppercase mt-1">
                {lang === 'ar' ? 'علاج تجميلي رقمي متقدم' : 'Advanced Digital Therapy'}
              </p>
            </div>
          </div>
        </section>

        {/* Bento Grid Benefits (screenshot 3) */}
        <section className="space-y-4">
          <h3 className="font-arabic-headline text-lg text-white border-r-4 border-[#00D8FF] pr-3 flex items-center gap-2">
            <Activity size={18} className="text-[#00D8FF]" />
            {t.benefits_title}
          </h3>
          <div className="grid grid-cols-2 gap-3">
            <div className="glass-card p-4 rounded-xl flex flex-col gap-2 border border-white/5">
              <Shield className="text-[#00D8FF]" size={28} />
              <h4 className="font-bold text-white text-sm">
                {lang === 'ar' ? 'دقة متناهية' : 'Absolute Precision'}
              </h4>
              <p className="text-[11px] text-[#B6D3E5] leading-relaxed">
                {lang === 'ar' ? 'استخدام المسح ثلاثي الأبعاد لضمان التوافق التام مع عظام الفك.' : '3D CAD-CAM modeling matches target structures with micrometric accuracy.'}
              </p>
            </div>
            <div className="glass-card p-4 rounded-xl flex flex-col gap-2 border border-white/5">
              <Zap className="text-[#00D8FF]" size={28} />
              <h4 className="font-bold text-white text-sm">
                {lang === 'ar' ? 'سرعة التنفيذ' : 'Rapid Execution'}
              </h4>
              <p className="text-[11px] text-[#B6D3E5] leading-relaxed">
                {lang === 'ar' ? 'تقنيات حديثة تقلل من عدد الزيارات وفترات الانتظار الطويلة.' : 'AI fabrication trims dental waiting intervals and eliminates redundant steps.'}
              </p>
            </div>
            <div className="col-span-2 glass-card p-4 rounded-xl flex items-center gap-4 border border-white/5">
              <div className="w-12 h-12 rounded-lg bg-[#00D8FF]/10 flex items-center justify-center text-[#00D8FF] shrink-0">
                <Sparkles size={24} />
              </div>
              <div>
                <h4 className="font-bold text-white text-sm">
                  {lang === 'ar' ? 'نتائج طبيعية دائمة' : 'Natural Lifelong Glow'}
                </h4>
                <p className="text-[11px] text-[#B6D3E5] leading-relaxed">
                  {lang === 'ar' 
                    ? 'زرعات تيتانيوم حيوية تندمج مع العظم لتدوم مدى الحياة بمظهر طبيعي 100%.' 
                    : 'Bio-engineered titanium and premium porcelain deliver a natural smile engineered for life.'}
                </p>
              </div>
            </div>
          </div>
        </section>

        {/* Detailed Timeline Treatment Schedule (screenshot 3) */}
        <section className="glass-card p-5 rounded-2xl border border-white/5 space-y-4">
          <h3 className="font-arabic-headline text-lg text-white flex items-center gap-2">
            <Clock size={18} className="text-[#00D8FF]" />
            {t.timeline_title}
          </h3>
          <div className="relative border-r border-[#00D8FF]/20 pr-6 space-y-6 text-right">
            <div className="relative">
              <div className="absolute -right-[29px] top-1 w-3.5 h-3.5 rounded-full bg-[#00D8FF] shadow-[0_0_8px_rgba(0,216,255,0.8)]"></div>
              <h4 className="font-bold text-white text-xs">
                {lang === 'ar' ? 'التشخيص الرقمي (يوم 1)' : 'Digital Consultation (Day 1)'}
              </h4>
              <p className="text-[11px] text-[#B6D3E5] mt-1 leading-relaxed">
                {lang === 'ar' 
                  ? 'مسح مقطعي CT كامل وتصميم الخطة الجراحية والابتسامة عبر برمجيات الذكاء الاصطناعي.' 
                  : 'High-res volumetric CT scanning and visual smile blueprints powered by clinical AI engines.'}
              </p>
            </div>
            <div className="relative">
              <div className="absolute -right-[29px] top-1 w-3.5 h-3.5 rounded-full bg-[#07131E] border-2 border-[#00D8FF]"></div>
              <h4 className="font-bold text-white text-xs">
                {lang === 'ar' ? 'تركيب الزرعة / القالب (أسبوع 1-2)' : 'Placement & Preparation (Week 1-2)'}
              </h4>
              <p className="text-[11px] text-[#B6D3E5] mt-1 leading-relaxed">
                {lang === 'ar' 
                  ? 'إجراء جراحي طفيف التوغل وموجه بالحاسوب لوضع الغرسات أو تحضير الأسنان تحت التخدير الرقمي.' 
                  : 'Computer-guided minimal micro-surgery to seamlessly place hardware or prepare premium surfaces.'}
              </p>
            </div>
            <div className="relative">
              <div className="absolute -right-[29px] top-1 w-3.5 h-3.5 rounded-full bg-[#07131E] border-2 border-[#00D8FF]/30"></div>
              <h4 className="font-bold text-white text-xs">
                {lang === 'ar' ? 'التعافي النهائي والتثبيت (شهر 3)' : 'Final Delivery & Bond (Month 3)'}
              </h4>
              <p className="text-[11px] text-[#B6D3E5] mt-1 leading-relaxed">
                {lang === 'ar' 
                  ? 'دمج التاج الدائم أو الفينير المصنوع من الزركونيا والبورسلين عالي الجودة.' 
                  : 'Complete fusion tracking and bonding of final porcelain zirconia crowns for maximum durability.'}
              </p>
            </div>
          </div>
        </section>

        {/* Detailed Description */}
        <section className="glass-card p-5 rounded-2xl border border-white/5 space-y-2">
          <h3 className="font-arabic-headline text-sm text-[#B6D3E5]">{lang === 'ar' ? 'نبذة عن الخدمة' : 'Service Overview'}</h3>
          <p className="text-xs text-[#B6D3E5] leading-relaxed text-justify">
            {lang === 'ar' ? detailedService.details_ar : detailedService.details_en}
          </p>
        </section>

        {/* FAQs */}
        <section className="space-y-4">
          <h3 className="font-arabic-headline text-lg text-white flex items-center gap-2">
            <HelpCircle size={18} className="text-[#00D8FF]" />
            {t.faq_title}
          </h3>
          <div className="space-y-3">
            {faqs.map((faq, idx) => {
              const isActive = activeAccordion === idx;
              return (
                <div key={idx} className="glass-card rounded-xl overflow-hidden border border-white/5">
                  <button 
                    onClick={() => toggleAccordion(idx)}
                    className="w-full p-4 flex justify-between items-center text-right hover:bg-white/5 transition-colors cursor-pointer"
                  >
                    <span className="font-bold text-xs text-white">
                      {lang === 'ar' ? faq.q_ar : faq.q_en}
                    </span>
                    <ChevronDown size={16} className={`text-outline transition-transform duration-300 ${isActive ? 'rotate-180' : ''}`} />
                  </button>
                  <AnimatePresence>
                    {isActive && (
                      <motion.div 
                        initial={{ height: 0, opacity: 0 }}
                        animate={{ height: 'auto', opacity: 1 }}
                        exit={{ height: 0, opacity: 0 }}
                        className="overflow-hidden"
                      >
                        <div className="p-4 pt-0 text-[11px] text-outline leading-relaxed">
                          {lang === 'ar' ? faq.a_ar : faq.a_en}
                        </div>
                      </motion.div>
                    )}
                  </AnimatePresence>
                </div>
              );
            })}
          </div>
        </section>

        {/* Sticky Call to Action */}
        <div className="pt-4">
          <button 
            onClick={() => onBookClick(detailedService.id)}
            className="w-full h-14 bg-gradient-to-r from-[#00D4FF] to-[#00A6E6] text-[#07131E] font-bold text-sm tracking-wide shadow-[0_0_20px_rgba(0,216,255,0.4)] active:scale-95 transition-all flex items-center justify-center gap-2 cursor-pointer"
          >
            <Calendar size={18} />
            <span>{t.book_now}</span>
          </button>
        </div>
      </motion.div>
    );
  }

  // Standard Services Listing View (as shown in Screenshot 5: Services)
  return (
    <div className="space-y-6 pb-12">
      {/* Search Bar */}
      <div className="space-y-4">
        <h2 className="font-arabic-headline text-2xl text-white font-bold drop-shadow-[0_0_10px_rgba(0,216,255,0.3)]">
          {t.our_services}
        </h2>
        <div className="relative group">
          <input 
            type="text" 
            placeholder={t.search_placeholder}
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full h-14 bg-[#0F1D2A]/80 border border-[#00D8FF]/25 rounded-xl pr-12 pl-4 focus:ring-1 focus:ring-[#00D8FF]/30 focus:border-[#00D8FF] transition-all text-white placeholder-[#B6D3E5]/60 text-sm outline-none font-arabic-body"
          />
          <Search size={18} className="absolute right-4 top-1/2 -translate-y-1/2 text-[#B6D3E5]" />
        </div>
      </div>

      {/* Grid of services */}
      <div className="grid grid-cols-1 gap-3">
        {filteredServices.map((srv) => {
          const isAr = lang === 'ar';
          return (
            <motion.div 
              key={srv.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              onClick={() => setDetailedService(srv)}
              className="glass-card p-4 rounded-xl relative overflow-hidden group cursor-pointer border border-[#00D8FF]/10 hover:border-[#00D8FF]/40 hover:bg-[#00D8FF]/5 transition-all flex items-center justify-between gap-4 h-20"
            >
              {/* Outer light glow beam inside card */}
              <div className="absolute inset-y-0 left-0 w-[3px] bg-gradient-to-b from-[#00D8FF] to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
              
              <div className={`flex items-center gap-4 flex-1 ${isAr ? 'flex-row-reverse' : 'flex-row'}`}>
                {/* Icon Graphic Container */}
                <div className="w-12 h-12 rounded-xl bg-[#0F1D2A] flex items-center justify-center p-2 shrink-0 border border-[#00D8FF]/20 shadow-[0_0_10px_rgba(0,216,255,0.1)]">
                  <img 
                    src={srv.image_url || 'https://lh3.googleusercontent.com/aida-public/AB6AXuCfZw2vTS3gi5OeKNNR92rZkscTY0B9F2ZJb0ALTqKYHSPZ6Ttp1YqjCwMEAW4UckMa1R1bFyhB05EXZCB7uHc3v_tKtjrMXSxsehgCAdqyc4tgHGKqwCyHLCXKBJDw9kkHvFOvE6wwMRttAznaNuDQeQLb4NgrgVr4Nw60j9_uzGNSbtnpERg8kI0w4dMPiIuo6iXqPx0PBXbayobNLbTpAnrI5JOdt1juNsVIupEMBzPiKjNDG8WIV9n9I6P7ZM3RldZP3wS176Y'} 
                    alt={srv.title_en}
                    className="w-full h-full object-contain filter drop-shadow-[0_0_6px_rgba(20,216,255,0.4)] group-hover:scale-110 transition-transform duration-300"
                  />
                </div>

                {/* Text Content */}
                <div className={`flex-1 ${isAr ? 'text-right' : 'text-left'}`}>
                  <h3 className="font-arabic-headline text-sm font-bold text-white group-hover:text-white transition-colors leading-tight">
                    {lang === 'ar' ? srv.title_ar : srv.title_en}
                  </h3>
                  <p className="text-[10px] text-[#B6D3E5] mt-1 line-clamp-1">
                    {lang === 'ar' ? srv.short_ar : srv.short_en}
                  </p>
                </div>
              </div>

              {/* Cyan Navigation Arrow */}
              <div className="text-[#00D8FF] opacity-80 group-hover:opacity-100 transition-all transform group-hover:translate-x-1 shrink-0">
                {isAr ? (
                  <ArrowLeft size={16} className="text-[#00D8FF]" />
                ) : (
                  <ArrowRight size={16} className="text-[#00D8FF]" />
                )}
              </div>
            </motion.div>
          );
        })}

        {filteredServices.length === 0 && (
          <div className="text-center py-10 space-y-2">
            <p className="text-outline text-sm">
              {lang === 'ar' ? 'لم نجد أي خدمة تطابق بحثك.' : 'No services matches your search.'}
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
