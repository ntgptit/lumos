import 'package:lumos/presentation/shared/primitives/buttons/lumos_button.dart';

class LumosPrimaryButton extends LumosButton {
  const LumosPrimaryButton({
    super.key,
    required super.text,
    super.onPressed,
    super.expand,
    super.isLoading,
    super.leading,
    super.trailing,
    super.style,
  }) : super(variant: AppButtonVariant.primary);
}
