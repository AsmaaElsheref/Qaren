import 'package:equatable/equatable.dart';

class CategoryTranslation extends Equatable {
  final String locale;
  final String name;
  final String slug;
  final String description;

  const CategoryTranslation({
    required this.locale,
    required this.name,
    required this.slug,
    required this.description,
  });

  @override
  List<Object> get props => [locale, name, slug, description];
}

