import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import '../../shared/components/functions.dart';
import '../../shared/components/variables.dart';
import '../../shared/network/remote/end_points.dart';
import '../../styles/colors.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            if (state.loginModel.status!) {
              CacheHelper.setData(
                key: 'token',
                value: state.loginModel.data!.token,
              );
              token = state.loginModel.data!.token;

              navigateToWithReplacement(context, const ShopLayout());
            } else {
              final String message = state.loginModel.message!;
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
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: const TextSpan(
                                  text: 'Store',
                                  style: TextStyle(
                                      color: primaryColor, fontSize: 50),
                                  children: [
                                    TextSpan(
                                      text: 'X',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 60,
                                        color: Colors.amber,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '.com',
                                      style: TextStyle(
                                        fontSize: 40,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Icon(
                                Icons.shopping_cart_outlined,
                                color: primaryColor,
                                size: 60,
                              )
                            ],
                          ),
                        ),
                        Text(
                          "LOGIN",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple[800],
                              ),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple[300],
                                  ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
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
                        const SizedBox(
                          height: 30,
                        ),
                        defaultTextFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          onFieldSubmitted: (val) {
                            if (formKey.currentState!.validate()) {
                              LoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
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
                          suffix: LoginCubit.get(context).passwordSuffix,
                          obscureText: LoginCubit.get(context).isPassword,
                          suffixPressed: () =>
                              LoginCubit.get(context).suffixChange(),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => defaultButton(
                            text: "Login",
                            isUpperCase: true,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                LoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, RegisterScreen());
                              },
                              child: const Text(
                                "REGISTER",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Change lang",
                            ),
                            TextButton(
                              onPressed: () {
                                LoginCubit.get(context).langChange();
                              },
                              child: Text(
                                lang.toUpperCase(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        )
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
