import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/watchlist.dart';
import '../data/movies_data.dart';
import '../data/app_theme.dart';
import '../widgets/movie_card.dart';

class CatalogScreen extends StatefulWidget {
  final WatchlistModel watchlist;
  final String? initialFilter;
  const CatalogScreen({super.key, required this.watchlist, this.initialFilter});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late String _typeFilter;
  late String _genreFilter;
  String _search = '';
  String _sortBy = 'Puan';
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final init = widget.initialFilter ?? 'Tümü';
    if (init == 'Film' || init == 'Dizi') {
      _typeFilter  = init;
      _genreFilter = 'Tümü';
    } else {
      _typeFilter  = 'Tümü';
      _genreFilter = (init == 'Tümü') ? 'Tümü' : init;
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  List<Movie> get _filtered {
    var list = movies.where((m) {
      final matchType   = _typeFilter == 'Tümü' || m.typeLabel == _typeFilter;
      final matchGenre  = _genreFilter == 'Tümü' || m.genres.contains(_genreFilter);
      final matchSearch = _search.isEmpty ||
          m.title.toLowerCase().contains(_search.toLowerCase()) ||
          m.director.toLowerCase().contains(_search.toLowerCase());
      return matchType && matchGenre && matchSearch;
    }).toList();

    switch (_sortBy) {
      case 'Puan':   list.sort((a, b) => b.rating.compareTo(a.rating));   break;
      case 'Yeni':   list.sort((a, b) => b.year.compareTo(a.year));       break;
      case 'Popüler': list = [...list.where((m) => m.isPopular), ...list.where((m) => !m.isPopular)]; break;
    }
    return list;
  }

  // ── Tür dropdown ──────────────────────────────────────────────────────────
  void _showTypeMenu(BuildContext context) {
    final opts = ['Tümü', 'Film', 'Dizi'];
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 12),
        const Text('İçerik Türü', style: TextStyle(color: AppTheme.text1, fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        ...opts.map((opt) => ListTile(
          title: Text(opt, style: const TextStyle(color: AppTheme.text1, fontSize: 14)),
          trailing: _typeFilter == opt ? const Icon(Icons.check_rounded, color: AppTheme.primary, size: 20) : null,
          onTap: () { setState(() { _typeFilter = opt; }); Navigator.pop(context); },
        )),
        const SizedBox(height: 12),
      ]),
    );
  }

  // ── Sıralama ──────────────────────────────────────────────────────────────
  void _showSort(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(height: 8),
        Container(width: 36, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 12),
        const Text('Sıralama', style: TextStyle(color: AppTheme.text1, fontSize: 15, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        ...['Puan', 'Yeni', 'Popüler'].map((opt) => ListTile(
          title: Text(opt, style: const TextStyle(color: AppTheme.text1, fontSize: 14)),
          trailing: _sortBy == opt ? const Icon(Icons.check_rounded, color: AppTheme.primary, size: 20) : null,
          onTap: () { setState(() => _sortBy = opt); Navigator.pop(context); },
        )),
        const SizedBox(height: 12),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20, color: AppTheme.text2),
          onPressed: () => Navigator.pop(context),
        ),
  title: const Text('Keşfet'),
        actions: [
          GestureDetector(
            onTap: () => _showSort(context),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.elevated, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppTheme.border)),
              child: Row(children: [
                const Icon(Icons.sort_rounded, size: 16, color: AppTheme.text2),
                const SizedBox(width: 5),
                Text(_sortBy, style: const TextStyle(fontSize: 12, color: AppTheme.text2, fontWeight: FontWeight.w500)),
              ]),
            ),
          ),
        ],
      ),
      body: Column(children: [

        // ── Arama ─────────────────────────────────────────────────────────
        Container(
          color: AppTheme.bg,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Container(
            height: 44,
            decoration: BoxDecoration(color: AppTheme.elevated, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.border)),
            child: TextField(
              controller: _ctrl,
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(fontSize: 14, color: AppTheme.text1),
              decoration: InputDecoration(
                hintText: 'Film, dizi, yönetmen ara...',
                hintStyle: const TextStyle(color: AppTheme.text3, fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppTheme.text3),
                suffixIcon: _search.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.text3),
                        onPressed: () { _ctrl.clear(); setState(() => _search = ''); })
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),

        // ── Filtre satırı: [Dropdown] [Tür chips] ─────────────────────────
        Container(
          color: AppTheme.bg,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tür dropdown butonu
              GestureDetector(
                onTap: () => _showTypeMenu(context),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: _typeFilter != 'Tümü' ? AppTheme.primary : AppTheme.elevated,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _typeFilter != 'Tümü' ? AppTheme.primary : AppTheme.border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      _typeFilter,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _typeFilter != 'Tümü' ? Colors.black : AppTheme.text2,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: _typeFilter != 'Tümü' ? Colors.black : AppTheme.text2,
                    ),
                  ]),
                ),
              ),

              const SizedBox(width: 8),

              // Tür chip'leri — yatay scroll
              Expanded(
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: allGenres.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 7),
                    itemBuilder: (_, i) {
                      final g = allGenres[i];
                      final selected = _genreFilter == g;
                      return GestureDetector(
                        onTap: () => setState(() => _genreFilter = g),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          height: 36,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: selected ? AppTheme.primary.withOpacity(0.15) : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? AppTheme.primary.withOpacity(0.6) : AppTheme.border,
                            ),
                          ),
                          child: Text(
                            g,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                              color: selected ? AppTheme.primary : AppTheme.text2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Sonuç sayısı ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
          child: Row(children: [
            Text('${filtered.length} içerik',
              style: const TextStyle(fontSize: 13, color: AppTheme.text2, fontWeight: FontWeight.w500)),
          ]),
        ),

        // ── Grid ──────────────────────────────────────────────────────────
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.movie_creation_outlined, size: 56, color: AppTheme.text3),
                  SizedBox(height: 12),
                  Text('Sonuç bulunamadı', style: TextStyle(fontSize: 16, color: AppTheme.text2, fontWeight: FontWeight.w600)),
                ]))
              : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.55,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => ListenableBuilder(
                    listenable: widget.watchlist,
                    builder: (_, __) => MovieCard(movie: filtered[i], watchlist: widget.watchlist),
                  ),
                ),
        ),
      ]),
    );
  }
}
