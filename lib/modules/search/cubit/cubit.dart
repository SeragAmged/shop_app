import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/shared/components/variables.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

import '../../../models/search_model.dart';
import '../../../shared/network/remote/end_points.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());
  static SearchCubit get(context) => BlocProvider.of(context);

  late SearchModel searchModel;
  void searchProduct(String text) {
    emit(SearchLoadingState());
    DioHelper.postData(
      url: search,
      token: token,
      data: {
        'text': text,
      },
    ).then(
      (value) {
        searchModel = SearchModel.fromJson(value.data);
        emit(SearchSuccessState());
      },
    ).catchError(
      (onError) {
        emit(SearchErrorState());
        debugPrint(onError);
      },
    );
  }
}
