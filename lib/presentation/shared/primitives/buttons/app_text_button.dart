import 'package:lumos/presentation/shared/primitives/buttons/app_button.dart';

class AppTextButton extends AppButton {
  const AppTextButton({
    super.key,
    required super.text,
    super.onPressed,
    super.expand,
    super.isLoading,
    super.leading,
    super.trailing,
    super.style,
  }) : super(variant: AppButtonVariant.text);
}
