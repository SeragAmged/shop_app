import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/shared/components/functions.dart';
import 'package:shop_app/shared/components/variables.dart';
import '../../layout/cubit/states.dart';
import '../../shared/components/components.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ShopCubit cubit = ShopCubit.get(context);
    LoginModel? model = cubit.userModel;

    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is UpdateSuccessState) {
          defaultSnackBar(
            context: context,
            state: ToastState.success,
            message: state.message,
          );
        } else if (state is UpdateErrorState) {
          defaultSnackBar(
            context: context,
            state: ToastState.error,
            message: state.error,
          );
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition:
              ShopCubit.get(context).userModel != null && model!.data != null,
          builder: (context) {
            nameController.text = model!.data!.name;
            emailController.text = model.data!.email;
            phoneController.text = model.data!.phone;
            List<Widget> infoList = [
              defaultTextFormField(
                controller: nameController,
                type: TextInputType.name,
                onFieldSubmitted: (s) => '',
                validator: (String? name) {
                  if (name!.isEmpty) {
                    return ("Enter your name please");
                  }
                },
                label: 'name',
                hint: 'Name',
                prefix: Icons.person,
              ),
              const SizedBox(height: 10),
              defaultTextFormField(
                controller: emailController,
                type: TextInputType.emailAddress,
                onFieldSubmitted: (s) => '',
                validator: (String? email) {
                  if (email!.isEmpty) {
                    return ("Enter your email please");
                  }
                },
                label: 'Email',
                hint: '****@**mail.com',
                prefix: Icons.email,
              ),
              const SizedBox(height: 10),
              defaultTextFormField(
                controller: phoneController,
                type: TextInputType.phone,
                onFieldSubmitted: (s) => '',
                validator: (String? phone) {
                  if (phone!.isEmpty) {
                    return ("Enter your phone please");
                  }
                },
                label: 'phone',
                hint: '+123 456 789',
                prefix: Icons.phone,
              ),
            ];
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  if (state is UpdateLoadingState)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) => infoList[index],
                        itemCount: infoList.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                      ),
                    ),
                  ),
                  defaultButton(
                    text: 'Update',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        cubit.userUpdate(
                          email: emailController.text,
                          name: nameController.text,
                          phone: phoneController.text,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  defaultButton(
                    text: 'Logout',
                    onPressed: () {
                      cubit.userLogout(token: token);
                      logOut(context);
                    },
                  ),
                ],
              ),
            );
          },
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
