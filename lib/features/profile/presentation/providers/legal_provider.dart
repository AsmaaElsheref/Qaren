import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/legal_remote_data_source.dart';
import '../../data/models/terms_of_use_content.dart';

final legalRemoteDataSourceProvider = Provider<LegalRemoteDataSource>(
  (_) => const LegalRemoteDataSource(),
);

final termsOfUseProvider = FutureProvider.autoDispose
    .family<TermsOfUseContent, String>((ref, locale) {
      return ref
          .watch(legalRemoteDataSourceProvider)
          .getTermsOfUse(locale: locale);
    });
