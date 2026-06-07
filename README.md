# CineTrack 🎬

Film ve dizi kataloğu uygulaması. Software Persona Yazılım Stajı — Flutter projesi.

## 📱 Ekranlar

| Ana Sayfa | Keşfet | Film Detayı | İzleme Listesi |
|-----------|---------|-------------|----------------|
| Banner, kategoriler, trend/popüler listeleri | GridView, arama, tür & tip filtresi | Puan, özet, oyuncular, izleme durumu | Sekmeli: İzledim / İzliyorum / İzleceğim |

## 🚀 Özellikler

- **Ana Sayfa** — Hero banner, kategori butonları, yatay kaydırmalı listeler (Trend, Film, Dizi)
- **Keşfet** — 3 sütun GridView, gerçek zamanlı arama, Film/Dizi toggle, tür filtresi, sıralama
- **Film Detayı** — SliverAppBar, IMDb puanı, tür etiketleri, özet, yönetmen/oyuncular
- **İzleme Takibi** — Her film için ✅ İzledim / ▶️ İzliyorum / 🔖 İzleceğim durumu
- **İzleme Listesi** — Sekmeli görünüm, durum bazında listeleme
- **Navigator** — push/pop ile sayfa geçişleri
- **ChangeNotifier** — Reaktif state yönetimi

## 🎬 İçerik (14 Başlık)

**Filmler:** Kuru Otlar Üstüne, Oppenheimer, Past Lives, Inception, Interstellar, Parasite, Dune Part Two, Poor Things

**Diziler:** Breaking Bad, Chernobyl, Shogun, The Bear, Squid Game, Severance

## 🛠 Teknolojiler

- Flutter SDK / Dart
- `ChangeNotifier` — state yönetimi
- `Navigator.push/pop` — sayfa geçişleri  
- `GridView.builder` — katalog görünümü
- `CustomScrollView` + `SliverAppBar` — detay ekranı
- `TabController` — izleme listesi sekmeleri

## 📁 Klasör Yapısı

```
lib/
├── main.dart
├── models/
│   ├── movie.dart          ← Film/dizi modeli
│   └── watchlist.dart      ← İzleme listesi (ChangeNotifier)
├── data/
│   ├── movies_data.dart    ← 14 başlık verisi
│   └── app_theme.dart      ← Koyu tema sabitleri
├── screens/
│   ├── home_screen.dart         ← Ana sayfa
│   ├── catalog_screen.dart      ← Keşfet (GridView)
│   ├── movie_detail_screen.dart ← Film detayı
│   └── watchlist_screen.dart    ← İzleme listesi
└── widgets/
    └── movie_card.dart     ← Yeniden kullanılabilir film kartı
```

## ▶️ Çalıştırma

```bash
flutter pub get
flutter run
```

## 👩‍💻 Geliştirici

**Sueda Kurnaz** — Software Persona Yazılım Stajı, 14. Dönem
