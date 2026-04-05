import 'package:qaren/features/home/domain/entities/category_entity.dart';
import 'package:qaren/features/home/domain/entities/category_translation.dart';

// ── CategoryTranslationModel ──────────────────── ───────────────────────────────

class CategoryTranslationModel extends CategoryTranslation {
  const CategoryTranslationModel({
    required super.locale,
    required super.name,
    required super.slug,
    required super.description,
  });

  factory CategoryTranslationModel.fromJson(Map<String, dynamic> json) {
    return CategoryTranslationModel(
      locale:      json['locale']      as String? ?? '',
      name:        json['name']        as String? ?? '',
      slug:        json['slug']        as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }
}

// ── CategoryModel ──────────────────────────────────────────────────────────────

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.type,
    required super.icon,
    required super.status,
    required super.translation,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final translation = CategoryTranslationModel.fromJson(
      json['translation'] as Map<String, dynamic>? ?? {},
    );
    return CategoryModel(
      id:          (json['id'] as num).toInt(),
      type:        json['type']   as String? ?? '',
      icon:        json['icon']   as String? ?? '',
      status:      json['status'] as bool?   ?? false,
      translation: translation,
    );
  }
}
