import 'package:flutter/material.dart';

/// Categories for template selection - Bimi Boo style (11 themes).
class Category {
  final String key;
  final String name;
  final String assetIcon;
  final Color color;
  final bool isLocked;
  final String categoryImagePath; // Path to category background image
  final String backgroundImagePath; // Category page background image (Templets/*-background.png)

  const Category({
    required this.key,
    required this.name,
    required this.assetIcon,
    required this.color,
    this.isLocked = false,
    required this.categoryImagePath,
    required this.backgroundImagePath,
  });
}

// Predefined categories - icons are asset names
// Category images should be placed in: images/Templets/{category_key}/templates/thumbnail.png
// Example: images/Templets/animals/templates/thumbnail.png

// Categories ordered as per the second image: aliens, animals, christmas, dinosaurs, fantasy, food, nature, princess, robots, sea-creatures, transport
// Each category has a unique color for its name display
final List<Category> categories = [
  Category(
    key: 'aliens',
    name: 'aliens',
    assetIcon: 'aliens',
    color: Color(0xFF9C27B0), // Purple for aliens
    isLocked: false,
    categoryImagePath: 'images/Templets/aliens/aliens-thumbnail.png',
    backgroundImagePath: 'images/Templets/aliens/aliens-background.png',
  ),
  Category(
    key: 'animals',
    name: 'animals',
    assetIcon: 'animals',
    color: Color(0xFF4CAF50), // Green for animals
    isLocked: false,
    categoryImagePath: 'images/Templets/animals/animals-thumbnail.png',
    backgroundImagePath: 'images/Templets/animals/animal-background.png',
  ),
  Category(
    key: 'christmas',
    name: 'christmas',
    assetIcon: 'christmas',
    color: Color(0xFFF44336), // Red for christmas
    isLocked: false,
    categoryImagePath: 'images/Templets/christmas/christmas-thumbnail.png',
    backgroundImagePath: 'images/Templets/christmas/chritsmas-background.png',
  ),
  Category(
    key: 'dinosaurs',
    name: 'dinosaurs',
    assetIcon: 'dinosaurs',
    color: Color(0xFFFF7043), // Orange for dinosaurs
    isLocked: false,
    categoryImagePath: 'images/Templets/dinosaurs/dinosaurs-thumbnail.png',
    backgroundImagePath: 'images/Templets/dinosaurs/dinosaurs-background.png',
  ),
  Category(
    key: 'fantasy',
    name: 'fantasy',
    assetIcon: 'fantasy',
    color: Color(0xFF673AB7), // Deep purple for fantasy
    isLocked: false,
    categoryImagePath: 'images/Templets/fantasy/fantasythumbnail.png',
    backgroundImagePath: 'images/Templets/fantasy/fantasy-background.png',
  ),
  Category(
    key: 'food',
    name: 'food',
    assetIcon: 'food',
    color: Color(0xFFFF9800), // Orange for food
    isLocked: false,
    categoryImagePath: 'images/Templets/food/food-thumbnail.png',
    backgroundImagePath: 'images/Templets/food/food-background.png',
  ),
  Category(
    key: 'nature',
    name: 'nature',
    assetIcon: 'nature',
    color: Color(0xFF4CAF50), // Green for nature
    isLocked: false,
    categoryImagePath: 'images/Templets/nature/nature-thumbnail.png',
    backgroundImagePath: 'images/Templets/nature/nature-background.png',
  ),
  Category(
    key: 'princess',
    name: 'princess',
    assetIcon: 'princess',
    color: Color(0xFFE91E63), // Pink for princess
    isLocked: false,
    categoryImagePath: 'images/Templets/princess/princess-thumbnail.png',
    backgroundImagePath: 'images/Templets/princess/princess-background.png',
  ),
  Category(
    key: 'robots',
    name: 'robots',
    assetIcon: 'robots',
    color: Color(0xFF607D8B), // Blue grey for robots
    isLocked: false,
    categoryImagePath: 'images/Templets/robots/robot-thumbnail.png',
    backgroundImagePath: 'images/Templets/robots/robots-background.png',
  ),
  Category(
    key: 'sea',
    name: 'sea-creatures',
    assetIcon: 'sea',
    color: Color(0xFF00BCD4), // Cyan for sea-creatures
    isLocked: false,
    categoryImagePath: 'images/Templets/sea-creatures/sea-creatures-thumbnail.png',
    backgroundImagePath: 'images/Templets/sea-creatures/sea-creatures-background.png',
  ),
  Category(
    key: 'transport',
    name: 'transport',
    assetIcon: 'transport',
    color: Color(0xFF2196F3), // Blue for transport
    isLocked: false,
    categoryImagePath: 'images/Templets/transport/transport-thumbnail.png',
    backgroundImagePath: 'images/Templets/transport/transport-background.png',
  ),
];
