// lib/screens/category_section.dart
import 'package:flutter/material.dart';
import 'package:shopzy/utils/app_colors.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

// ✅ FIX: Changed to StatefulWidget so we can:
// 1. Properly manage TextEditingController lifecycle (no memory leak)
// 2. Add real search/filter functionality
class _CategorySectionState extends State<CategorySection> {
  late final TextEditingController _searchController;
  String _query = '';

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Fresh Fruits',
      'image': 'https://cf-img-a-in.tosshub.com/sites/visualstory/wp/2023/10/fruits-pics.jpg',
      'color': const Color(0xFFFF6B6B),
      'icon': Icons.apple_rounded,
      'count': '120+ items',
    },
    {
      'name': 'Vegetables',
      'image': 'https://wallpaperaccess.com/full/5502189.jpg',
      'color': const Color(0xFF51CF66),
      'icon': Icons.eco_rounded,
      'count': '95+ items',
    },
    {
      'name': 'Dairy & Eggs',
      'image': 'https://imgcdn.stablediffusionweb.com/2024/4/4/06c5ccfd-4a38-4b32-8e50-4002c4b19469.jpg',
      'color': const Color(0xFFFFD43B),
      'icon': Icons.egg_alt_outlined,
      'count': '45+ items',
    },
    {
      'name': 'Snacks',
      'image': 'https://res.cloudinary.com/nassau-candy/image/upload/f_auto,q_auto/c_fit,w_1024/v1671482968/blog/Bite-Sized-Big-Indulgence_D1.png',
      'color': const Color(0xFFFF922B),
      'icon': Icons.cookie_outlined,
      'count': '200+ items',
    },
    {
      'name': 'Beverages',
      'image': 'https://www.mashed.com/img/gallery/bottled-and-canned-starbucks-drinks-ranked-worst-to-best/l-intro-1685556735.jpg',
      'color': const Color(0xFF339AF0),
      'icon': Icons.local_drink_outlined,
      'count': '80+ items',
    },
    {
      'name': 'Bakery',
      'image': 'https://www.rukita.co/stories/wp-content/uploads/2019/11/Union-Jakarta.jpg',
      'color': const Color(0xFFE67700),
      'icon': Icons.bakery_dining_outlined,
      'count': '60+ items',
    },
    {
      'name': 'Meat & Fish',
      'image': 'https://thumbs.dreamstime.com/z/assortment-meat-seafood-beef-chicken-fish-pork-153900529.jpg',
      'color': const Color(0xFFE64980),
      'icon': Icons.set_meal_outlined,
      'count': '55+ items',
    },
    {
      'name': 'Pantry',
      'image': 'https://4c22abc93d7c2dd8c7b0-f3fc2380882bf5ef4c50da076616259d.ssl.cf1.rackcdn.com/WEB_14_55Cans2_44A6860.jpg',
      'color': const Color(0xFF845EF7),
      'icon': Icons.kitchen_outlined,
      'count': '150+ items',
    },
    {
      'name': 'Kitchen & Dining',
      'image': 'https://dwellplus.com/wp-content/uploads/kitchen-products.jpg',
      'color': const Color(0xFF20C997),
      'icon': Icons.dining_outlined,
      'count': '75+ items',
    },
    {
      'name': 'Personal Care',
      'image': 'https://i.pinimg.com/originals/7c/e2/15/7ce215e1e3863d668fdf8ff16afba951.jpg',
      'color': const Color(0xFFF783AC),
      'icon': Icons.spa_outlined,
      'count': '110+ items',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // ✅ Live search — filter categories as user types
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    // ✅ FIX: Properly dispose controller — original code never disposed it
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_query.isEmpty) return _categories;
    return _categories
        .where((c) =>
        (c['name'] as String).toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      body: CustomScrollView(
        slivers: [
          // ── App bar ──────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Categories',
              style: TextStyle(
                color: AppColors.textCharcoal,
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            centerTitle: false,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Padding(
                padding:
                const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _SearchBar(controller: _searchController),
              ),
            ),
          ),

          // ── Results count ────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    '${filtered.length} categories',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  if (_query.isNotEmpty) ...[
                    const Text(' for '),
                    Text(
                      '"$_query"',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Grid ─────────────────────────────────────────────
          filtered.isEmpty
              ? SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off_rounded,
                      size: 56,
                      color: AppColors.secondaryText
                          .withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'No categories found',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
          )
              : SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.82,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) =>
                  _CategoryCard(category: filtered[index]),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 120),
          ),
        ],
      ),
    );
  }
}

// ── Search bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100, width: 1.5),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Search categories...',
          hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
              fontWeight: FontWeight.w400),
          prefixIcon: Icon(Icons.search_rounded,
              color: Colors.grey.shade400, size: 20),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) => value.text.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.close_rounded,
                  color: Colors.grey.shade400, size: 18),
              onPressed: () => controller.clear(),
            )
                : const SizedBox.shrink(),
          ),
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        ),
      ),
    );
  }
}

// ── Category card ─────────────────────────────────────────────────────────────
class _CategoryCard extends StatelessWidget {
  final Map<String, dynamic> category;
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final color = category['color'] as Color;

    return GestureDetector(
      onTap: () {}, // wire up to category detail screen
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Background image ────────────────────────────
              Image.network(
                category['image'] as String,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    color: color.withOpacity(0.1),
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: color,
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  color: color.withOpacity(0.1),
                  child: Icon(category['icon'] as IconData,
                      color: color, size: 40),
                ),
              ),

              // ── Dark gradient overlay ───────────────────────
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.72),
                      Colors.black.withOpacity(0.1),
                    ],
                    stops: const [0.0, 0.65],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),

              // ── Color tint at top ───────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  color: color,
                ),
              ),

              // ── Text content ────────────────────────────────
              Positioned(
                bottom: 14,
                left: 14,
                right: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✨ Item count pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category['count'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        shadows: [
                          Shadow(blurRadius: 6, color: Colors.black54)
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Arrow indicator ─────────────────────────────
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}