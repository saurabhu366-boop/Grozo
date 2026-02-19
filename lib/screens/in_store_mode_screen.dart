// lib/screens/in_store_mode_screen.dart
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shopzy/data/mock_database.dart';
import 'package:shopzy/models/grocery_item.dart';
import 'package:shopzy/services/cart_service.dart';
import 'package:shopzy/services/shopping_route_service.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/custom_text_field.dart';

// --- Data Model for the Store Layout ---
class StoreDepartment {
  final String name;
  final int aisle;
  final IconData icon;

  StoreDepartment({required this.name, required this.aisle, required this.icon});
}

class InStoreModeScreen extends StatefulWidget {
  const InStoreModeScreen({super.key});

  @override
  State<InStoreModeScreen> createState() => _InStoreModeScreenState();
}

class _InStoreModeScreenState extends State<InStoreModeScreen> with SingleTickerProviderStateMixin {
  final CartService _cartService = CartService();
  final ShoppingRouteService _routeService = ShoppingRouteService();
  final TextEditingController _searchController = TextEditingController();
  final TransformationController _mapTransformationController = TransformationController();

  late List<GroceryItem> _sortedList;
  int _currentItemIndex = 0;
  final Set<String> _foundItems = {};
  Set<int> _searchResultAisles = {};
  int _currentUserAisle = 0; // 0 represents the entrance
  bool _isMapVisible = true;
  int? _focusedAisle;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // --- Fictional Store Layout ---
  final List<StoreDepartment> storeLayout = [
    StoreDepartment(name: 'Beverages & Dairy', aisle: 1, icon: Icons.local_drink_outlined),
    StoreDepartment(name: 'Fresh Produce', aisle: 2, icon: Icons.eco_outlined),
    StoreDepartment(name: 'Bakery & Breads', aisle: 3, icon: Icons.bakery_dining_outlined),
    StoreDepartment(name: 'Snacks & Pantry', aisle: 4, icon: Icons.ramen_dining_outlined),
    StoreDepartment(name: 'Meat & Fish', aisle: 5, icon: Icons.set_meal_outlined),
    StoreDepartment(name: 'Frozen Foods', aisle: 6, icon: Icons.ac_unit_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _sortedList = _routeService.getOptimalRoute(_cartService.items);
    if (_sortedList.isNotEmpty) {
      _currentUserAisle = _sortedList.first.aisle;
    }
    _searchController.addListener(_performSearch);

    // Initialize controller first
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Then, initialize the animation that depends on it
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    // Finally, start the animation
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.removeListener(_performSearch);
    _searchController.dispose();
    _pulseController.dispose();
    _mapTransformationController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text;
    if (query.isEmpty) {
      setState(() {
        _searchResultAisles = {};
      });
      return;
    }
    final results = MockDatabase.searchItems(query);
    setState(() {
      _focusedAisle = null; // Close detail view on search
      _searchResultAisles = results.map((item) => item.aisle).toSet();
    });
  }

  bool get _isShoppingComplete => _sortedList.isNotEmpty && _currentItemIndex >= _sortedList.length;

  void _findNextItem() {
    if (_isShoppingComplete) return;
    setState(() {
      _foundItems.add(_sortedList[_currentItemIndex].barcode);
      _currentItemIndex++;
      _focusedAisle = null;
      if (!_isShoppingComplete) {
        _currentUserAisle = _sortedList[_currentItemIndex].aisle;
      } else {
        _currentUserAisle = 0; // Go to exit
      }
      // Clear search to resume shopping list guidance
      _searchController.clear();
      _searchResultAisles = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
      child: Scaffold(
        appBar: AppBar(
          title: const Text('In-Store Mode'),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('End', style: TextStyle(color: AppColors.primary)),
            )
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_sortedList.isEmpty) {
      return _buildEmptyListShoppingView();
    } else if (_isShoppingComplete) {
      return _buildCompletionView();
    } else {
      return _buildShoppingView();
    }
  }

  Widget _buildEmptyListShoppingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildStoreLayoutMap(),
          const SizedBox(height: 16),
          if (_searchResultAisles.isEmpty && _focusedAisle == null)
            _buildEmptyListMessage()
          else
            _buildSearchResultsView(),
        ],
      ),
    );
  }

  Widget _buildShoppingView() {
    final currentItem = _sortedList[_currentItemIndex];
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 16),
          _buildStoreLayoutMap(),
          const SizedBox(height: 16),
          if (_searchResultAisles.isEmpty && _focusedAisle == null) ...[
            _buildNextItemCard(currentItem),
            const Divider(height: 32, indent: 20, endIndent: 20),
            _buildShoppingListHeader(),
            _buildShoppingListView(),
          ] else if (_focusedAisle == null)
            _buildSearchResultsView(),
        ],
      ),
    );
  }

  Widget _buildEmptyListMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Card(
        color: AppColors.secondarySurface,
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Your shopping list is empty. Tap an aisle or use the search bar to find items!',
                  style: TextStyle(color: AppColors.textCharcoal, fontWeight: FontWeight.w500, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CustomTextField(
        controller: _searchController,
        hintText: 'Search for any product or category...',
        prefixIcon: Icons.search_outlined,
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon: const Icon(Icons.clear, color: AppColors.secondaryText),
          onPressed: () {
            _searchController.clear();
            FocusScope.of(context).unfocus();
          },
        )
            : null,
      ),
    );
  }

  Widget _buildStoreLayoutMap() {
    final int currentListItemAisle = _isShoppingComplete || _sortedList.isEmpty ? -1 : _sortedList[_currentItemIndex].aisle;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isMapVisible = !_isMapVisible;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Grozo store 3D Map",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      _isMapVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: AppColors.secondaryText,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ClipRect(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _isMapVisible
                  ? Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return InteractiveViewer(
                        transformationController: _mapTransformationController,
                        minScale: 0.5,
                        maxScale: 3.0,
                        boundaryMargin: const EdgeInsets.all(double.infinity),
                        child: Transform(
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // perspective
                            ..rotateX(-0.8), // angle
                          alignment: FractionalOffset.center,
                          child: Container(
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            padding: const EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Stack(
                              clipBehavior: Clip.none, // Allow overflow for the 'ENTRANCE' label
                              children: [
                                // --- AISLES ---
                                _buildAisle(1, constraints, 0.05, 0.65, currentListItemAisle), // Beverages & Dairy
                                _buildAisle(2, constraints, 0.05, 0.1, currentListItemAisle), // Fresh Produce
                                _buildAisle(3, constraints, 0.35, 0.65, currentListItemAisle), // Bakery & Breads
                                _buildAisle(4, constraints, 0.35, 0.1, currentListItemAisle), // Snacks & Pantry
                                _buildAisle(5, constraints, 0.65, 0.65, currentListItemAisle), // Meat & Fish
                                _buildAisle(6, constraints, 0.65, 0.1, currentListItemAisle), // Frozen Foods

                                // --- USER MARKER ---
                                _buildUserMarker(constraints),

                                // --- ENTRANCE ---
                                Positioned(
                                    bottom: -15, left: 0, right: 0,
                                    child: Transform(
                                      transform: Matrix4.rotationX(1.0),
                                      alignment: Alignment.center,
                                      child: const Text('ENTRANCE', style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold)),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ),
          _buildAisleDetailCard(),
        ],
      ),
    );
  }

  Widget _buildAisleDetailCard() {
    final bool isVisible = _focusedAisle != null;
    if (!isVisible) return const SizedBox.shrink();

    final department = storeLayout.firstWhere((d) => d.aisle == _focusedAisle);
    final itemsInAisle = MockDatabase.items.values.where((item) => item.aisle == _focusedAisle).toList();

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: isVisible
          ? Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Aisle $_focusedAisle",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      department.name,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close, color: AppColors.secondaryText),
                  onPressed: () => setState(() => _focusedAisle = null),
                )
              ],
            ),
            const Divider(height: 24),
            if (itemsInAisle.isEmpty)
              const Center(child: Text('No specific items listed for this aisle.', style: TextStyle(color: AppColors.secondaryText)))
            else
              SizedBox(
                height: 150,
                child: ListView.builder(
                  itemCount: itemsInAisle.length,
                  itemBuilder: (context, index) {
                    final item = itemsInAisle[index];
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      leading: SizedBox(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            item.imagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(color: Colors.grey.shade200, child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey));
                            },
                          ),
                        ),
                      ),
                      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    );
                  },
                ),
              )
          ],
        ),
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildAisle(int aisleNum, BoxConstraints constraints, double topFactor, double leftFactor, int currentListItemAisle) {
    bool isHighlightedByShoppingList = _searchResultAisles.isNotEmpty
        ? _searchResultAisles.contains(aisleNum)
        : aisleNum == currentListItemAisle;
    bool isFaded = _focusedAisle != null && _focusedAisle != aisleNum;
    bool isHighlighted = _focusedAisle == aisleNum || (_focusedAisle == null && isHighlightedByShoppingList);

    final department = storeLayout.firstWhere((d) => d.aisle == aisleNum);

    return Positioned(
      top: constraints.maxHeight * topFactor,
      left: constraints.maxWidth * leftFactor,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _focusedAisle = _focusedAisle == aisleNum ? null : aisleNum;
            // Clear search when aisle is tapped
            _searchController.clear();
            _searchResultAisles = {};
          });
        },
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isFaded ? 0.4 : 1.0,
          child: IgnorePointer(
            ignoring: isFaded,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform: Matrix4.translationValues(0, isHighlighted ? -8 : 0, 0),
              transformAlignment: Alignment.center,
              child: Column(
                children: [
                  Transform(
                      transform: Matrix4.rotationX(0.8),
                      alignment: Alignment.bottomCenter,
                      child: Text(department.name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isHighlighted ? AppColors.primary : AppColors.secondaryText))
                  ),
                  const SizedBox(height: 5),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: constraints.maxWidth * 0.25,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isHighlighted
                            ? [AppColors.primary.withOpacity(0.2), AppColors.primary.withOpacity(0.05)]
                            : [Colors.white, Colors.grey.shade200],
                        stops: const [0.0, 1.0],
                      ),
                      border: Border.all(
                        color: isHighlighted ? AppColors.primary : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: isHighlighted ? [
                        BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 20, spreadRadius: 3, offset: const Offset(0, 5)),
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 10))
                      ] : [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 10))
                      ],
                    ),
                    child: Center(
                      child: Transform(
                        transform: Matrix4.rotationX(0.8),
                        alignment: Alignment.center,
                        child: Text(
                          '$aisleNum',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isHighlighted
                                ? AppColors.primary
                                : AppColors.secondaryText.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserMarker(BoxConstraints constraints) {
    // Map aisle number to its position factors
    const Map<int, List<double>> aislePositions = {
      1: [0.05, 0.65], 2: [0.05, 0.1],
      3: [0.35, 0.65], 4: [0.35, 0.1],
      5: [0.65, 0.65], 6: [0.65, 0.1],
    };

    final position = aislePositions[_currentUserAisle] ?? [0.9, 0.37]; // Default to entrance area if not found

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      top: constraints.maxHeight * position[0] + 15 - 5, // Center the marker
      left: constraints.maxWidth * position[1] + (constraints.maxWidth * 0.25 / 2) - 15, // Center the marker
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.4),
              ),
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade700,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsView() {
    if (_searchController.text.isNotEmpty && _searchResultAisles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: AppColors.secondaryText),
              SizedBox(height: 16),
              Text(
                'No results found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textCharcoal),
              ),
              Text(
                'Try searching for another item or category.',
                style: TextStyle(color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
      );
    }

    final departmentsFound = storeLayout.where((d) => _searchResultAisles.contains(d.aisle)).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Found in ${_searchResultAisles.length} aisle(s)',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        ...departmentsFound.map((dept) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: ListTile(
            leading: Icon(dept.icon, color: AppColors.primary),
            title: Text(dept.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Aisle ${dept.aisle}'),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildNextItemCard(GroceryItem item) {
    final departmentName = storeLayout.firstWhere((d) => d.aisle == item.aisle).name;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          Card(
            elevation: 0,
            color: AppColors.primary.withOpacity(0.05),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: AppColors.primary.withOpacity(0.3))
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(item.imagePath, width: 60, height: 60, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Next on your list:', style: TextStyle(color: AppColors.secondaryText, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(
                          item.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppColors.textCharcoal),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Head to $departmentName',
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _findNextItem,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Found Item'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingListHeader() {
    final remaining = _sortedList.length - _currentItemIndex;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Shopping List',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            '$remaining items remaining',
            style: const TextStyle(color: AppColors.secondaryText),
          )
        ],
      ),
    );
  }

  Widget _buildShoppingListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: _sortedList.length,
      itemBuilder: (context, index) {
        final item = _sortedList[index];
        final isFound = _foundItems.contains(item.barcode);
        final isCurrent = index == _currentItemIndex;
        return Opacity(
          opacity: isFound ? 0.5 : 1.0,
          child: Card(
            color: isCurrent ? AppColors.primary.withOpacity(0.05) : AppColors.secondarySurface,
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Text(
                'Aisle ${item.aisle}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              title: Text(
                item.name,
                style: TextStyle(
                  color: AppColors.textCharcoal,
                  decoration: isFound ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              trailing: isFound ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompletionView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline_rounded, color: AppColors.primary, size: 100),
            const SizedBox(height: 24),
            const Text(
              'Shopping Complete!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'You have found all items on your list.',
              style: TextStyle(fontSize: 16, color: AppColors.secondaryText),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Go to Cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}