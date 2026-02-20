/// Single coloring template (one page in a category).
/// Images: templates are stored in `images/Templets/<category-folder>/1.jpg, 2.jpg, ...` or .png
class TemplateItem {
  final String id;
  final String assetPath;
  /// Alternate path for .png (used if .jpg not found)
  final String assetPathPng;
  final String name;

  const TemplateItem({
    required this.id,
    required this.assetPath,
    required this.assetPathPng,
    required this.name,
  });
}

/// Maximum templates per category. Add 1.jpg, 2.jpg, ... up to this number (or .png) in
/// images/Templets/<category>/ and they will show automatically. No code change needed.
const int maxTemplatesPerCategory = 10;

/// Returns template list for a category from images/Templets/<category-folder>/1.jpg, 2.jpg, ... (or .png)
List<TemplateItem> getTemplatesForCategory(String categoryKey) {
  final folder = _templetsFolder(categoryKey);
  return List.generate(maxTemplatesPerCategory, (i) {
    final num = i + 1;
    return TemplateItem(
      id: '${categoryKey}_$num',
      name: '${_categoryLabel(categoryKey)} $num',
      assetPath: 'images/Templets/$folder/$num.jpg',
      assetPathPng: 'images/Templets/$folder/$num.png',
    );
  });
}

String _categoryLabel(String key) {
  const m = {
    'animals': 'Animal',
    'dinosaurs': 'Dinosaur',
    'princess': 'Princess',
    'transport': 'Vehicle',
    'sea': 'Sea',
    'robots': 'Robot',
    'aliens': 'Alien',
    'christmas': 'Christmas',
    'nature': 'Nature',
    'food': 'Food',
    'fantasy': 'Fantasy',
    // 'sports': 'Sport',
    // 'places': 'Place',
  };
  return m[key] ?? key;
}

String _templetsFolder(String categoryKey) {
  // Most categories use the same folder name as their key.
  // One exception in this app: key 'sea' -> folder 'sea-creatures'.
  if (categoryKey == 'sea') return 'sea-creatures';
  return categoryKey;
}
