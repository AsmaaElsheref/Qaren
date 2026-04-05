import 'package:equatable/equatable.dart';
import 'category_translation.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String type;
  final String icon;
  final bool status;
  final CategoryTranslation translation;

  const CategoryEntity({
    required this.id,
    required this.type,
    required this.icon,
    required this.status,
    required this.translation,
  });

  /// Convenience getters — derived from translation, no duplication.
  String get name        => translation.name;
  String get description => translation.description;
  String get slug        => translation.slug;

  @override
  List<Object> get props => [id, type, icon, status, translation];
}

