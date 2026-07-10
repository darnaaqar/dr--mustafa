import React from 'react';
import { motion } from 'motion/react';
import { ShieldCheck, Star, Calendar, ArrowLeft } from 'lucide-react';
import { Language, translations } from '../utils/i18n';

interface HomeTabProps {
  lang: Language;
  onBookClick: () => void;
  onNavigateToTab: (tab: string) => void;
  onNavigateToService: (serviceId: string) => void;
}

export default function HomeTab({ lang, onBookClick, onNavigateToTab, onNavigateToService }: HomeTabProps) {
  const t = translations[lang];

  return (
    <div className="space-y-8 pb-10">
      {/* Hero Header Section */}
      <section className="text-center space-y-2 mt-4">
        <motion.h1 
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
          className="font-arabic-headline text-3xl md:text-4xl text-white font-bold drop-shadow-[0_0_12px_rgba(0,216,255,0.4)]"
        >
          {lang === 'ar' ? 'د. مصطفى الرفاعي' : 'Dr. Mustafa Al-Rifai'}
        </motion.h1>
        <p className="font-label-sm text-xs text-[#00D8FF] uppercase tracking-[0.15em] font-semibold">
          {lang === 'ar' ? 'طب وتجميل الأسنان' : 'Dental Care & Aesthetics'}
        </p>
        <div className="flex items-center justify-center gap-4 text-outline text-xs mt-2">
          <span className="w-8 h-[1px] bg-[#00D8FF]/20"></span>
          <span className="font-mono text-[10px] tracking-widest text-[#B6D3E5] uppercase">Clinical Excellence</span>
          <span className="w-8 h-[1px] bg-[#00D8FF]/20"></span>
        </div>
      </section>

      {/* Holographic 3D Tooth Hero Area */}
      <section className="relative h-80 flex items-center justify-center">
        {/* HUD Base Background Ring */}
        <div className="absolute inset-0 flex items-center justify-center">
          <img 
            alt="HUD Rings" 
            className="w-72 h-72 opacity-35 animate-[spin_20s_linear_infinite]" 
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuDh4lb4p54bnmUtkV_mfM7kl1ekflE8O7EThW8Jtx7JY4FX7Agi2SIV_d97GJRtwR0unjCwvpWE7oZCXPmez50-j_UY2ndV71pfXPxndDJgxnGIRsCU-gAEuNK3iKNARZO-TWctfaviPcZfAs-qNEcrBzN2Ke2K12TAz8wA2DzsPZwA-ux9zK_GXpznrB_P9vLP8vIYafXbjexhpWCULunwg_M3I-qRw7n9SgsA71pQMdqs6ALdigSAkM3YsXz7MSsJEjUCjnf_zH0"
          />
        </div>

        {/* Main Tooth Hologram Floating */}
        <motion.div 
          animate={{ y: [0, -10, 0] }}
          transition={{ duration: 4, repeat: Infinity, ease: 'easeInOut' }}
          className="relative z-10 cursor-pointer rounded-full p-8 border-2 border-[#00D8FF]/30 bg-gradient-to-b from-[#00D8FF]/15 to-transparent shadow-[0_0_40px_rgba(0,216,255,0.3)] flex items-center justify-center w-56 h-56 mx-auto"
          onClick={onBookClick}
        >
          <img 
            alt="3D Holographic Tooth" 
            className="w-40 h-40 object-contain drop-shadow-[0_0_20px_rgba(0,216,255,0.65)] hover:scale-110 transition-transform duration-500 rounded-full" 
            src="https://lh3.googleusercontent.com/aida-public/AB6AXuA8IhJhiFXgCJoUCUhdnc489Z5-t5f73w8_vrm1xpYXedmkJ03q-koJmRfbOUzS_KQB0wsM6NaXDIHtJwV0K5zDDPGeUiBqxJ1vahCOg4L_EOFtulSHKST682LV0CZ5esHQYRSk_GGGGfRSBitnzecYBWkSCsJoqy8_nsg06W7xEsAhpHHHrHBwqXslITJ85aSDIxTyNuG8ThD74NSybCASpY9V3MVWaet_3GWL3yhamaVQj4dbDGJVwpsxnrt-nByMJbCOw2YSxps"
          />
        </motion.div>

        {/* Floating Micro Diagnostic Elements */}
        <div className="absolute inset-0 pointer-events-none">
          <motion.div 
            animate={{ y: [0, -6, 0] }}
            transition={{ duration: 3.5, repeat: Infinity, ease: 'easeInOut', delay: 0.5 }}
            className="absolute top-[10%] left-[12%] w-11 h-11 glass-card rounded-full p-2 flex items-center justify-center border border-[#00D8FF]/30 shadow-[0_0_12px_rgba(0,216,255,0.2)]"
          >
            <img alt="Whitening" className="w-7 h-7 object-contain" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAi9-BHBZ4IqwyAd1uzPjXKCBxEjyoslolcDuhaLmAEFRolltwxKs0eop7Dh0igVbizUXHxD5dU6GqjHw9Tux5qjHXj3f4pU0Cv9J0QbTgGoanij-LVCQ15YlNAb0bmUvcwLPYAj-teiulmr7ybT5F0DHKWJP2xzHLWwc7sSbVysKWvsH1xeTztkb4XNTmZVpgf9HtoY8B5tiz3r4pF5g_R6SNTNQjbO-2OQUqihKqOBHtt4bY0-RV1Id7umWNwlUAbHpmfeQxwGVw" />
          </motion.div>

          <motion.div 
            animate={{ y: [0, -8, 0] }}
            transition={{ duration: 4.5, repeat: Infinity, ease: 'easeInOut', delay: 1 }}
            className="absolute top-[8%] right-[12%] w-11 h-11 glass-card rounded-full p-2 flex items-center justify-center border border-[#00D8FF]/30 shadow-[0_0_12px_rgba(0,216,255,0.2)]"
          >
            <img alt="Braces" className="w-7 h-7 object-contain" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCIgQybrBw0jdVNJ2TtHXLMeA1YXxaCPaqfDfnXZAOl2WDW6IHxebg5on9BOOjfcY6P5Qb8ERySp-p25DLvdBhmgknzTaqhvBtjlR2_0_CMie_SuHBQhYHflTV4sNaPnUVVrnmPvOgeO6BXkTrpKw9PYEVyQ1CO3wqKfdqZZnR5bqUOgXT2W6MVqxJMtRAGVGFNwh-497AHrUdc35ALEDADbCDPw8XO_ZBhk5gHVI5wJYL1Ob2mjg7OarEQRKNlSzE0AFRuHi0k9uU" />
          </motion.div>

          <motion.div 
            animate={{ y: [0, -7, 0] }}
            transition={{ duration: 3.8, repeat: Infinity, ease: 'easeInOut', delay: 1.5 }}
            className="absolute bottom-[18%] left-[8%] w-11 h-11 glass-card rounded-full p-2 flex items-center justify-center border border-[#00D8FF]/30 shadow-[0_0_12px_rgba(0,216,255,0.2)]"
          >
            <img alt="Implant" className="w-7 h-7 object-contain" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBhtLCH5V1iI3UNnmz87HzHIcAqOvok_QMg_nxXVCaxQglBLUuV_FDyekcJG9j7T_dgsEZ7v9GVGD30tK90YwFN0IQxZTiby6eq7wlQVsYhYmgC0hlFB6YAU27cIoXqBc7OR9fDlXQP7ebskdzO2OLNUoIbOjKiDUZLwP7Kw25veXcWNJuirar5R47fahSvD_XG8fDMu_T8hg7iYumozUyi8122oJhs9QyFoQGQA4r21a0Td-eg79MTcaVeJMD-IHez2BDb9vmTLtc" />
          </motion.div>

          <motion.div 
            animate={{ y: [0, -9, 0] }}
            transition={{ duration: 4.2, repeat: Infinity, ease: 'easeInOut', delay: 2 }}
            className="absolute bottom-[22%] right-[8%] w-11 h-11 glass-card rounded-full p-2 flex items-center justify-center border border-[#00D8FF]/30 shadow-[0_0_12px_rgba(0,216,255,0.2)]"
          >
            <img alt="Veneers" className="w-7 h-7 object-contain" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBXPbsArznlWc7wjwK_KEpnD-ZD2Hz0PH9lYs-kdUg23s9csaR_aFxXxXafvaE2yjLQXqVMqLs7fSMaWHoXFJIikwrZFEpfNXlk18KzfAbgnDGjjHSvljxEja-o6kSZl9Yre8TbBxMc9kjGOoA3ZjkLGINoe0Vt6FF1lNNSh8Mu3egc6LtSN6SIMydmpTihz9GSJe5CNH10uJ2yX4mgqujmvE8ohYHHVoK2Na-aDfHkGcyG6mE7eUjqjbkMv0WNeaMeS97HDm__k6s" />
          </motion.div>
        </div>

        {/* Glow Floor */}
        <div className="absolute bottom-6 w-48 h-4 bg-[#00D8FF]/15 blur-xl rounded-full"></div>
      </section>

      {/* Slogan Statement */}
      <section className="text-center space-y-1 py-1">
        <p className="font-arabic-headline text-lg font-bold text-white drop-shadow-[0_0_8px_rgba(255,255,255,0.1)]">
          {t.slogan}
        </p>
      </section>

      {/* Bento Grid Service Link Shortcuts */}
      <section className="grid grid-cols-4 gap-3">
        {[
          { 
            id: 's3-whitening',
            label_ar: 'تبييض الأسنان', 
            label_en: 'Whitening',
            img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAi9-BHBZ4IqwyAd1uzPjXKCBxEjyoslolcDuhaLmAEFRolltwxKs0eop7Dh0igVbizUXHxD5dU6GqjHw9Tux5qjHXj3f4pU0Cv9J0QbTgGoanij-LVCQ15YlNAb0bmUvcwLPYAj-teiulmr7ybT5F0DHKWJP2xzHLWwc7sSbVysKWvsH1xeTztkb4XNTmZVpgf9HtoY8B5tiz3r4pF5g_R6SNTNQjbO-2OQUqihKqOBHtt4bY0-RV1Id7umWNwlUAbHpmfeQxwGVw'
          },
          { 
            id: 's2-veneers',
            label_ar: 'الفينير', 
            label_en: 'Veneers',
            img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBXPbsArznlWc7wjwK_KEpnD-ZD2Hz0PH9lYs-kdUg23s9csaR_aFxXxXafvaE2yjLQXqVMqLs7fSMaWHoXFJIikwrZFEpfNXlk18KzfAbgnDGjjHSvljxEja-o6kSZl9Yre8TbBxMc9kjGOoA3ZjkLGINoe0Vt6FF1lNNSh8Mu3egc6LtSN6SIMydmpTihz9GSJe5CNH10uJ2yX4mgqujmvE8ohYHHVoK2Na-aDfHkGcyG6mE7eUjqjbkMv0WNeaMeS97HDm__k6s'
          },
          { 
            id: 's1-implants',
            label_ar: 'زراعة الأسنان', 
            label_en: 'Implants',
            img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBhtLCH5V1iI3UNnmz87HzHIcAqOvok_QMg_nxXVCaxQglBLUuV_FDyekcJG9j7T_dgsEZ7v9GVGD30tK90YwFN0IQxZTiby6eq7wlQVsYhYmgC0hlFB6YAU27cIoXqBc7OR9fDlXQP7ebskdzO2OLNUoIbOjKiDUZLwP7Kw25veXcWNJuirar5R47fahSvD_XG8fDMu_T8hg7iYumozUyi8122oJhs9QyFoQGQA4r21a0Td-eg79MTcaVeJMD-IHez2BDb9vmTLtc'
          },
          { 
            id: 's4-ortho',
            label_ar: 'تقويم الأسنان', 
            label_en: 'Orthodontics',
            img: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCIgQybrBw0jdVNJ2TtHXLMeA1YXxaCPaqfDfnXZAOl2WDW6IHxebg5on9BOOjfcY6P5Qb8ERySp-p25DLvdBhmgknzTaqhvBtjlR2_0_CMie_SuHBQhYHflTV4sNaPnUVVrnmPvOgeO6BXkTrpKw9PYEVyQ1CO3wqKfdqZZnR5bqUOgXT2W6MVqxJMtRAGVGFNwh-497AHrUdc35ALEDADbCDPw8XO_ZBhk5gHVI5wJYL1Ob2mjg7OarEQRKNlSzE0AFRuHi0k9uU'
          },
        ].map((item) => (
          <div 
            key={item.id}
            onClick={() => onNavigateToService(item.id)}
            className="glass-card rounded-xl p-3 flex flex-col items-center gap-2 border border-[#00D8FF]/10 hover:border-[#00D8FF]/40 transition-all cursor-pointer active:scale-95 text-center"
          >
            <img alt={item.label_en} className="w-10 h-10 object-contain drop-shadow-[0_0_6px_rgba(0,216,255,0.4)]" src={item.img} />
            <span className="text-[9px] font-bold text-white block leading-tight">
              {lang === 'ar' ? item.label_ar : item.label_en}
            </span>
          </div>
        ))}
      </section>

      {/* Primary CTA Booking Button */}
      <section className="space-y-4">
        <button 
          onClick={onBookClick}
          className="w-full h-16 bg-gradient-to-r from-[#00D4FF] to-[#00A6E6] rounded-2xl flex items-center justify-between px-6 shadow-[0_0_20px_rgba(0,216,255,0.4)] hover:shadow-[0_0_25px_rgba(0,216,255,0.5)] active:scale-[0.98] transition-all relative overflow-hidden group cursor-pointer"
        >
          <div className="absolute inset-0 bg-white/10 opacity-0 group-hover:opacity-100 transition-opacity"></div>
          <div className="flex items-center gap-4 relative z-10">
            <div className="w-10 h-10 bg-white/20 rounded-xl flex items-center justify-center text-white">
              <Calendar size={20} />
            </div>
            <div className="text-right">
              <p className="font-arabic-headline text-sm font-bold text-[#07131E] leading-tight">{t.book_now}</p>
              <p className="font-mono text-[9px] text-[#07131E]/80 uppercase tracking-widest mt-0.5">Book Your Appointment</p>
            </div>
          </div>
          <ArrowLeft size={18} className={`text-[#07131E] transition-transform ${lang === 'ar' ? 'hover:translate-x-[-4px]' : 'rotate-180 hover:translate-x-[4px]'}`} />
        </button>

        {/* Centered Premium Footer matching the uploaded design */}
        <div className="flex flex-col items-center justify-center py-6 mt-4 gap-1 border-t border-white/5">
          <div className="flex items-center gap-2 text-white justify-center">
            <span className="text-[#00D8FF] text-xs">✦</span>
            <span className="text-white text-base">🛡️</span>
            <span className="font-arabic-headline font-bold text-sm text-white tracking-wide">
              {lang === 'ar' ? 'نهتم بابتسامتك' : 'We care about your smile'}
            </span>
            <span className="text-[#00D8FF] text-xs">✦</span>
          </div>
          <p className="text-xs text-[#B6D3E5]/60 font-sans tracking-wide text-center">
            We care about your smile
          </p>
        </div>
      </section>
    </div>
  );
}
