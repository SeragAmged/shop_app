import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/favorites_model.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';
import '../../styles/colors.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ShopCubit cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ChangeFavoritesErrorState) {
          defaultSnackBar(
            context: context,
            message: 'Something went wrong!',
            state: ToastState.error,
          );
        }
      },
      builder: (context, state) => ConditionalBuilder(
        condition:
            cubit.favoritesDataModel != null && state is! FavoritesLoadingState,
        builder: (context) => productsScreenBuilder(
          favoritesModel: cubit.favoritesDataModel!,
          context: context,
        ),
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget productsScreenBuilder({
    required FavoritesModel favoritesModel,
    required BuildContext context,
  }) {
    return ConditionalBuilder(
      condition: favoritesModel.data!.data.isNotEmpty,
      builder: (BuildContext context) => ListView.separated(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: favoritesModel.data!.data.length,
        itemBuilder: (context, index) => favoriteItemBuilder(
          product: favoritesModel.data!.data[index].product,
          context: context,
        ),
        separatorBuilder: (context, index) =>
            Container(height: 1, color: Colors.grey),
      ),
      fallback: (BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite,
              size: 100,
              color: Colors.grey,
            ),
            Text(
              'No Favorites',
              style: TextStyle(fontSize: 34, color: Colors.grey[600]),
            )
          ],
        ),
      ),
    );
  }

  Widget favoriteItemBuilder({
    required Product product,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Image(
                    image: NetworkImage(product.image),
                    width: 120,
                    height: 120,
                  ),
                  if (product.discount != 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      color: Colors.red,
                      child: const Text(
                        'Discount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14.0,
                        height: 1.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            '${product.price}L.E.',
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        if (product.discount != 0) const SizedBox(height: 5),
                        if (product.discount != 0)
                          Expanded(
                            child: Text(
                              '${product.oldPrice}L.E.',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        // const Spacer(),
                        // const Icon(
                        //   Icons.add_shopping_cart_rounded,
                        //   size: 30,
                        // ),
                        const SizedBox(width: 10),
                        ShopCubit.get(context).favoritesMap[product.id] ?? false
                            ? GestureDetector(
                                onTap: () {
                                  Feedback.forTap(context);
                                  ShopCubit.get(context).changeFavorites(
                                    product.id,
                                    fromFavScreen: true,
                                  );
                                },
                                child: const Icon(
                                  Icons.favorite_outlined,
                                  color: Colors.redAccent,
                                  size: 30,
                                ),
                              )
                            : SizedBox(
                                height: 25.0,
                                width: 25.0,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
