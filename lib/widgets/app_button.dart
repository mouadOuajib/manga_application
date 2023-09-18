import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final double? width;
  final double? height;
  final Gradient? gradient;
  final Color? color;
  final String buttontext;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final Border? border;
  final Widget? icon;
  final Color? iconColor;
  final bool isLoading;
  const AppButton({
    super.key,
    this.iconColor,
    this.icon,
    this.width = 220,
    this.height = 45,
    this.gradient,
    required this.buttontext,
    this.onTap,
    this.color = Colors.white,
    this.textStyle,
    this.border,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: gradient != null ? null : color,
            gradient: gradient,
            border: border,
            borderRadius: BorderRadius.circular(10),
          ),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : icon == null
                  ? Text(
                      buttontext,
                      style: textStyle,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon!,
                        SizedBox(width: 10.w),
                        Text(
                          buttontext,
                          style: textStyle,
                        )
                      ],
                    )),
    );
  }
}
