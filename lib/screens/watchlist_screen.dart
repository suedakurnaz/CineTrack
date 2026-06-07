import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/watchlist.dart';
import '../data/movies_data.dart';
import '../data/app_theme.dart';
import '../widgets/movie_card.dart';

class WatchlistScreen extends StatefulWidget {
  final WatchlistModel watchlist;
  const WatchlistScreen({super.key, required this.watchlist});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabs.dispose(); super.dispose(); }

  List<Movie> _getMovies(WatchStatus status) => movies
      .where((m) => widget.watchlist.getStatus(m.id) == status)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppTheme.text2),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('İzleme Listem'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Material(
            color: AppTheme.bg,
            child: TabBar(
              controller: _tabs,
              indicatorColor: AppTheme.primary,
              labelColor: AppTheme.primary,
              unselectedLabelColor: AppTheme.text2,
              labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: 'İzledim (${widget.watchlist.watchedCount})'),
                Tab(text: 'İzliyorum (${widget.watchlist.watchingCount})'),
                Tab(text: 'İzleceğim (${widget.watchlist.wishlistCount})'),
              ],
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.watchlist,
        builder: (_, __) => TabBarView(
          controller: _tabs,
          children: [
            _WatchGrid(movies: _getMovies(WatchStatus.watched),  watchlist: widget.watchlist, emptyMsg: 'Henüz izlediğin film yok', emptyIcon: '🎬'),
            _WatchGrid(movies: _getMovies(WatchStatus.watching), watchlist: widget.watchlist, emptyMsg: 'Şu an izlediğin içerik yok', emptyIcon: '▶️'),
            _WatchGrid(movies: _getMovies(WatchStatus.wishlist), watchlist: widget.watchlist, emptyMsg: 'İzlemek istediğin içerik yok', emptyIcon: '🔖'),
          ],
        ),
      ),
    );
  }
}

class _WatchGrid extends StatelessWidget {
  final List<Movie> movies;
  final WatchlistModel watchlist;
  final String emptyMsg;
  final String emptyIcon;

  const _WatchGrid({required this.movies, required this.watchlist, required this.emptyMsg, required this.emptyIcon});

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(emptyIcon, style: const TextStyle(fontSize: 52)),
        const SizedBox(height: 14),
        Text(emptyMsg, style: const TextStyle(fontSize: 15, color: AppTheme.text2, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        const Text('Katalogdan ekleyebilirsin', style: TextStyle(fontSize: 13, color: AppTheme.text3)),
      ]));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.55,
      ),
      itemCount: movies.length,
      itemBuilder: (_, i) => MovieCard(movie: movies[i], watchlist: watchlist),
    );
  }
}
