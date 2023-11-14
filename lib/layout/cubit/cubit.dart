import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'states.dart';
import '../../models/categories_model.dart';
import '../../models/change_favorites_model.dart';
import '../../models/home_model.dart';
import '../../modules/favorites/favorites_screen.dart';
import '../../modules/products/products_screen.dart';
import '../../modules/settings/settings_screen.dart';
import '../../shared/network/remote/dio_helper.dart';
import '../../models/favorites_model.dart';
import '../../modules/categories/categories_screen.dart';
import '../../shared/components/variables.dart';
import '../../shared/network/remote/end_points.dart';

class ShopCubit extends Cubit<ShopStates> {
  ShopCubit() : super(ShopInitialState());
  static ShopCubit get(BuildContext context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> bottomNvaScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  Map<int, bool> favoritesMap = {};
  HomeModel? homeModel;
  void getHomeModelData() {
    emit(HomeLoadingState());
    DioHelper.getData(
      url: home,
      token: token,
    ).then(
      (value) {
        homeModel = HomeModel.fromJson(value.data);
        for (var product in homeModel!.data.products) {
          favoritesMap.addAll({product.id: product.inFavorites});
        }
        emit(HomeSuccessState());
      },
    ).catchError(
      (onError) {
        debugPrint("getHomeModelData $onError");
        emit(HomeErrorState());
      },
    );
  }

  CategoriesModel? categoriesModel;
  void getCategoriesModel() {
    emit(CategoriesLoadingState());
    DioHelper.getData(
      url: categories,
    ).then(
      (value) {
        categoriesModel = CategoriesModel.fromJson(value.data);
        emit(CategoriesSuccessState());
      },
    ).catchError(
      (onError) {
        debugPrint("getCategoriesModel $onError");
        emit(CategoriesErrorState());
      },
    );
  }

  ChangeFavoritesModel? changeFavoritesModel;
  void changeFavorites(int id, {bool fromFavScreen = false}) {
    fromFavScreen
        ? emit(FavoritesScreenLoadingState())
        : emit(FavoritesLoadingState());
    favoritesMap[id] = !favoritesMap[id]!;
    DioHelper.postData(
      url: favorites,
      data: {
        "product_id": id,
      },
      token: token,
    ).then(
      (value) {
        changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
        if (!(changeFavoritesModel!.status)) {
          favoritesMap[id] = !favoritesMap[id]!;
          emit(ChangeFavoritesErrorState());
        } else {
          emit(ChangeFavoritesSuccessState());
          getFavoritesModel(fromScreen: fromFavScreen);
        }
      },
    ).catchError(
      (onError) {
        favoritesMap[id] = !favoritesMap[id]!;
        debugPrint('changeFavorites error: $onError');
        emit(ChangeFavoritesErrorState());
      },
    );
  }

  FavoritesModel? favoritesDataModel;
  void getFavoritesModel({bool fromScreen = false}) {
    if (!fromScreen) emit(FavoritesLoadingState());
    DioHelper.getData(
      url: favorites,
      token: token,
    ).then(
      (value) {
        favoritesDataModel = FavoritesModel.fromJson(value.data);
        emit(FavoritesSuccessState());
        debugPrint("favorites message : ${favoritesDataModel!.status}");
      },
    ).catchError(
      (error) {
        debugPrint(error.toString());
        emit(FavoritesErrorState());
      },
    );
  }

  LoginModel? userModel;
  void getUserModel() {
    emit(UserLoadingState());
    DioHelper.getData(
      url: profile,
      token: token,
    ).then(
      (value) {
        userModel = LoginModel.fromJson(value.data);

        emit(UserSuccessState());
      },
    ).catchError(
      (error) {
        debugPrint('ShopErrorUserDataState $error');
        emit(UserErrorState());
      },
    );
  }

  void userUpdate({
    required final String email,
    required final String name,
    required final String phone,
  }) {
    emit(UpdateLoadingState());
    DioHelper.putData(
      url: updateProfile,
      data: {
        'email': email,
        'name': name,
        'phone': phone,
      },
      token: token,
    ).then(
      (value) {
        if (value.data['status']!) {
          userModel = LoginModel.fromJson(value.data);
          debugPrint(value.data.toString());
          emit(UpdateSuccessState(userModel!, value.data['message']));
        } else {
          emit(UpdateErrorState(value.data['message']));
        }
      },
    ).catchError(
      (error) {
        emit(UpdateErrorState(error));

        debugPrint(error.toString());
      },
    );
  }

  void userLogout({required final String token}) {
    emit(LogoutLoadingState());
    DioHelper.postData(
      url: logout,
      data: {
        'token': token,
      },
      token: token,
    ).then((value) {
      emit(LogoutSuccessState(value.data['message']));
      debugPrint(value.data['message']);
    }).catchError((onError) {
      debugPrint(onError.toString());
      emit(LogoutErrorState());
    });
  }
}
