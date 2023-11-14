import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';

import '../../layout/shop_layout.dart';
import '../../shared/components/components.dart';
import '../../shared/components/functions.dart';
import '../../shared/components/variables.dart';
import '../../shared/network/local/cache_helper.dart';
import '../../shared/network/remote/end_points.dart';
import '../../styles/colors.dart';
import '../login/login_screen.dart';
import '../register/cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.registerModel.status!) {
              CacheHelper.setData(
                key: 'token',
                value: state.registerModel.data!.token,
              );
              token = state.registerModel.data!.token;

              navigateToWithReplacement(context, const ShopLayout());
            } else {
              final String message = state.registerModel.message!;
              defaultSnackBar(
                context: context,
                state: ToastState.error,
                message: message,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                TextButton(
                  onPressed: () {
                    RegisterCubit.get(context).langChange();
                  },
                  child: Text(lang),
                )
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "REGISTER",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[800],
                              ),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple[300],
                                  ),
                        ),
                        const SizedBox(height: 30),
                        defaultTextFormField(
                          controller: nameController,
                          type: TextInputType.name,
                          onFieldSubmitted: (val) {},
                          validator: (String? name) {
                            if (name!.isEmpty) {
                              return ("Enter your name please");
                            }
                          },
                          label: "Name",
                          hint: "User Name",
                          prefix: Icons.person,
                        ),
                        const SizedBox(height: 30),
                        defaultTextFormField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          onFieldSubmitted: (val) {},
                          validator: (String? phone) {
                            if (phone!.isEmpty) {
                              return ("Enter your phone please");
                            }
                          },
                          label: "phone",
                          hint: "+20 123 456 789",
                          prefix: Icons.phone,
                        ),
                        const SizedBox(height: 30),
                        defaultTextFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          onFieldSubmitted: (val) {},
                          validator: (String? email) {
                            if (email!.isEmpty) {
                              return ("Enter your email please");
                            }
                          },
                          label: "Email",
                          hint: "something@somemail.com",
                          prefix: Icons.email_outlined,
                        ),
                        const SizedBox(height: 30),
                        defaultTextFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          onFieldSubmitted: (val) {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                                phone: phoneController.text,
                              );

                              token = RegisterCubit.get(context)
                                  .registerModel
                                  .data!
                                  .token;
                            }
                          },
                          validator: (String? password) {
                            if (password!.isEmpty) {
                              return ("Enter your password please");
                            }
                          },
                          label: "Password",
                          hint: "********",
                          prefix: Icons.lock_outline,
                          suffix: RegisterCubit.get(context).passwordSuffix,
                          obscureText: RegisterCubit.get(context).isPassword,
                          suffixPressed: () =>
                              RegisterCubit.get(context).suffixChange(),
                        ),
                        const SizedBox(height: 30),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => defaultButton(
                            color: primaryColor,
                            text: "REGISTER",
                            isUpperCase: true,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                RegisterCubit.get(context).userRegister(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                );

                                token = RegisterCubit.get(context)
                                    .registerModel
                                    .data!
                                    .token;
                              }
                            },
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Have an account?",
                            ),
                            TextButton(
                              onPressed: () =>
                                  navigateTo(context, LoginScreen()),
                              child: const Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
