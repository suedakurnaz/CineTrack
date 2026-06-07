import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie.dart';
import '../models/watchlist.dart';
import '../data/app_theme.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final WatchlistModel watchlist;

  const MovieCard({super.key, required this.movie, required this.watchlist});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie, watchlist: watchlist))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(fit: StackFit.expand, children: [
          // Poster
          CachedNetworkImage(
            imageUrl: movie.posterUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(
              color: AppTheme.elevated,
              child: const Center(child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 1.5, color: AppTheme.primary),
              )),
            ),
            errorWidget: (_, __, ___) => Container(
              color: AppTheme.elevated,
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.movie_outlined, color: AppTheme.text3, size: 28),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(movie.title, textAlign: TextAlign.center, maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppTheme.text3, fontSize: 10)),
                ),
              ]),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.transparent, Colors.black.withOpacity(0.9)],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
          ),

          // Tür badge (üst sol)
          Positioned(
            top: 8, left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: movie.type == MediaType.series ? AppTheme.accent : AppTheme.primary,
                borderRadius: BorderRadius.circular(6),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 4)],
              ),
              child: Text(movie.typeLabel, style: TextStyle(
                color: movie.type == MediaType.series ? Colors.white : Colors.black,
                fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 0.5,
              )),
            ),
          ),

          // İzleme durumu ikonu (üst sağ)
          ListenableBuilder(
            listenable: watchlist,
            builder: (_, __) {
              final status = watchlist.getStatus(movie.id);
              if (status == WatchStatus.notWatched) return const SizedBox();
              final (icon, color) = switch (status) {
                WatchStatus.watched  => (Icons.check_circle_rounded, AppTheme.green),
                WatchStatus.watching => (Icons.play_circle_rounded,  AppTheme.primary),
                WatchStatus.wishlist => (Icons.bookmark_rounded,     AppTheme.accent),
                _                    => (Icons.circle, Colors.transparent),
              };
              return Positioned(
                top: 8, right: 8,
                child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.65),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 15, color: color),
                ),
              );
            },
          ),

          // Alt bilgi
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: Colors.white, height: 1.25,
                    shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                  ),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 11, color: AppTheme.star),
                  const SizedBox(width: 3),
                  Text(movie.rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 11, color: AppTheme.star, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('${movie.year}',
                    style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.6))),
                ]),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
