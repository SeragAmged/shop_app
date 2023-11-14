import '../../models/login_model.dart';

abstract class ShopStates {}

class ShopInitialState extends ShopStates {}

class ChangeBottomNavState extends ShopStates {}

//Home
class HomeLoadingState extends ShopStates {}

class HomeSuccessState extends ShopStates {}

class HomeErrorState extends ShopStates {}

//Categories
class CategoriesLoadingState extends ShopStates {}

class CategoriesSuccessState extends ShopStates {}

class CategoriesErrorState extends ShopStates {}

//Favorites
class FavoritesLoadingState extends ShopStates {}

class FavoritesSuccessState extends ShopStates {}

class FavoritesErrorState extends ShopStates {}

//ChangeFavorites
class ChangeFavoritesSuccessState extends ShopStates {}

class ChangeFavoritesErrorState extends ShopStates {}

class FavoritesScreenLoadingState extends ShopStates {}

//User
class UserLoadingState extends ShopStates {}

class UserSuccessState extends ShopStates {}

class UserErrorState extends ShopStates {}

//Update
class UpdateLoadingState extends ShopStates {}

class UpdateSuccessState extends ShopStates {
  final LoginModel updateModel;
  final String message;
  UpdateSuccessState(this.updateModel, this.message);
}

class UpdateErrorState extends ShopStates {
  final String error;
  UpdateErrorState(this.error);
}

class LogoutLoadingState extends ShopStates {}

class LogoutSuccessState extends ShopStates {
  final String message;
  LogoutSuccessState(this.message);
}

class LogoutErrorState extends ShopStates {}
