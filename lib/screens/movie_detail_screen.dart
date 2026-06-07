import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../models/watchlist.dart';
import '../data/app_theme.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;
  final WatchlistModel watchlist;

  const MovieDetailScreen({super.key, required this.movie, required this.watchlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.bg,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_rounded, size: 18, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(children: [
                // Backdrop
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: movie.backdropUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      decoration: const BoxDecoration(gradient: LinearGradient(
                        colors: [Color(0xFF1a1030), Color(0xFF0D0F14)],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      decoration: const BoxDecoration(gradient: LinearGradient(
                        colors: [Color(0xFF1a1030), Color(0xFF0D0F14)],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                    ),
                  ),
                ),
                // Gradient
                Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.1), Colors.black.withOpacity(0.95)],
                  ),
                ))),
                // Poster + başlık
                Positioned(
                  left: 16, right: 16, bottom: 20,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    // Poster thumbnail
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: movie.posterUrl,
                        width: 85, height: 125,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 85, height: 125, color: AppTheme.elevated,
                          child: const Center(child: SizedBox(width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 1.5, color: AppTheme.primary))),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 85, height: 125, color: AppTheme.elevated,
                          child: const Icon(Icons.movie_outlined, color: AppTheme.text3, size: 28)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Başlık bilgileri
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: movie.type == MediaType.series ? AppTheme.accent : AppTheme.primary,
                          borderRadius: BorderRadius.circular(5)),
                        child: Text(movie.typeLabel, style: TextStyle(
                          color: movie.type == MediaType.series ? Colors.white : Colors.black,
                          fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                      ),
                      const SizedBox(height: 8),
                      Text(movie.title, style: const TextStyle(
                        color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800,
                        letterSpacing: -0.4, height: 1.2,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 8)])),
                      if (movie.title != movie.originalTitle) ...[
                        const SizedBox(height: 3),
                        Text(movie.originalTitle,
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                      ],
                      const SizedBox(height: 8),
                      Row(children: [
                        const Icon(Icons.star_rounded, size: 14, color: AppTheme.star),
                        const SizedBox(width: 4),
                        Text(movie.rating.toStringAsFixed(1), style: const TextStyle(
                          color: AppTheme.star, fontSize: 14, fontWeight: FontWeight.w800)),
                        const SizedBox(width: 10),
                        Text('${movie.year}',
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                        const SizedBox(width: 8),
                        Text(movie.durationText,
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                      ]),
                    ])),
                  ]),
                ),
              ]),
            ),
          ),

          SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 4),

            // Meta + durum butonları
            Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Tür etiketleri
                Wrap(spacing: 7, runSpacing: 7, children: movie.genres.map((g) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.accentDim,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accent.withOpacity(0.3))),
                  child: Text(g, style: const TextStyle(
                    color: AppTheme.accent, fontSize: 12, fontWeight: FontWeight.w600)),
                )).toList()),
                const SizedBox(height: 14),
                // Meta chips
                Row(children: [
                  _MetaChip(label: '${movie.year}'),
                  const SizedBox(width: 8),
                  _MetaChip(label: movie.durationText),
                  const SizedBox(width: 8),
                  _MetaChip(label: movie.language),
                ]),
                const SizedBox(height: 16),
                // İzleme durumu butonları
                ListenableBuilder(
                  listenable: watchlist,
                  builder: (_, __) => _WatchStatusRow(movie: movie, watchlist: watchlist),
                ),
              ]),
            ),

            const SizedBox(height: 8),

            // Özet
            Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Özet', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.text1)),
                const SizedBox(height: 8),
                Text(movie.overview, style: const TextStyle(
                  fontSize: 14, color: AppTheme.text2, height: 1.6)),
              ]),
            ),

            const SizedBox(height: 8),

            // Yapım kadrosu
            Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Yapım Kadrosu', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.text1)),
                const SizedBox(height: 12),
                _CrewRow(label: 'Yönetmen', value: movie.director),
                const SizedBox(height: 8),
                const Divider(color: AppTheme.border, height: 1),
                const SizedBox(height: 8),
                _CrewRow(label: 'Oyuncular', value: movie.cast.join(', ')),
              ]),
            ),

            const SizedBox(height: 40),
          ])),
        ],
      ),
    );
  }
}

class _WatchStatusRow extends StatelessWidget {
  final Movie movie;
  final WatchlistModel watchlist;
  const _WatchStatusRow({required this.movie, required this.watchlist});

  @override
  Widget build(BuildContext context) {
    final status = watchlist.getStatus(movie.id);
    final buttons = [
      (WatchStatus.watched,  Icons.check_circle_rounded, AppTheme.green,   'İzledim'),
      (WatchStatus.watching, Icons.play_circle_rounded,  AppTheme.primary, 'İzliyorum'),
      (WatchStatus.wishlist, Icons.bookmark_rounded,     AppTheme.accent,  'İzleceğim'),
    ];
    return Row(
      children: buttons.map((b) {
        final selected = status == b.$1;
        return Expanded(child: Padding(
          padding: EdgeInsets.only(right: b.$1 == WatchStatus.wishlist ? 0 : 8),
          child: GestureDetector(
            onTap: () => watchlist.setStatus(movie.id, b.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: selected ? b.$3.withOpacity(0.15) : AppTheme.elevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: selected ? b.$3.withOpacity(0.5) : AppTheme.border),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(b.$2, size: 20, color: selected ? b.$3 : AppTheme.text3),
                const SizedBox(height: 4),
                Text(b.$4, style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: selected ? b.$3 : AppTheme.text3,
                )),
              ]),
            ),
          ),
        ));
      }).toList(),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  const _MetaChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: AppTheme.elevated,
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: AppTheme.border),
    ),
    child: Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.text2)),
  );
}

class _CrewRow extends StatelessWidget {
  final String label, value;
  const _CrewRow({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(width: 90, child: Text(label,
      style: const TextStyle(fontSize: 13, color: AppTheme.text3, fontWeight: FontWeight.w500))),
    Expanded(child: Text(value,
      style: const TextStyle(fontSize: 13, color: AppTheme.text1))),
  ]);
}
