import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { db } from '../lib/db';
import { GalleryItem } from '../types';
import { Language, translations } from '../utils/i18n';
import { Sparkles, Calendar, Maximize2, X } from 'lucide-react';

interface GalleryTabProps {
  lang: Language;
  onBookClick: () => void;
}

export default function GalleryTab({ lang, onBookClick }: GalleryTabProps) {
  const t = translations[lang];

  // States
  const [items, setItems] = useState<GalleryItem[]>([]);
  const [selectedCategory, setSelectedCategory] = useState<string>('all');
  const [previewImage, setPreviewImage] = useState<string | null>(null);

  // Fetch Items
  useEffect(() => {
    async function loadGallery() {
      const gallery = await db.getGalleryItems();
      setItems(gallery);
    }
    loadGallery();
  }, []);

  // Filtering
  const filteredItems = selectedCategory === 'all' 
    ? items 
    : items.filter(item => item.category === selectedCategory);

  const categories = [
    { key: 'all', label_ar: 'الكل', label_en: 'All' },
    { key: 'clinic', label_ar: 'العيادة', label_en: 'Clinic' },
    { key: 'before_after', label_ar: 'قبل وبعد', label_en: 'Before & After' },
    { key: 'technology', label_ar: 'التقنيات', label_en: 'Technology' },
    { key: 'team', label_ar: 'الفريق', label_en: 'Team' },
  ];

  return (
    <div className="space-y-6 pb-12">
      {/* Header */}
      <section className="text-center space-y-1">
        <h2 className="font-arabic-headline text-2xl text-white font-bold drop-shadow-[0_0_10px_rgba(0,216,255,0.3)]">
          {t.gallery}
        </h2>
        <p className="font-mono text-[9px] text-[#B6D3E5] uppercase tracking-[0.2em]">
          Clinical Excellence Gallery
        </p>
        <div className="w-12 h-[2px] bg-[#00D8FF] mx-auto mt-2 rounded-full shadow-[0_0_8px_rgba(0,216,255,0.8)]"></div>
      </section>

      {/* Categories Horizontal Scroller */}
      <div className="flex gap-2 overflow-x-auto pb-2 scrollbar-none scroll-smooth">
        {categories.map((cat) => {
          const isActive = selectedCategory === cat.key;
          return (
            <button
              key={cat.key}
              onClick={() => setSelectedCategory(cat.key)}
              className={`flex-shrink-0 px-4 py-2 rounded-full text-xs font-semibold border transition-all cursor-pointer ${
                isActive 
                  ? 'bg-[#0F1D2A] border-[#00D8FF] text-[#00D8FF] shadow-[0_0_10px_rgba(0,216,255,0.2)]' 
                  : 'bg-transparent border-white/5 text-[#B6D3E5] hover:border-white/15'
              }`}
            >
              {lang === 'ar' ? cat.label_ar : cat.label_en}
            </button>
          );
        })}
      </div>

      {/* Bento-style Grid (Screenshot 2 and 4) */}
      <div className="grid grid-cols-2 gap-4">
        {filteredItems.map((item, idx) => {
          // Make certain items large (full column span) for dynamic bento look
          const isLarge = item.category === 'before_after' || idx === 3;
          return (
            <motion.div
              layout
              key={item.id}
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              transition={{ duration: 0.3 }}
              className={`glass-card rounded-2xl overflow-hidden relative group border border-white/5 hover:border-[#00D8FF]/30 transition-all ${
                isLarge ? 'col-span-2' : 'col-span-1'
              }`}
            >
              <div className={`relative ${isLarge ? 'aspect-video' : 'aspect-square'}`}>
                {/* Laser scan slider effect specifically for Before & After items */}
                {item.category === 'before_after' && (
                  <div className="absolute top-0 bottom-0 left-1/2 w-0.5 bg-[#00D8FF] z-10 shadow-[0_0_8px_rgba(0,216,255,1)]">
                    <div className="absolute top-1/2 -translate-y-1/2 -translate-x-1/2 w-6 h-6 rounded-full bg-[#0F1D2A] border border-[#00D8FF] flex items-center justify-center">
                      <span className="text-[8px] font-bold text-[#00D8FF]">↔</span>
                    </div>
                  </div>
                )}

                <img 
                  src={item.image_url} 
                  alt={item.title_en || 'Dental Clinic Photo'} 
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-700"
                />
                
                {/* Visual Glow overlay */}
                <div className="absolute inset-0 bg-gradient-to-t from-[#07131E]/95 via-transparent to-transparent opacity-80"></div>

                {/* Overlay details */}
                <div className="absolute bottom-3 left-3 right-3 flex justify-between items-end">
                  <div className="text-right">
                    {item.category === 'before_after' && (
                      <span className="text-[8px] font-bold text-[#00D8FF] tracking-widest uppercase block mb-0.5">
                        TREATMENT: FULL ARCH
                      </span>
                    )}
                    <h3 className="font-arabic-headline font-bold text-xs text-white">
                      {lang === 'ar' ? item.title_ar : item.title_en}
                    </h3>
                  </div>
                  <button 
                    onClick={() => setPreviewImage(item.image_url)}
                    className="w-7 h-7 rounded-lg bg-white/10 backdrop-blur-md flex items-center justify-center text-white opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer"
                  >
                    <Maximize2 size={12} />
                  </button>
                </div>
              </div>
            </motion.div>
          );
        })}
      </div>

      {/* Free Consultation Call-to-action */}
      <div className="pt-4">
        <button 
          onClick={onBookClick}
          className="w-full h-15 rounded-xl bg-gradient-to-r from-[#00D4FF] to-[#00A6E6] text-[#07131E] font-bold text-sm tracking-widest uppercase shadow-[0_0_20px_rgba(0,216,255,0.3)] hover:scale-[1.02] active:scale-95 transition-all flex items-center justify-center gap-2 cursor-pointer"
        >
          <Sparkles size={16} />
          <span>{lang === 'ar' ? 'حجز استشارة مجانية' : 'Book Free Consultation'}</span>
        </button>
      </div>

      {/* Image Zoom Preview Modal */}
      <AnimatePresence>
        {previewImage && (
          <motion.div 
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={() => setPreviewImage(null)}
            className="fixed inset-0 bg-black/90 z-[60] flex items-center justify-center p-4 backdrop-blur-sm"
          >
            <button className="absolute top-6 right-6 text-white bg-white/10 w-10 h-10 rounded-full flex items-center justify-center cursor-pointer">
              <X size={20} />
            </button>
            <motion.img 
              initial={{ scale: 0.9 }}
              animate={{ scale: 1 }}
              exit={{ scale: 0.9 }}
              src={previewImage} 
              alt="Zoomed dental asset" 
              className="max-w-full max-h-[80vh] object-contain rounded-xl border border-white/10"
            />
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
