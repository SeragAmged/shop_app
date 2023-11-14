import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import '../../models/categories_model.dart';
import '../../models/home_model.dart';
import '../../styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    ShopCubit cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ChangeFavoritesErrorState) {
          defaultSnackBar(
            context: context,
            message: cubit.changeFavoritesModel!.message,
            state: ToastState.error,
          );
        }
      },
      builder: (context, state) => ConditionalBuilder(
        condition: cubit.homeModel != null &&
            cubit.categoriesModel != null &&
            cubit.homeModel!.data.banners.isNotEmpty,
        builder: (context) => homeScreenBuilder(
          homeModel: cubit.homeModel!,
          categoriesModel: cubit.categoriesModel!,
          context: context,
        ),
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget homeScreenBuilder({
    required HomeModel homeModel,
    required CategoriesModel categoriesModel,
    required BuildContext context,
  }) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: homeModel.data.banners
                .map((banner) => Image(image: NetworkImage(banner.image)))
                .toList(),
            options: CarouselOptions(
              initialPage: 0,
              viewportFraction: 1.0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[100],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: categoriesModel.data!.data.length,
                      itemBuilder: (context, index) => categoriesItemBuilder(
                        model: categoriesModel.data!.data[index],
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "New products",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[100],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.0),
                children: List.generate(
                  homeModel.data.products.length,
                  (index) => productItemBuilder(
                    model: homeModel.data.products[index],
                    context: context,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoriesItemBuilder({required DataModel model}) {
    const double size = 120.0;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image(
          image: NetworkImage(model.image),
          height: size,
          width: size,
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.9),
          width: size,
          child: Text(
            model.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget productItemBuilder({
    required ProductModel model,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      constraints: const BoxConstraints(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              Image(
                image: NetworkImage(model.image),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .25,
              ),
              if (model.discount != 0)
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
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      model.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${model.price}L.E.',
                            style: const TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      if (model.discount != 0)
                        Row(
                          children: [
                            Text(
                              '${model.oldPrice}L.E.',
                              style: const TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const Spacer(),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Feedback.forTap(context);
                        ShopCubit.get(context).changeFavorites(model.id);
                      },
                      child: ShopCubit.get(context).favoritesMap[model.id]!
                          ? const Icon(
                              Icons.favorite_outlined,
                              color: Colors.redAccent,
                              size: 30,
                            )
                          : const Icon(
                              size: 30,
                              Icons.favorite_border,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
