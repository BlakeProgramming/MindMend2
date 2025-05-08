import 'package:flutter/material.dart';

@immutable
class GradientTheme extends ThemeExtension<GradientTheme> {
  final Gradient containerGradient;

  const GradientTheme({
    required this.containerGradient,
  });

  @override
  GradientTheme copyWith({Gradient? containerGradient}) {
    return GradientTheme(
      containerGradient: containerGradient ?? this.containerGradient,
    );
  }

  @override
  GradientTheme lerp(ThemeExtension<GradientTheme>? other, double t) {
    if (other is! GradientTheme) return this;
    return GradientTheme(
      containerGradient: LinearGradient.lerp(
        containerGradient as LinearGradient,
        other.containerGradient as LinearGradient,
        t,
      )!,
    );
  }
}
