import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../models/watchlist.dart';
import '../data/movies_data.dart';
import '../data/app_theme.dart';
import '../widgets/movie_card.dart';
import 'catalog_screen.dart';
import 'movie_detail_screen.dart';
import 'watchlist_screen.dart';

class HomeScreen extends StatelessWidget {
  final WatchlistModel watchlist;
  const HomeScreen({super.key, required this.watchlist});

  @override
  Widget build(BuildContext context) {
    final trending = movies.where((m) => m.isTrending).toList();
    final popularMovies = movies.where((m) => m.isPopular && m.type == MediaType.movie).toList();
    final seriesList = movies.where((m) => m.type == MediaType.series).toList();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.bg,
            titleSpacing: 20,
            title: Row(children: [
              Container(
                width: 34, height: 34,
                decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(9)),
                child: const Icon(Icons.movie_filter_rounded, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('CineTrack', style: TextStyle(color: AppTheme.text1, fontSize: 20,
                fontWeight: FontWeight.w800, letterSpacing: -0.5)),
            ]),
            actions: [
              ListenableBuilder(
                listenable: watchlist,
                builder: (_, __) {
                  final count = watchlist.watchedCount + watchlist.watchingCount + watchlist.wishlistCount;
                  return Stack(children: [
                    IconButton(
                      icon: const Icon(Icons.bookmarks_outlined, color: AppTheme.text2),
                      onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => WatchlistScreen(watchlist: watchlist))),
                    ),
                    if (count > 0) Positioned(right: 6, top: 6,
                      child: Container(width: 17, height: 17,
                        decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                        child: Center(child: Text('$count', style: const TextStyle(
                          color: Colors.black, fontSize: 9, fontWeight: FontWeight.w800))))),
                  ]);
                },
              ),
              const SizedBox(width: 4),
            ],
          ),

          SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // ── Hero Banner ─────────────────────────────────────────
            _HeroBanner(watchlist: watchlist),

            // ── Kategoriler ─────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Text('Kategoriler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                color: AppTheme.text1, letterSpacing: -0.3)),
            ),
            SizedBox(
              height: 82,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _CatBtn(icon: Icons.movie_rounded,             color: const Color(0xFFE8B84B), label:'Filmler',  filter:'Film',        watchlist:watchlist),
                  _CatBtn(icon: Icons.tv_rounded,                color: const Color(0xFF4F63D2), label:'Diziler',  filter:'Dizi',        watchlist:watchlist),
                  _CatBtn(icon: Icons.sports_martial_arts,       color: const Color(0xFFE84855), label:'Aksiyon',  filter:'Aksiyon',     watchlist:watchlist),
                  _CatBtn(icon: Icons.favorite_rounded,          color: const Color(0xFFEC407A), label:'Dram',     filter:'Dram',        watchlist:watchlist),
                  _CatBtn(icon: Icons.rocket_launch_rounded,     color: const Color(0xFF00BCD4), label:'Sci-Fi',   filter:'Bilim Kurgu', watchlist:watchlist),
                  _CatBtn(icon: Icons.psychology_alt_rounded,    color: const Color(0xFF9C27B0), label:'Gerilim',  filter:'Gerilim',     watchlist:watchlist),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Trend ───────────────────────────────────────────────
            _SectionRow(label: '🔥  Bu Hafta Trend', watchlist: watchlist, items: trending),
            // ── Popüler Filmler ─────────────────────────────────────
            _SectionRow(label: '⭐  Popüler Filmler', watchlist: watchlist,
              items: popularMovies,
              filter: 'Film'),
            // ── Diziler ─────────────────────────────────────────────
            _SectionRow(label: '📺  Popüler Diziler', watchlist: watchlist,
              items: seriesList,
              filter: 'Dizi'),

            const SizedBox(height: 40),
          ])),
        ],
      ),
    );
  }
}

// ── Hero Banner ────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final WatchlistModel watchlist;
  const _HeroBanner({required this.watchlist});

  @override
  Widget build(BuildContext context) {
    final featured = movies.firstWhere((m) => m.isTrending);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => MovieDetailScreen(movie: featured, watchlist: watchlist))),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.25), blurRadius: 24, offset: const Offset(0,8))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(children: [
            // Arka plan resmi
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: featured.backdropUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(decoration: const BoxDecoration(gradient: LinearGradient(
                  colors: [Color(0xFF1E1530), Color(0xFF0D1525)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight))),
                errorWidget: (_, __, ___) => Container(decoration: const BoxDecoration(gradient: LinearGradient(
                  colors: [Color(0xFF1E1530), Color(0xFF0D1525)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight))),
              ),
            ),
            // Gradient
            Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.15), Colors.black.withOpacity(0.85)],
              ),
            ))),
            // İçerik
            Positioned(left: 16, right: 16, bottom: 16,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(6)),
                    child: const Text('🔥 TREND', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(featured.genres.first, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(featured.title, style: const TextStyle(
                  color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800,
                  letterSpacing: -0.5, height: 1.15,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)])),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 15, color: AppTheme.star),
                  const SizedBox(width: 4),
                  Text(featured.rating.toStringAsFixed(1), style: const TextStyle(
                    color: AppTheme.star, fontSize: 14, fontWeight: FontWeight.w800)),
                  const SizedBox(width: 10),
                  Text('${featured.year}', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                  const SizedBox(width: 10),
                  Text(featured.durationText, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(20)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.play_arrow_rounded, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Text('İncele', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black)),
                    ]),
                  ),
                ]),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

// ── Kategori Butonu ─────────────────────────────────────────────────────────
class _CatBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, filter;
  final WatchlistModel watchlist;
  const _CatBtn({required this.icon, required this.color, required this.label, required this.filter, required this.watchlist});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(
      builder: (_) => CatalogScreen(watchlist: watchlist, initialFilter: filter))),
    child: Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(children: [
        Container(
          width: 58, height: 58,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 5),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.text2, fontWeight: FontWeight.w500)),
      ]),
    ),
  );
}

// ── Section Row ────────────────────────────────────────────────────────────
class _SectionRow extends StatelessWidget {
  final String label;
  final List<Movie> items;
  final WatchlistModel watchlist;
  final String? filter;
  const _SectionRow({required this.label, required this.items, required this.watchlist, this.filter});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 12, 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(label, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700,
            color: AppTheme.text1, letterSpacing: -0.3)),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => CatalogScreen(watchlist: watchlist, initialFilter: filter))),
            style: TextButton.styleFrom(foregroundColor: AppTheme.primary, padding: EdgeInsets.zero),
            child: const Text('Tümü →', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ]),
      ),
      SizedBox(
        height: 220,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) => SizedBox(
            width: 140,
            child: ListenableBuilder(
              listenable: watchlist,
              builder: (_, __) => MovieCard(movie: items[i], watchlist: watchlist),
            ),
          ),
        ),
      ),
      const SizedBox(height: 28),
    ]);
  }
}
