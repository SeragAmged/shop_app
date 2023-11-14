import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/cubit.dart';
import '../../layout/cubit/states.dart';
import '../../models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ShopCubit cubit = ShopCubit.get(context);
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) => ConditionalBuilder(
        condition: cubit.categoriesModel != null,
        builder: (context) => categoriesScreenBuilder(
          categoriesModel: cubit.categoriesModel!,
        ),
        fallback: (context) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget categoriesScreenBuilder({required CategoriesModel categoriesModel}) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      itemCount: categoriesModel.data!.data.length,
      itemBuilder: (context, index) => categoriesItemBuilder(
        model: categoriesModel.data!.data[index],
      ),
      separatorBuilder: (context, index) =>
          Container(height: 1, color: Colors.grey),
    );
  }

  Widget categoriesItemBuilder({required DataModel model}) {
    const double size = 100.0;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image(
            image: NetworkImage(model.image),
            height: size,
            width: size,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 20),
          Flexible(
            child: SizedBox(
              width: double.infinity,
              child: Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}
