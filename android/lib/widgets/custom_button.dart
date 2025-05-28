import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool fullWidth;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height = 56.0,
    this.borderRadius = 12.0,
    this.padding,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    Widget buttonChild = child;
    if (isLoading) {
      buttonChild = SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined
                ? theme.colorScheme.primary
                : theme.colorScheme.onPrimary,
          ),
        ),
      );
    }

    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: foregroundColor ?? theme.colorScheme.primary,
            side: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? theme.colorScheme.primary,
            foregroundColor: foregroundColor ?? theme.colorScheme.onPrimary,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          );

    Widget button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          );

    if (fullWidth) {
      button = SizedBox(
        width: double.infinity,
        height: height,
        child: button,
      );
    } else if (width != null) {
      button = SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
} 