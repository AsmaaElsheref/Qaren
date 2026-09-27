import 'package:qaren/core/network/apiRoutes/api_routes.dart';
import 'package:qaren/core/network/dioHelper/dio_helper.dart';

import '../models/terms_of_use_content.dart';

class LegalRemoteDataSource {
  const LegalRemoteDataSource();

  Future<TermsOfUseContent> getTermsOfUse({required String locale}) async {
    final response = await DioHelper.getData(
      url: ApiRoutes.termsOfUse,
      query: {'locale': locale == 'ar' ? 'ar' : 'en'},
    );

    return TermsOfUseContent.fromResponse(
      Map<String, dynamic>.from(response.data as Map),
    );
  }
}
