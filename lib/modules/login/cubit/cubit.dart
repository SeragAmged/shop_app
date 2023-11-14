import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/network/remote/end_points.dart';

import '../../../shared/components/variables.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());
  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel? loginModel;

  bool isEn = true;
  langChange() {
    isEn = !isEn;
    lang = isEn ? 'en' : 'ar';
    emit(LoginLangChangeState());
  }

  void userLogin({
    required final String email,
    required final String password,
  }) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: login,
      data: {
        'email': email,
        'password': password,
      },
    ).then(
      (value) {
        loginModel = LoginModel.fromJson(value.data);
        debugPrint("userLogin ${value.data}");
        token = loginModel!.data?.token ?? '';
        emit(LoginSuccessState(loginModel!));
      },
    ).catchError(
      (error) {
        emit(LoginErrorState(error.toString()));
        debugPrint("userLogin $error");
      },
    );
  }

  IconData passwordSuffix = Icons.visibility_outlined;
  bool isPassword = true;
  suffixChange() {
    isPassword = !isPassword;
    passwordSuffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginSuffixChangeState());
  }
}
