// lib/screens/category_section.dart
import 'package:flutter/material.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/custom_text_field.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {
        'name': 'Fresh Fruits',
        'image': 'https://cf-img-a-in.tosshub.com/sites/visualstory/wp/2023/10/fruits-pics.jpg'
      },
      {
        'name': 'Vegetables',
        'image': 'https://wallpaperaccess.com/full/5502189.jpg'
      },
      {
        'name': 'Dairy & Eggs',
        'image': 'https://imgcdn.stablediffusionweb.com/2024/4/4/06c5ccfd-4a38-4b32-8e50-4002c4b19469.jpg'
      },
      {
        'name': 'Snacks',
        'image': 'https://res.cloudinary.com/nassau-candy/image/upload/f_auto,q_auto/c_fit,w_1024/v1671482968/blog/Bite-Sized-Big-Indulgence_D1.png'
      },
      {
        'name': 'Beverages',
        'image': 'https://www.mashed.com/img/gallery/bottled-and-canned-starbucks-drinks-ranked-worst-to-best/l-intro-1685556735.jpg'
      },
      {
        'name': 'Bakery',
        'image': 'https://www.rukita.co/stories/wp-content/uploads/2019/11/Union-Jakarta.jpg'
      },
      {
        'name': 'Meat & Fish',
        'image': 'https://thumbs.dreamstime.com/z/assortment-meat-seafood-beef-chicken-fish-pork-153900529.jpg'
      },
      {
        'name': 'Pantry',
        'image': 'https://4c22abc93d7c2dd8c7b0-f3fc2380882bf5ef4c50da076616259d.ssl.cf1.rackcdn.com/WEB_14_55Cans2_44A6860.jpg'
      },
      {
        'name': 'Kitchen and Dining',
        'image': 'https://dwellplus.com/wp-content/uploads/kitchen-products.jpg'
      },
      {
        'name': 'Personal Care & Beauty',
        'image': 'https://i.pinimg.com/originals/7c/e2/15/7ce215e1e3863d668fdf8ff16afba951.jpg'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Categories"),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: CustomTextField(
                controller: TextEditingController(),
                hintText: 'Search for products...',
                prefixIcon: Icons.search,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.85,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () {},
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            category['image'] as String,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.broken_image, color: AppColors.secondaryText));
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                                stops: const [0.0, 0.5],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            left: 16,
                            right: 16,
                            child: Text(
                              category['name'] as String,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(blurRadius: 4, color: Colors.black54)
                                  ]
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 100), // Padding for the bottom navigation bar
          ),
        ],
      ),
    );
  }
}