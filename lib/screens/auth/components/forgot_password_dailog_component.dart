import 'package:flutter/material.dart';
import 'package:kivicare_flutter/components/app_loader.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/network/auth_repository.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordDialogComponent extends StatefulWidget {
  @override
  ForgotPasswordDialogComponentState createState() => ForgotPasswordDialogComponentState();
}

class ForgotPasswordDialogComponentState extends State<ForgotPasswordDialogComponent> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController emailCont = TextEditingController();
  FocusNode emailFocus = FocusNode();
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> forgotPasswordUser() async {
    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      hideKeyboard(context);

      appStore.setLoading(true);

      Map<String, dynamic> req = {
        'email': emailCont.text,
      };
      await forgotPasswordAPI(req).then((value) {
        toast(value.message);
        appStore.setLoading(false);
        finish(context, true);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
        finish(context);
      });
    } else {
      isFirstTime = !isFirstTime;
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Form(
            key: formKey,
            autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(locale.lblEnterYourEmailAddress, style: boldTextStyle(size: 20)),
                2.height,
                Text("${locale.lblAResetPasswordLinkWillBeSentToTheAboveEnteredEmailAddress}", style: secondaryTextStyle()),
                16.height,
                AppTextField(
                  onChanged: (value) {},
                  controller: emailCont,
                  textFieldType: TextFieldType.EMAIL,
                  decoration: inputDecoration(context: context, labelText: locale.lblEmail, suffixIcon: ic_message.iconImage(size: 18, color: context.iconColor).paddingAll(14)),
                ),
                32.height,
                AppButton(
                  color: primaryColor,
                  height: 40,
                  text: locale.lblSubmit,
                  textStyle: boldTextStyle(color: Colors.white),
                  width: context.width() - context.navigationBarHeight,
                  onTap: () {
                    forgotPasswordUser();
                  },
                ),
                8.height,
              ],
            ),
          ),
          AppLoader(),
        ],
      ),
    );
  }
}
