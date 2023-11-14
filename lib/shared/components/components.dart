import 'package:flutter/material.dart';
import 'package:shop_app/styles/colors.dart';
import '../../modules/onboarding/on_boarding_screen.dart';

Widget buildBoardingItem(BoardingModel model) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Image(
          image: AssetImage(model.image),
        ),
      ),
      const SizedBox(
        height: 30.0,
      ),
      Text(
        model.title,
        style: const TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Text(
        model.body,
        style: const TextStyle(
          fontSize: 14.0,
        ),
      ),
    ],
  );
}

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required ValueChanged<String> onFieldSubmitted,
  bool obscureText = false,
  bool autofocus = false,
  bool enable = true,
  required var validator,
  required String label,
  required String hint,
  IconData? prefix,
  IconData? suffix,
  VoidCallback? suffixPressed,
}) {
  return TextFormField(
    enabled: enable,
    onFieldSubmitted: onFieldSubmitted,
    controller: controller,
    keyboardType: type,
    validator: validator,
    obscureText: obscureText,
    autofocus: autofocus,
    cursorColor: primaryColor,
    decoration: InputDecoration(
      prefixIcon: Icon(prefix),
      prefixIconColor: primaryColor,
      suffixIcon: IconButton(
        icon: Icon(suffix),
        onPressed: suffixPressed,
      ),
      suffixIconColor: primaryColor,
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      floatingLabelStyle: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 16.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: primaryColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2.0,
        ),
      ),
    ),
  );
}

Widget defaultButton({
  double width = double.infinity,
  Color color = primaryColor,
  double radius = 10.0,
  required String text,
  bool isUpperCase = true,
  required VoidCallback onPressed,
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    ),
    child: MaterialButton(
      onPressed: onPressed,
      child: Text(
        isUpperCase ? text.toUpperCase() : text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}

enum ToastState { success, warning, error }

Color _stateColorPicker(ToastState state) {
  Color color;
  switch (state) {
    case ToastState.success:
      color = Colors.green;
      break;
    case ToastState.warning:
      color = Colors.amber;
      break;
    case ToastState.error:
      color = Colors.red;
      break;
    default:
      color = Colors.white;
  }
  return color;
}

defaultSnackBar({
  required BuildContext context,
  required String message,
  required ToastState state,
}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                offset: Offset(0, 0),
              ),
            ],
            color: _stateColorPicker(state),
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              message,
            ),
          ),
        ),
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      duration: const Duration(seconds: 5),
      shape: const StadiumBorder(),
    ),
  );
}
