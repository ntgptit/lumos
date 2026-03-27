import 'package:lumos/presentation/shared/primitives/buttons/app_button.dart';

class AppOutlineButton extends AppButton {
  const AppOutlineButton({
    super.key,
    required super.text,
    super.onPressed,
    super.expand,
    super.isLoading,
    super.leading,
    super.trailing,
    super.style,
  }) : super(variant: AppButtonVariant.outline);
}
