import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';

import '../../layout/cubit/cubit.dart';
import '../../models/search_model.dart';
import '../../shared/components/functions.dart';
import '../../styles/colors.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  RichText(
                    text: const TextSpan(
                      text: 'Store',
                      style: TextStyle(color: primaryColor, fontSize: 24),
                      children: [
                        TextSpan(
                          text: 'X',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.amber,
                          ),
                        ),
                        TextSpan(
                          text: '.com',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: primaryColor,
                  )
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  defaultTextFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    onFieldSubmitted: (String text) =>
                        SearchCubit.get(context).searchProduct(text),
                    validator: (String? val) {
                      if (val!.isNotEmpty) {
                        return "Enter search text";
                      }
                    },
                    label: "Search",
                    hint: "Enter Search text",
                    prefix: Icons.search,
                  ),
                  const SizedBox(height: 20),
                  if (state is SearchLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is SearchSuccessState)
                    productsScreenBuilder(
                      context: context,
                      searchModel: SearchCubit.get(context).searchModel,
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget productsScreenBuilder({
    required SearchModel searchModel,
    required BuildContext context,
  }) {
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: searchModel.data!.data.length,
        itemBuilder: (context, index) => searchItemBuilder(
          product: searchModel.data!.data[index],
          context: context,
        ),
        separatorBuilder: (context, index) =>
            Container(height: 1, color: Colors.grey),
      ),
    );
  }

  Widget searchItemBuilder({
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
            Image(
              image: NetworkImage(product.image),
              width: 120,
              height: 120,
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${product.price}L.E.',
                              style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w700,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            Feedback.forTap(context);
                            ShopCubit.get(context).changeFavorites(product.id);
                          },
                          child:
                              ShopCubit.get(context).favoritesMap[product.id] ??
                                      false
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
