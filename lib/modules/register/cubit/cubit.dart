import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/register/cubit/states.dart';

import '../../../models/login_model.dart';
import '../../../shared/network/remote/dio_helper.dart';
import '../../../shared/network/remote/end_points.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(BuildContext context) => BlocProvider.of(context);

  bool isEn = true;
  langChange() {
    isEn = !isEn;
    lang = isEn ? 'en' : 'ar';
    emit(RegisterLangChangeState());
  }

  IconData passwordSuffix = Icons.visibility_outlined;
  bool isPassword = true;
  suffixChange() {
    isPassword = !isPassword;
    passwordSuffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterSuffixChangeState());
  }

  late LoginModel registerModel;
  void userRegister({
    required final String email,
    required final String password,
    required final String name,
    required final String phone,
  }) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: register,
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    ).then(
      (value) {
        registerModel = LoginModel.fromJson(value.data);
        
        emit(RegisterSuccessState(registerModel));
      },
    ).catchError(
      (error) {
        emit(RegisterErrorState(error.toString()));

        debugPrint(error.toString());
      },
    );
  }
}
