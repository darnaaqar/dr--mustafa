import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  X, Calendar, Clock, User, Phone, FileText, CheckCircle2, ChevronRight, Sparkles, AlertCircle 
} from 'lucide-react';
import { db } from '../lib/db';
import { Doctor, Service, Appointment } from '../types';
import { translations, Language } from '../utils/i18n';

interface BookingWizardProps {
  isOpen: boolean;
  onClose: () => void;
  lang: Language;
  preselectedServiceId: string | null;
  onSuccess: () => void;
}

export default function BookingWizard({ isOpen, onClose, lang, preselectedServiceId, onSuccess }: BookingWizardProps) {
  const t = translations[lang];

  // State
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  const [services, setServices] = useState<Service[]>([]);
  const [currentStep, setCurrentStep] = useState(1); // 1: Setup & Info, 2: Success

  // Form selections
  const [selectedDoctorId, setSelectedDoctorId] = useState<string>('');
  const [selectedServiceId, setSelectedServiceId] = useState<string>('');
  const [selectedDate, setSelectedDate] = useState<string>('2026-07-15'); // seeded date
  const [selectedTime, setSelectedTime] = useState<string>('04:00 PM');
  const [fullName, setFullName] = useState<string>('');
  const [phoneNumber, setPhoneNumber] = useState<string>('');
  const [emailAddress, setEmailAddress] = useState<string>('');
  const [notes, setNotes] = useState<string>('');
  
  // Visual states
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');
  const [confirmedBooking, setConfirmedBooking] = useState<Appointment | null>(null);

  // Fetch doctors and services
  useEffect(() => {
    async function loadData() {
      const docs = await db.getDoctors();
      const srvs = await db.getServices();
      setDoctors(docs);
      setServices(srvs);
      
      if (docs.length > 0) {
        setSelectedDoctorId(docs[0].id);
      }
      if (preselectedServiceId) {
        setSelectedServiceId(preselectedServiceId);
      } else if (srvs.length > 0) {
        setSelectedServiceId(srvs[0].id);
      }
    }
    if (isOpen) {
      loadData();
      setCurrentStep(1);
      setErrorMessage('');
    }
  }, [isOpen, preselectedServiceId]);

  if (!isOpen) return null;

  // Calendar setup (Simplified mock days for July 2026)
  const calendarDays = [
    { dayNum: '12', weekday_ar: 'أحد', weekday_en: 'Sun' },
    { dayNum: '13', weekday_ar: 'اثنين', weekday_en: 'Mon' },
    { dayNum: '14', weekday_ar: 'ثلاثاء', weekday_en: 'Tue' },
    { dayNum: '15', weekday_ar: 'أربعاء', weekday_en: 'Wed', active: true },
    { dayNum: '16', weekday_ar: 'خميس', weekday_en: 'Thu' },
    { dayNum: '17', weekday_ar: 'جمعة', weekday_en: 'Fri' },
    { dayNum: '18', weekday_ar: 'سبت', weekday_en: 'Sat' },
  ];

  const timeSlots = [
    '10:00 AM', '11:00 AM', '12:00 PM',
    '01:00 PM', '04:00 PM', '05:00 PM',
    '06:00 PM', '07:00 PM', '08:00 PM'
  ];

  // Handle Form Submission
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!fullName.trim()) {
      setErrorMessage(lang === 'ar' ? 'الرجاء إدخال الاسم الكامل' : 'Please enter your full name');
      return;
    }
    if (!phoneNumber.trim()) {
      setErrorMessage(lang === 'ar' ? 'الرجاء إدخال رقم الهاتف' : 'Please enter your phone number');
      return;
    }
    if (!selectedServiceId) {
      setErrorMessage(lang === 'ar' ? 'الرجاء اختيار الخدمة' : 'Please select a service');
      return;
    }

    setIsSubmitting(true);
    setErrorMessage('');

    try {
      const appointmentData = {
        patient_name: fullName,
        phone: phoneNumber,
        email: emailAddress || null,
        service_id: selectedServiceId,
        appointment_date: selectedDate,
        appointment_time: selectedTime,
        notes: notes || null
      };

      const result = await db.createAppointment(appointmentData);
      setConfirmedBooking(result);
      setCurrentStep(2); // Go to success screen
      onSuccess();
    } catch (err: any) {
      setErrorMessage(err?.message || 'Error occurred while saving booking. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md overflow-y-auto">
      <motion.div 
        initial={{ opacity: 0, scale: 0.95, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.95, y: 20 }}
        className="relative w-full max-w-[420px] bg-[#07131E] border border-[#00D8FF]/20 rounded-3xl overflow-hidden shadow-[0_0_50px_rgba(0,216,255,0.15)] flex flex-col max-h-[90vh]"
      >
        {/* Header */}
        <div className="flex items-center justify-between p-5 border-b border-white/5 bg-[#07131E]/90 sticky top-0 z-20 backdrop-blur-md">
          <div className="flex items-center gap-3">
            <div className="w-2 h-2 rounded-full bg-[#00D8FF] animate-pulse"></div>
            <h2 className="font-arabic-headline font-bold text-lg text-white drop-shadow-[0_0_8px_rgba(0,216,255,0.4)]">
              {currentStep === 1 ? t.book_now : t.success_title}
            </h2>
          </div>
          <button 
            onClick={onClose}
            className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center text-[#B6D3E5] hover:bg-white/10 hover:text-white transition-all cursor-pointer"
          >
            <X size={18} />
          </button>
        </div>

        {/* Modal Content */}
        <div className="flex-1 overflow-y-auto p-5 space-y-6">
          {currentStep === 1 && (
            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Progress Steps Header */}
              <div className="flex justify-between items-center px-4 py-2 relative">
                <div className="absolute top-1/2 left-4 right-4 h-[1px] bg-white/10 -z-10"></div>
                {[1, 2, 3, 4].map((step) => (
                  <div key={step} className="flex flex-col items-center gap-1">
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold transition-all duration-300 ${
                      step === 1 
                        ? 'bg-[#00D8FF] text-[#07131E] shadow-[0_0_12px_rgba(0,216,255,0.5)]' 
                        : 'bg-[#0F1D2A] border border-white/10 text-[#B6D3E5]'
                    }`}>
                      {step}
                    </div>
                  </div>
                ))}
              </div>

              {/* Error Alert */}
              {errorMessage && (
                <div className="p-3 rounded-xl bg-red-500/10 border border-red-500/20 text-red-400 text-xs flex items-center gap-2">
                  <AlertCircle size={16} className="shrink-0" />
                  <span>{errorMessage}</span>
                </div>
              )}

              {/* Select Doctor */}
              <div className="space-y-3">
                <h3 className="font-arabic-headline text-sm text-white">{t.choose_doctor}</h3>
                {doctors.map((doc) => (
                  <div 
                    key={doc.id}
                    onClick={() => setSelectedDoctorId(doc.id)}
                    className="glass-card p-4 rounded-xl flex items-center justify-between border-l-4 border-l-[#00D8FF] cursor-pointer hover:bg-white/5 transition-all"
                  >
                    <div className="flex items-center gap-4">
                      <img 
                        src={doc.image_url || 'https://images.unsplash.com/photo-1622253692010-333f2da6031d?auto=format&fit=crop&q=80&w=200'} 
                        alt={doc.full_name}
                        className="w-12 h-12 rounded-lg object-cover border border-white/10"
                      />
                      <div>
                        <h4 className="font-bold text-white text-sm">{lang === 'ar' ? doc.full_name : 'Dr. Mustafa Al-Rifai'}</h4>
                        <p className="text-xs text-[#B6D3E5]">{lang === 'ar' ? doc.title_ar : doc.title_en}</p>
                      </div>
                    </div>
                    <div className="w-5 h-5 rounded-full border-2 border-[#00D8FF] flex items-center justify-center">
                      <div className="w-2.5 h-2.5 rounded-full bg-[#00D8FF]"></div>
                    </div>
                  </div>
                ))}
              </div>

              {/* Select Service */}
              <div className="space-y-3">
                <label className="block font-arabic-headline text-sm text-white">{t.service}</label>
                <select 
                  value={selectedServiceId}
                  onChange={(e) => setSelectedServiceId(e.target.value)}
                  className="w-full bg-[#0F1D2A] border border-white/10 rounded-xl px-4 py-3 text-white text-sm focus:border-[#00D8FF] focus:ring-1 focus:ring-[#00D8FF]/30 transition-all outline-none"
                >
                  <option value="">{lang === 'ar' ? 'اختر الخدمة المطلوبة...' : 'Choose target service...'}</option>
                  {services.map((srv) => (
                    <option key={srv.id} value={srv.id}>
                      {lang === 'ar' ? srv.title_ar : srv.title_en}
                    </option>
                  ))}
                </select>
              </div>

              {/* Date Selection */}
              <div className="space-y-3">
                <div className="flex justify-between items-center">
                  <h3 className="font-arabic-headline text-sm text-white">{t.choose_date}</h3>
                  <span className="text-xs text-[#B6D3E5] flex items-center gap-1 font-mono">
                    {lang === 'ar' ? 'يوليو 2026' : 'July 2026'} <Calendar size={12} />
                  </span>
                </div>
                <div className="glass-card p-3 rounded-2xl">
                  <div className="grid grid-cols-7 gap-1 text-center">
                    {['أحد', 'اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت'].map((day, idx) => (
                      <span key={idx} className="text-[10px] text-[#B6D3E5] py-1">
                        {lang === 'ar' ? day : ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][idx]}
                      </span>
                    ))}
                    {calendarDays.map((day, idx) => {
                      const fullDate = `2026-07-${day.dayNum}`;
                      const isSelected = selectedDate === fullDate;
                      return (
                        <button
                          key={idx}
                          type="button"
                          onClick={() => setSelectedDate(fullDate)}
                          className={`h-9 flex flex-col items-center justify-center rounded-lg transition-all text-xs font-semibold cursor-pointer ${
                            isSelected 
                              ? 'bg-gradient-to-tr from-[#00D4FF] to-[#00A6E6] text-[#07131E] shadow-[0_0_12px_rgba(0,216,255,0.4)]' 
                              : 'text-[#B6D3E5] hover:bg-white/5'
                          }`}
                        >
                          {day.dayNum}
                          <span className={`w-1 h-1 rounded-full bg-[#00D8FF] mt-0.5 ${isSelected ? 'opacity-100 bg-white' : 'opacity-40'}`}></span>
                        </button>
                      );
                    })}
                  </div>
                </div>
              </div>

              {/* Time Slots */}
              <div className="space-y-3">
                <h3 className="font-arabic-headline text-sm text-white">{t.choose_time}</h3>
                <div className="grid grid-cols-3 gap-2">
                  {timeSlots.map((time) => {
                    const isSelected = selectedTime === time;
                    return (
                      <button
                        key={time}
                        type="button"
                        onClick={() => setSelectedTime(time)}
                        className={`py-2.5 rounded-lg text-xs font-semibold border transition-all cursor-pointer ${
                          isSelected 
                            ? 'bg-gradient-to-tr from-[#00D4FF] to-[#00A6E6] text-[#07131E] border-transparent shadow-[0_0_10px_rgba(0,216,255,0.3)]' 
                            : 'bg-[#0F1D2A] border-white/5 text-[#B6D3E5] hover:border-[#00D8FF]/30'
                        }`}
                      >
                        {time}
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Patient Info */}
              <div className="space-y-4">
                <h3 className="font-arabic-headline text-sm text-white">{t.patient_info}</h3>
                <div className="space-y-3">
                  <div className="relative">
                    <input 
                      type="text" 
                      placeholder={t.full_name}
                      value={fullName}
                      onChange={(e) => setFullName(e.target.value)}
                      required
                      className="w-full bg-[#0F1D2A] border border-white/10 rounded-xl px-4 py-3.5 pr-10 text-sm text-white placeholder-[#B6D3E5]/40 outline-none focus:border-[#00D8FF] focus:ring-1 focus:ring-[#00D8FF]/30 transition-all"
                    />
                    <User size={16} className="absolute right-3.5 top-1/2 -translate-y-1/2 text-[#B6D3E5]/40" />
                  </div>

                  <div className="relative">
                    <input 
                      type="tel" 
                      placeholder={t.phone_number}
                      value={phoneNumber}
                      onChange={(e) => setPhoneNumber(e.target.value)}
                      required
                      className="w-full bg-[#0F1D2A] border border-white/10 rounded-xl px-4 py-3.5 pr-10 text-sm text-white placeholder-[#B6D3E5]/40 outline-none focus:border-[#00D8FF] focus:ring-1 focus:ring-[#00D8FF]/30 transition-all"
                    />
                    <Phone size={16} className="absolute right-3.5 top-1/2 -translate-y-1/2 text-[#B6D3E5]/40" />
                  </div>

                  <div className="relative">
                    <input 
                      type="email" 
                      placeholder={t.email + ` (${lang === 'ar' ? 'اختياري' : 'optional'})`}
                      value={emailAddress}
                      onChange={(e) => setEmailAddress(e.target.value)}
                      className="w-full bg-[#0F1D2A] border border-white/10 rounded-xl px-4 py-3.5 pr-10 text-sm text-white placeholder-[#B6D3E5]/40 outline-none focus:border-[#00D8FF] focus:ring-1 focus:ring-[#00D8FF]/30 transition-all"
                    />
                    <FileText size={16} className="absolute right-3.5 top-1/2 -translate-y-1/2 text-[#B6D3E5]/40" />
                  </div>

                  <div className="relative">
                    <textarea 
                      placeholder={t.notes}
                      value={notes}
                      onChange={(e) => setNotes(e.target.value)}
                      className="w-full h-20 bg-[#0F1D2A] border border-white/10 rounded-xl px-4 py-3 pr-10 text-sm text-white placeholder-[#B6D3E5]/40 outline-none focus:border-[#00D8FF] focus:ring-1 focus:ring-[#00D8FF]/30 transition-all resize-none"
                    ></textarea>
                    <FileText size={16} className="absolute right-3.5 top-4 text-[#B6D3E5]/40" />
                  </div>
                </div>
              </div>

              {/* Submit CTA */}
              <button
                type="submit"
                disabled={isSubmitting}
                className="w-full h-14 rounded-xl bg-gradient-to-r from-[#00D4FF] to-[#00A6E6] text-[#07131E] font-bold text-sm tracking-wide shadow-[0_0_20px_rgba(0,216,255,0.4)] active:scale-95 transition-all cursor-pointer flex items-center justify-center gap-2"
              >
                {isSubmitting ? (
                  <div className="w-5 h-5 border-2 border-[#07131E] border-t-transparent rounded-full animate-spin"></div>
                ) : (
                  <>
                    <span>{lang === 'ar' ? 'التالي' : 'Next'}</span>
                    <ChevronRight size={16} className={lang === 'ar' ? 'rotate-180' : ''} />
                  </>
                )}
              </button>
            </form>
          )}

          {currentStep === 2 && confirmedBooking && (
            <div className="text-center py-6 space-y-6">
              {/* Glowing animated success circle */}
              <div className="relative w-24 h-24 mx-auto flex items-center justify-center">
                <div className="absolute inset-0 bg-[#00D8FF]/10 rounded-full blur-xl animate-pulse"></div>
                <div className="absolute inset-0 border-2 border-[#00D8FF]/30 rounded-full scale-110"></div>
                <motion.div 
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ type: 'spring', damping: 15 }}
                  className="w-20 h-20 rounded-full bg-gradient-to-tr from-[#00D4FF] to-[#00A6E6] border border-[#00D8FF]/40 flex items-center justify-center text-[#07131E]"
                >
                  <CheckCircle2 size={42} className="text-[#07131E] drop-shadow-[0_0_10px_rgba(255,255,255,0.6)]" />
                </motion.div>
              </div>

              <div className="space-y-2">
                <h3 className="font-arabic-headline font-bold text-xl text-white">{t.success_title}</h3>
                <p className="text-sm text-[#B6D3E5] leading-relaxed max-w-xs mx-auto">{t.success_desc}</p>
              </div>

              {/* Reservation card detail */}
              <div className="glass-card p-4 rounded-2xl border border-white/5 space-y-3 text-right">
                <div className="flex justify-between items-center border-b border-white/5 pb-2">
                  <span className="text-[#00D8FF] text-xs font-mono font-bold uppercase">{lang === 'ar' ? 'رقم الحجز' : 'Booking ID'}</span>
                  <span className="text-white text-xs font-mono font-bold">#{confirmedBooking.id}</span>
                </div>
                <div className="grid grid-cols-2 gap-3 text-xs">
                  <div>
                    <span className="text-[#B6D3E5] block mb-0.5">{t.date}</span>
                    <span className="text-white font-bold">{confirmedBooking.appointment_date}</span>
                  </div>
                  <div>
                    <span className="text-[#B6D3E5] block mb-0.5">{t.time}</span>
                    <span className="text-white font-bold">{confirmedBooking.appointment_time}</span>
                  </div>
                  <div className="col-span-2">
                    <span className="text-[#B6D3E5] block mb-0.5">{t.service}</span>
                    <span className="text-white font-bold">
                      {services.find(s => s.id === confirmedBooking.service_id)?.title_ar || 'زراعة الأسنان'}
                    </span>
                  </div>
                  <div className="col-span-2">
                    <span className="text-[#B6D3E5] block mb-0.5">{t.doctor}</span>
                    <span className="text-white font-bold">
                      {doctors.find(d => d.id === selectedDoctorId)?.full_name || 'د. مصطفى الرفاعي'}
                    </span>
                  </div>
                </div>
              </div>

              {/* Close CTAs */}
              <button
                onClick={onClose}
                className="w-full py-4 rounded-xl bg-gradient-to-r from-[#00D4FF] to-[#00A6E6] text-[#07131E] font-bold text-sm tracking-wide shadow-[0_0_15px_rgba(0,216,255,0.3)] active:scale-95 transition-all cursor-pointer"
              >
                {t.back_to_home}
              </button>
            </div>
          )}
        </div>
      </motion.div>
    </div>
  );
}
