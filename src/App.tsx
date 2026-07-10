import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  Home, Stethoscope, LayoutGrid, User, Phone, Bell, Calendar, Globe, Menu, X 
} from 'lucide-react';
import { Language, translations } from './utils/i18n';
import { db } from './lib/db';
import HomeTab from './components/HomeTab';
import ServicesTab from './components/ServicesTab';
import GalleryTab from './components/GalleryTab';
import AboutTab from './components/AboutTab';
import ContactTab from './components/ContactTab';
import AppointmentsTab from './components/AppointmentsTab';
import BookingWizard from './components/BookingWizard';

export default function App() {
  // Application Language & Tab States
  const [lang, setLang] = useState<Language>('ar');
  const [currentTab, setCurrentTab] = useState<string>('home');
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  
  // Booking Wizard states
  const [isBookingOpen, setIsBookingOpen] = useState(false);
  const [selectedServiceId, setSelectedServiceId] = useState<string | null>(null);
  const [bookingTriggerCount, setBookingTriggerCount] = useState(0); // to reload appointments tab list on new booking

  // Scroll to top when changing tab
  useEffect(() => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }, [currentTab]);

  const t = translations[lang];

  // Handler functions
  const handleLanguageChange = (newLang: Language) => {
    setLang(newLang);
    // Apply appropriate text direction
    if (newLang === 'ar') {
      document.documentElement.setAttribute('dir', 'rtl');
      document.documentElement.setAttribute('lang', 'ar');
    } else {
      document.documentElement.setAttribute('dir', 'ltr');
      document.documentElement.setAttribute('lang', 'en');
    }
  };

  // On App startup, set default direction (Arabic - RTL)
  useEffect(() => {
    handleLanguageChange('ar');
  }, []);

  const handleBookClick = (serviceId: string | null = null) => {
    setSelectedServiceId(serviceId);
    setIsBookingOpen(true);
  };

  const handleBookingSuccess = () => {
    setBookingSuccessCount(prev => prev + 1);
  };

  const [bookingSuccessCount, setBookingSuccessCount] = useState(0);

  const navigateToServiceDetail = (serviceId: string) => {
    setSelectedServiceId(serviceId);
    setCurrentTab('services');
  };

  return (
    <div className="min-h-screen bg-[#07131E] text-[#dde4e6] font-sans relative overflow-x-hidden pb-10">
      {/* Background Atmospheric Bioluminescent Glow */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 w-[500px] h-[500px] bg-[#00D8FF]/5 blur-[120px] rounded-full pointer-events-none -z-10"></div>
      <div className="absolute bottom-10 left-10 w-[300px] h-[300px] bg-[#00D8FF]/5 blur-[100px] rounded-full pointer-events-none -z-10"></div>

      {/* Top App Bar (Screenshot 4) */}
      <header className="fixed top-0 w-full z-40 bg-[#07131E]/80 backdrop-blur-xl border-b border-white/10 h-16 flex justify-between items-center px-5 max-w-lg mx-auto left-0 right-0">
        <div className="flex items-center gap-3">
          <button 
            onClick={() => setIsMenuOpen(true)}
            className="text-[#00D8FF] hover:opacity-80 transition-opacity active:scale-95 cursor-pointer"
          >
            <Menu size={22} />
          </button>
          <div className="flex items-center gap-2">
            <img 
              alt="Dental AI Clinic Logo" 
              className="w-8 h-8 drop-shadow-[0_0_8px_rgba(0,216,255,0.6)] object-contain" 
              src="https://lh3.googleusercontent.com/aida/AP1WRLvgpJuNbz7ZGBSUud_zbYaRxgvpRkXubIr9UDnaFKaCeDZH5fWaQtfNJE9WRNmtOJeAjeGXfGK_iajc4akHDTJjiyZC5ATTuYC--1l7gOgaq35HTTNE0KiTX9vlW-WthJ87N_OAxlXAR7grSPmEisQhtU6Obp9FNyv6SKR4dad81sTNF8-0sKgWccdIiq9J9hI1HejVCC00DAP7ioDxnnWCGgNdmwyD2-MDvhpZyedHKIUXyzjdGJGNT7I"
            />
            <span className="font-headline-lg-mobile text-lg font-extrabold tracking-tighter text-[#00D8FF] drop-shadow-[0_0_8px_rgba(0,216,255,0.5)]">
              DENTAL AI
            </span>
          </div>
        </div>

        {/* Bilingual language toggle (capsule pill button) */}
        <div className="flex bg-[#0F1D2A] rounded-full p-0.5 border border-[#00D8FF]/15 shadow-inner">
          <button 
            onClick={() => handleLanguageChange('ar')}
            className={`px-3 py-1 rounded-full text-[10px] font-bold transition-all cursor-pointer ${
              lang === 'ar' 
                ? 'bg-[#00D8FF] text-[#07131E] shadow-[0_0_8px_rgba(0,216,255,0.4)]' 
                : 'text-[#B6D3E5]'
            }`}
          >
            عربي
          </button>
          <button 
            onClick={() => handleLanguageChange('en')}
            className={`px-3 py-1 rounded-full text-[10px] font-bold transition-all cursor-pointer ${
              lang === 'en' 
                ? 'bg-[#00D8FF] text-[#07131E] shadow-[0_0_8px_rgba(0,216,255,0.4)]' 
                : 'text-[#B6D3E5]'
            }`}
          >
            English
          </button>
        </div>
      </header>

      {/* Main Content Area Container */}
      <main className="pt-20 px-5 max-w-lg mx-auto min-h-[calc(100vh-140px)] flex flex-col justify-start">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentTab}
            initial={{ opacity: 0, y: 15 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -15 }}
            transition={{ duration: 0.25 }}
            className="flex-1 w-full"
          >
            {currentTab === 'home' && (
              <HomeTab 
                lang={lang} 
                onBookClick={() => handleBookClick(null)}
                onNavigateToTab={setCurrentTab}
                onNavigateToService={navigateToServiceDetail}
              />
            )}
            {currentTab === 'services' && (
              <ServicesTab 
                lang={lang} 
                onBookClick={handleBookClick}
                selectedServiceId={selectedServiceId}
                clearSelectedService={() => setSelectedServiceId(null)}
              />
            )}
            {currentTab === 'gallery' && (
              <GalleryTab 
                lang={lang} 
                onBookClick={() => handleBookClick(null)}
              />
            )}
            {currentTab === 'about' && (
              <AboutTab 
                lang={lang} 
                onBookClick={() => handleBookClick(null)}
              />
            )}
            {currentTab === 'contact' && (
              <ContactTab 
                lang={lang} 
                onBookClick={() => handleBookClick(null)}
              />
            )}
            {currentTab === 'appointments' && (
              <AppointmentsTab 
                lang={lang} 
                onBookClick={() => handleBookClick(null)}
                bookingTriggerCount={bookingSuccessCount}
              />
            )}
          </motion.div>
        </AnimatePresence>
      </main>

      {/* Sidebar Drawer Navigation (The list in the header is filled and fully animated) */}
      <AnimatePresence>
        {isMenuOpen && (
          <>
            {/* Backdrop Overlay */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setIsMenuOpen(false)}
              className="fixed inset-0 bg-black/70 backdrop-blur-md z-50 max-w-lg mx-auto left-0 right-0"
            />
            {/* Drawer Sliding Side Panel */}
            <motion.div
              initial={{ x: lang === 'ar' ? '100%' : '-100%' }}
              animate={{ x: 0 }}
              exit={{ x: lang === 'ar' ? '100%' : '-100%' }}
              transition={{ type: 'spring', damping: 25, stiffness: 220 }}
              className={`fixed top-0 bottom-0 ${
                lang === 'ar' ? 'right-0 border-l' : 'left-0 border-r'
              } w-[280px] h-full bg-[#07131E] border-white/10 z-50 flex flex-col shadow-[0_0_50px_rgba(0,216,255,0.25)]`}
            >
              {/* Drawer Top Header with Close Button */}
              <div className="p-5 border-b border-white/5 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <img 
                    alt="Dental AI Clinic Logo" 
                    className="w-8 h-8 drop-shadow-[0_0_8px_rgba(0,216,255,0.6)] object-contain" 
                    src="https://lh3.googleusercontent.com/aida/AP1WRLvgpJuNbz7ZGBSUud_zbYaRxgvpRkXubIr9UDnaFKaCeDZH5fWaQtfNJE9WRNmtOJeAjeGXfGK_iajc4akHDTJjiyZC5ATTuYC--1l7gOgaq35HTTNE0KiTX9vlW-WthJ87N_OAxlXAR7grSPmEisQhtU6Obp9FNyv6SKR4dad81sTNF8-0sKgWccdIiq9J9hI1HejVCC00DAP7ioDxnnWCGgNdmwyD2-MDvhpZyedHKIUXyzjdGJGNT7I"
                  />
                  <span className="font-extrabold tracking-tighter text-[#00D8FF] text-base drop-shadow-[0_0_8px_rgba(0,216,255,0.5)]">
                    DENTAL AI
                  </span>
                </div>
                <button 
                  onClick={() => setIsMenuOpen(false)}
                  className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center text-[#B6D3E5] hover:bg-white/10 hover:text-white transition-all cursor-pointer"
                >
                  <X size={18} />
                </button>
              </div>

              {/* Drawer List (The list in the header is fully filled) */}
              <div className="flex-1 overflow-y-auto py-5 px-4 space-y-2">
                {[
                  { key: 'home', icon: Home, label_ar: 'الرئيسية', label_en: 'Home' },
                  { key: 'services', icon: Stethoscope, label_ar: 'الخدمات المميزة', label_en: 'Our Services' },
                  { key: 'gallery', icon: LayoutGrid, label_ar: 'معرض الصور', label_en: 'Gallery' },
                  { key: 'about', icon: User, label_ar: 'عن الدكتور', label_en: 'About Doctor' },
                  { key: 'contact', icon: Phone, label_ar: 'اتصل بنا', label_en: 'Contact Us' },
                  { key: 'appointments', icon: Bell, label_ar: 'مواعيدي والإشعارات', label_en: 'My Bookings', isBadge: true }
                ].map((item) => {
                  const isActive = currentTab === item.key;
                  const IconComp = item.icon;
                  return (
                    <button
                      key={item.key}
                      onClick={() => {
                        setCurrentTab(item.key);
                        if (item.key !== 'services') {
                          setSelectedServiceId(null);
                        }
                        setIsMenuOpen(false);
                      }}
                      className={`w-full flex items-center gap-4 px-4 py-3.5 rounded-xl transition-all cursor-pointer ${
                        isActive 
                          ? 'bg-[#00D8FF]/10 text-[#00D8FF] border border-[#00D8FF]/20 shadow-[0_0_15px_rgba(0,216,255,0.05)]' 
                          : 'text-[#B6D3E5] hover:bg-white/5 hover:text-white border border-transparent'
                      } ${lang === 'ar' ? 'flex-row' : 'flex-row-reverse'}`}
                    >
                      <div className="relative">
                        <IconComp size={18} className={isActive ? 'text-[#00D8FF]' : 'text-[#B6D3E5]/70'} />
                        {item.isBadge && (
                          <span className="absolute -top-1 -right-1 w-2.5 h-2.5 bg-red-500 rounded-full border border-[#07131E] animate-pulse"></span>
                        )}
                      </div>
                      <span className={`text-sm font-bold font-arabic-body flex-1 ${lang === 'ar' ? 'text-right' : 'text-left'}`}>
                        {lang === 'ar' ? item.label_ar : item.label_en}
                      </span>
                    </button>
                  );
                })}
              </div>

              {/* Drawer Bottom Info */}
              <div className="p-5 border-t border-white/5 text-center">
                <p className="text-[10px] text-[#B6D3E5]/40 uppercase tracking-widest font-mono">Premium Clinical System</p>
                <p className="text-[10px] text-[#00D8FF]/50 mt-1">v1.2.0-AI</p>
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* Interactive Booking Wizard Form Modal Container */}
      <AnimatePresence>
        {isBookingOpen && (
          <BookingWizard 
            isOpen={isBookingOpen}
            onClose={() => setIsBookingOpen(false)}
            lang={lang}
            preselectedServiceId={selectedServiceId}
            onSuccess={handleBookingSuccess}
          />
        )}
      </AnimatePresence>
    </div>
  );
}
