import 'package:flutter/material.dart';

class RecipeCardWidget extends StatefulWidget {
  final Map<String, dynamic> recipeData;
  const RecipeCardWidget({super.key, required this.recipeData});

  @override
  State<RecipeCardWidget> createState() => _RecipeCardWidgetState();
}

class _RecipeCardWidgetState extends State<RecipeCardWidget> {
  late List<bool> _checked;

  @override
  void initState() {
    super.initState();
    final ingredients = widget.recipeData['ingredients'] as List<dynamic>? ?? [];
    _checked = List<bool>.filled(ingredients.length, false);
  }

  @override
  Widget build(BuildContext context) {
    final time = widget.recipeData['time'] ?? '15 minutes prep';
    final title = widget.recipeData['title'] ?? 'Generated Recipe';
    final description = widget.recipeData['description'] ?? '';
    final ingredients = widget.recipeData['ingredients'] as List<dynamic>? ?? [];
    final steps = widget.recipeData['steps'] as List<dynamic>? ?? [];

    const darkBlue = Color(0xFF1C2331);
    const greenText = Color(0xFF2E7D32);
    const lightGreen = Color(0xFFE8F5E9);

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 16, right: 16, left: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: darkBlue, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.restaurant_menu, color: greenText),
                  const SizedBox(width: 8),
                  const Text(
                    '✨ AI Meal Planner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: darkBlue,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.close, color: Colors.grey.shade400, size: 20),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Time Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: const Color(0xFFC8E6C9)),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(
                        color: greenText,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: darkBlue,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF616161),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredients Header
                  const Row(
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: greenText, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Ingredients to Buy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: darkBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ingredients List
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: List.generate(ingredients.length, (index) {
                        return CheckboxListTile(
                          value: _checked.length > index ? _checked[index] : false,
                          onChanged: (val) {
                            setState(() {
                              if (_checked.length > index) {
                                _checked[index] = val ?? false;
                              }
                            });
                          },
                          title: Text(
                            ingredients[index].toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF424242),
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: greenText,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                          dense: true,
                          visualDensity: VisualDensity.compact,
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Steps
                  ...List.generate(steps.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: lightGreen,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: greenText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              steps[index].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF616161),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Items added to cart!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        '+ Add All to Cart ✨',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
