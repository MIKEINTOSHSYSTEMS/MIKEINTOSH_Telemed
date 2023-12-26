import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/body_widget.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  static String tag = '/ChangePasswordScreen';

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController oldPassCont = TextEditingController();
  TextEditingController newPassCont = TextEditingController();
  TextEditingController confNewPassCont = TextEditingController();

  FocusNode newPassFocus = FocusNode();
  FocusNode confPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  void submit() async {
    appStore.setLoading(true);

    Map req = {
      'old_password': oldPassCont.text.trim(),
      'new_password': newPassCont.text.trim(),
    };

    await changePassword(req).then((value) async {
      setValue(PASSWORD, newPassCont.text.trim());
      finish(context);
      toast(value.message);
    }).catchError((e) {
      toast(e.toString());
    });

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    getDisposeStatusBarColor();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(locale.lblChangePassword, textColor: Colors.white, systemUiOverlayStyle: defaultSystemUiOverlayStyle(context)),
      body: Body(
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: AnimatedScrollView(
            padding: EdgeInsets.all(16),
            children: [
              AppTextField(
                controller: oldPassCont,
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context: context, labelText: locale.lblOldPassword),
                nextFocus: newPassFocus,
                suffixPasswordVisibleWidget: ic_showPassword.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hidePassword.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                textStyle: primaryTextStyle(),
              ),
              16.height,
              AppTextField(
                controller: newPassCont,
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context: context, labelText: locale.lblNewPassword),
                focus: newPassFocus,
                suffixPasswordVisibleWidget: ic_showPassword.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hidePassword.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                nextFocus: confPassFocus,
                textStyle: primaryTextStyle(),
              ),
              16.height,
              AppTextField(
                controller: confNewPassCont,
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context: context, labelText: locale.lblConfirmPassword),
                focus: confPassFocus,
                textInputAction: TextInputAction.done,
                textStyle: primaryTextStyle(),
                suffixPasswordVisibleWidget: ic_showPassword.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                suffixPasswordInvisibleWidget: ic_hidePassword.iconImage(size: 10, color: context.iconColor).paddingAll(14),
                validator: (String? value) {
                  if (value!.isEmpty) return errorThisFieldRequired;
                  if (value.length < passwordLengthGlobal) return locale.lblPasswordLengthMessage + ' $passwordLengthGlobal';
                  if (value.trim() != newPassCont.text.trim()) return locale.lblBothPasswordMatched;
                  return null;
                },
                onFieldSubmitted: (s) {
                  submit();
                },
              ),
              30.height,
              AppButton(
                text: locale.lblSave,
                textStyle: boldTextStyle(color: textPrimaryDarkColor),
                width: context.width(),
                onTap: () {
                  hideKeyboard(context);

                  if (appStore.demoEmails.any((e) => e.toString() == appStore.userEmail)) {
                    toast(locale.lblDemoUserPasswordNotChanged);
                  } else {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      showConfirmDialogCustom(
                        context,
                        dialogType: DialogType.CONFIRMATION,
                        title: 'Are you sure you want to change the password?',
                        onAccept: (p0) {
                          submit();
                        },
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
