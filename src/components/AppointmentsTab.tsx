import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { db } from '../lib/db';
import { Appointment, Service } from '../types';
import { Language, translations } from '../utils/i18n';
import { Bell, Calendar, Clock, Sparkles, Trash2, ShieldAlert, Award, FileSpreadsheet } from 'lucide-react';

interface AppointmentsTabProps {
  lang: Language;
  onBookClick: () => void;
  bookingTriggerCount: number; // triggers reload when booking succeeds
}

export default function AppointmentsTab({ lang, onBookClick }: AppointmentsTabProps) {
  const t = translations[lang];

  // States
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [services, setServices] = useState<Service[]>([]);
  const [notifications, setNotifications] = useState<any[]>([]);

  // Fetch Appointments and Services
  const loadAppointmentsAndServices = async () => {
    const list = await db.getAppointments();
    const srvs = await db.getServices();
    setDoctors(await db.getDoctors());
    setServices(srvs);
    setAppointments(list);
  };

  const [doctors, setDoctors] = useState<any[]>([]);

  useEffect(() => {
    loadAppointmentsAndServices();
    
    // Seed notifications mimicking Screenshot 7
    setNotifications([
      {
        id: 'n1',
        title: t.notif_reminder,
        text: t.notif_reminder_text,
        time: '10:00 AM',
        date: lang === 'ar' ? 'اليوم' : 'Today',
        icon: 'bell',
        color: 'text-[#00D8FF]'
      },
      {
        id: 'n2',
        title: t.notif_offer,
        text: t.notif_offer_text,
        time: 'Yesterday',
        date: lang === 'ar' ? 'أمس' : 'Yesterday',
        icon: 'sparkles',
        color: 'text-green-400'
      },
      {
        id: 'n3',
        title: t.notif_results,
        text: t.notif_results_text,
        time: '2 Days Ago',
        date: lang === 'ar' ? 'قبل يومين' : '2 days ago',
        icon: 'file',
        color: 'text-[#00D8FF]'
      },
      {
        id: 'n4',
        title: t.notif_followup,
        text: t.notif_followup_text,
        time: '3 Days Ago',
        date: lang === 'ar' ? 'قبل ٣ أيام' : '3 days ago',
        icon: 'award',
        color: 'text-amber-400'
      }
    ]);
  }, [lang]);

  // Cancel Appointment
  const handleCancel = async (id: string) => {
    try {
      const appointmentsList = localStorage.getItem('dental_appointments');
      if (appointmentsList) {
        const parsed = JSON.parse(appointmentsList) as Appointment[];
        const updated = parsed.filter(a => a.id !== id);
        localStorage.setItem('dental_appointments', JSON.stringify(updated));
        setAppointments(updated);
      }
    } catch (err) {
      console.error('Error cancelling appointment:', err);
    }
  };

  return (
    <div className="space-y-8 pb-12">
      {/* Tab Header */}
      <section className="text-center space-y-1">
        <h2 className="font-arabic-headline text-2xl text-white font-bold drop-shadow-[0_0_10px_rgba(0,216,255,0.3)]">
          {t.notifications_title}
        </h2>
        <p className="font-mono text-[9px] text-[#B6D3E5] uppercase tracking-[0.2em]">
          Bilingual Diagnostics & Notifications Hub
        </p>
        <div className="w-12 h-[2px] bg-[#00D8FF] mx-auto mt-2 rounded-full shadow-[0_0_8px_rgba(0,216,255,0.8)]"></div>
      </section>

      {/* Appointments / Bookings list (Supabase or LocalStorage) */}
      <section className="space-y-4">
        <div className="flex items-center gap-2">
          <Calendar className="text-[#00D8FF]" size={18} />
          <h3 className="font-arabic-headline text-base font-bold text-white">{t.appointments}</h3>
          <div className="flex-grow h-px bg-gradient-to-r from-white/5 to-transparent"></div>
        </div>

        <div className="space-y-3">
          {appointments.length > 0 ? (
            appointments.map((app) => {
              const matchedService = services.find(s => s.id === app.service_id);
              const serviceName = matchedService 
                ? (lang === 'ar' ? matchedService.title_ar : matchedService.title_en)
                : (lang === 'ar' ? 'زراعة الأسنان الرقمية' : 'Digital Dental Implants');

              return (
                <motion.div 
                  key={app.id}
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  exit={{ opacity: 0 }}
                  className="glass-card p-4 rounded-xl border border-white/5 flex flex-col gap-3 text-right"
                >
                  <div className="flex justify-between items-center border-b border-white/5 pb-2 flex-row-reverse">
                    <span className="text-xs font-mono font-bold text-white">#{app.id}</span>
                    <span className={`text-[10px] font-bold px-2.5 py-0.5 rounded-full ${
                      app.status === 'pending' ? 'bg-[#00D8FF]/10 text-[#00D8FF] border border-[#00D8FF]/20' : 'bg-green-500/10 text-green-400'
                    }`}>
                      {t.status_pending}
                    </span>
                  </div>

                  <div className="grid grid-cols-2 gap-2 text-xs">
                    <div>
                      <span className="text-[#B6D3E5] block text-[10px] mb-0.5">{t.date}</span>
                      <span className="text-white font-bold">{app.appointment_date}</span>
                    </div>
                    <div>
                      <span className="text-[#B6D3E5] block text-[10px] mb-0.5">{t.time}</span>
                      <span className="text-white font-bold">{app.appointment_time}</span>
                    </div>
                    <div className="col-span-2">
                      <span className="text-[#B6D3E5] block text-[10px] mb-0.5">{t.service}</span>
                      <span className="text-white font-bold">{serviceName}</span>
                    </div>
                    {app.notes && (
                      <div className="col-span-2 border-t border-white/5 pt-2 mt-1">
                        <span className="text-[#B6D3E5] block text-[10px] mb-0.5">{t.notes_label}</span>
                        <p className="text-white text-[11px] leading-relaxed italic">"{app.notes}"</p>
                      </div>
                    )}
                  </div>

                  {/* Cancel Button */}
                  <div className="flex justify-end pt-2 border-t border-white/5">
                    <button 
                      onClick={() => handleCancel(app.id)}
                      className="text-red-400 text-[10px] font-bold flex items-center gap-1 hover:text-red-300 transition-colors p-1.5 hover:bg-red-500/10 rounded-lg cursor-pointer"
                    >
                      <Trash2 size={12} />
                      <span>{t.cancel_booking}</span>
                    </button>
                  </div>
                </motion.div>
              );
            })
          ) : (
            <div className="glass-card p-6 rounded-xl border border-white/5 text-center space-y-4">
              <p className="text-[#B6D3E5] text-xs leading-relaxed">{t.no_appointments}</p>
              <button 
                onClick={onBookClick}
                className="mx-auto px-4 py-2 rounded-lg bg-gradient-to-tr from-[#00D4FF] to-[#00A6E6] text-[#07131E] text-xs font-bold shadow-[0_0_10px_rgba(0,216,255,0.3)] active:scale-95 transition-all cursor-pointer"
              >
                {lang === 'ar' ? 'احجز موعداً أول الآن' : 'Schedule a booking'}
              </button>
            </div>
          )}
        </div>
      </section>

      {/* Interactive Medical Notifications (Screenshot 7 look-and-feel) */}
      <section className="space-y-4">
        <div className="flex items-center gap-2">
          <Bell className="text-[#00D8FF]" size={18} />
          <h3 className="font-arabic-headline text-base font-bold text-white">{t.my_bookings}</h3>
          <div className="flex-grow h-px bg-gradient-to-r from-white/5 to-transparent"></div>
        </div>

        <div className="space-y-3">
          {notifications.map((notif) => (
            <div 
              key={notif.id}
              className="glass-card p-4 rounded-2xl border border-white/5 flex gap-4 hover:border-[#00D8FF]/30 transition-all text-right flex-row-reverse items-start justify-between"
            >
              {/* Notification icon */}
              <div className="w-10 h-10 rounded-xl bg-white/5 flex items-center justify-center shrink-0 border border-white/10">
                {notif.icon === 'bell' && <Bell size={18} className="text-[#00D8FF] drop-shadow-[0_0_5px_rgba(0,216,255,0.5)]" />}
                {notif.icon === 'sparkles' && <Sparkles size={18} className="text-green-400 drop-shadow-[0_0_5px_rgba(34,197,94,0.5)]" />}
                {notif.icon === 'file' && <FileSpreadsheet size={18} className="text-[#00D8FF] drop-shadow-[0_0_5px_rgba(0,216,255,0.5)]" />}
                {notif.icon === 'award' && <Award size={18} className="text-amber-400 drop-shadow-[0_0_5px_rgba(251,191,36,0.5)]" />}
              </div>

              {/* Notification Details */}
              <div className="flex-1 space-y-1">
                <div className="flex justify-between items-center flex-row-reverse">
                  <span className="text-[10px] text-[#B6D3E5] font-mono">{notif.time}</span>
                  <h4 className="font-bold text-xs text-white">{notif.title}</h4>
                </div>
                <p className="text-[11px] text-[#B6D3E5] leading-relaxed">{notif.text}</p>
              </div>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}
