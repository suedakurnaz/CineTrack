enum MediaType { movie, series }
enum WatchStatus { notWatched, watching, watched, wishlist }

class Movie {
  final int id;
  final String title;
  final String originalTitle;
  final String overview;
  final String posterUrl;
  final String backdropUrl;
  final MediaType type;
  final List<String> genres;
  final double rating;
  final int voteCount;
  final int year;
  final String director;
  final List<String> cast;
  final int durationMin; // film için dakika, dizi için bölüm sayısı
  final String language;
  final bool isTrending;
  final bool isPopular;
  WatchStatus watchStatus;
  double? userRating;

  Movie({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.type,
    required this.genres,
    required this.rating,
    required this.voteCount,
    required this.year,
    required this.director,
    required this.cast,
    required this.durationMin,
    required this.language,
    this.isTrending = false,
    this.isPopular = false,
    this.watchStatus = WatchStatus.notWatched,
    this.userRating,
  });

  String get durationText => type == MediaType.movie
      ? '${durationMin ~/ 60}s ${durationMin % 60}dk'
      : '$durationMin Bölüm';

  String get typeLabel => type == MediaType.movie ? 'Film' : 'Dizi';
}
