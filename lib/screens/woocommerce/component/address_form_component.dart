import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kivicare_flutter/main.dart';
import 'package:kivicare_flutter/model/woo_commerce/billing_address_model.dart';
import 'package:kivicare_flutter/model/woo_commerce/country_model.dart';
import 'package:kivicare_flutter/screens/woocommerce/screens/edit_shop_detail_screen.dart';
import 'package:kivicare_flutter/utils/cached_value.dart';
import 'package:kivicare_flutter/utils/colors.dart';
import 'package:kivicare_flutter/utils/common.dart';
import 'package:kivicare_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

class AddressFormComponent extends StatefulWidget {
  final BillingAddressModel? data;
  final bool isBilling;

  const AddressFormComponent({this.data, this.isBilling = false});

  @override
  State<AddressFormComponent> createState() => _AddressFormComponentState();
}

List<CountryModel> countriesList = [];

class _AddressFormComponentState extends State<AddressFormComponent> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController company = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController addOne = TextEditingController();
  TextEditingController addTwo = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController postCode = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode lastNameFocus = FocusNode();
  FocusNode companyFocus = FocusNode();
  FocusNode addOneFocus = FocusNode();
  FocusNode addTwoFocus = FocusNode();
  FocusNode cityFocus = FocusNode();

  FocusNode countryFocus = FocusNode();

  FocusNode stateFocus = FocusNode();
  FocusNode postCodeFocus = FocusNode();
  FocusNode phoneFocus = FocusNode();
  FocusNode emailFocus = FocusNode();

  CountryModel? selectedCountry;
  StateModel? selectedState;

  List<CountryModel> countries = [];

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    if (CachedData.getCachedData(cachedKey: SharedPreferenceKey.countriesListKey) != null) {
      if (countries.isEmpty)
        countries.addAll(
          (CachedData.getCachedData(cachedKey: SharedPreferenceKey.countriesListKey) as List).map((e) => CountryModel.fromJson(e)).toList(),
        );
    }

    firstName.text = widget.data!.firstName.validate();
    lastName.text = widget.data!.lastName.validate();
    company.text = widget.data!.company.validate();
    country.text = widget.data!.country.validate();
    addOne.text = widget.data!.address_1.validate();
    addTwo.text = widget.data!.address_2.validate();
    city.text = widget.data!.city.validate();
    state.text = widget.data!.state.validate();
    postCode.text = widget.data!.postcode.validate();
    phone.text = widget.data!.phone.validate();
    email.text = widget.data!.email.validate();
    if (widget.data != null) {
      if (widget.data!.country.validate().isNotEmpty) {
        selectedCountry = countries.firstWhere((element) => element.name == widget.data!.country.validate());
        if (selectedCountry!.states != null) {
          if (widget.data!.state.validate().isNotEmpty) {
            selectedState = selectedCountry!.states.validate().firstWhere((element) => element.name == widget.data!.state.validate());
          }
        }
      }
    }

    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    appStore.setLoading(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SingleChildScrollView(
      key: UniqueKey(),
      child: Form(
        key: formKey,
        autovalidateMode: isFirstTime ? AutovalidateMode.disabled : AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            16.height,
            Row(
              children: [
                AppTextField(
                  textStyle: primaryTextStyle(),
                  controller: firstName,
                  textFieldType: TextFieldType.NAME,
                  focus: firstNameFocus,
                  errorThisFieldRequired: locale.lblFirstNameIsRequired,
                  nextFocus: lastNameFocus,
                  decoration: inputDecoration(context: context, labelText: locale.lblFirstName, fillColor: context.scaffoldBackgroundColor),
                  onFieldSubmitted: (value) {
                    lastNameFocus.requestFocus();
                  },
                ).expand(),
                16.width,
                AppTextField(
                  textStyle: primaryTextStyle(),
                  controller: lastName,
                  textFieldType: TextFieldType.NAME,
                  focus: lastNameFocus,
                  nextFocus: companyFocus,
                  errorThisFieldRequired: locale.lblLastNameIsRequired,
                  decoration: inputDecoration(context: context, labelText: locale.lblLastName, fillColor: context.scaffoldBackgroundColor),
                  onFieldSubmitted: (value) {
                    emailFocus.requestFocus();
                  },
                ).expand(),
              ],
            ),
            16.height,
            AppTextField(
              enabled: !appStore.isLoading,
              controller: company,
              focus: companyFocus,
              nextFocus: addOneFocus,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textFieldType: TextFieldType.NAME,
              textStyle: primaryTextStyle(),
              maxLines: 1,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblCompany,
                fillColor: context.scaffoldBackgroundColor,
              ),
              onChanged: (text) {
                if (widget.isBilling) {
                  billingAddress.company = text;
                } else {
                  shippingAddress.company = text;
                }
              },
              onFieldSubmitted: (text) {
                if (widget.isBilling) {
                  billingAddress.company = text;
                } else {
                  shippingAddress.company = text;
                }
              },
            ),
            16.height,
            AppTextField(
              enabled: !appStore.isLoading,
              controller: addOne,
              focus: addOneFocus,
              nextFocus: addTwoFocus,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textFieldType: TextFieldType.NAME,
              textStyle: primaryTextStyle(),
              maxLines: 1,
              decoration: inputDecoration(
                context: context,
                labelText: '${locale.lblAddress} 1',
                fillColor: context.scaffoldBackgroundColor,
              ),
              onChanged: (text) {
                if (widget.isBilling) {
                  billingAddress.address_1 = text;
                } else {
                  shippingAddress.address_1 = text;
                }
              },
              onFieldSubmitted: (text) {
                if (widget.isBilling) {
                  billingAddress.address_1 = text;
                } else {
                  shippingAddress.address_1 = text;
                }
              },
            ),
            16.height,
            AppTextField(
              enabled: !appStore.isLoading,
              controller: addTwo,
              focus: addTwoFocus,
              nextFocus: countryFocus,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              textFieldType: TextFieldType.NAME,
              textStyle: primaryTextStyle(),
              maxLines: 1,
              decoration: inputDecoration(
                context: context,
                labelText: '${locale.lblAddress} 2',
                fillColor: context.scaffoldBackgroundColor,
              ),
              onChanged: (text) {
                if (widget.isBilling) {
                  billingAddress.address_2 = text;
                } else {
                  shippingAddress.address_2 = text;
                }
              },
              onFieldSubmitted: (text) {
                if (widget.isBilling) {
                  billingAddress.address_2 = text;
                } else {
                  shippingAddress.address_2 = text;
                }
              },
            ),
            16.height,
            DropdownButtonFormField(
              isExpanded: true,
              borderRadius: radius(),
              focusColor: primaryColor,
              dropdownColor: context.cardColor,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblCountry,
                fillColor: context.scaffoldBackgroundColor,
              ),
              value: selectedCountry,
              items: countries
                  .map(
                    (country) => DropdownMenuItem(
                      value: country,
                      child: Text(country.name.validate(), style: secondaryTextStyle()),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                selectedCountry = value;
                setState(() {});
                if (widget.isBilling) {
                  billingAddress.country = value!.name;
                } else {
                  shippingAddress.country = value!.name;
                }
              },
            ),
            16.height,
            if (selectedCountry != null && countries.firstWhere((element) => element.name == selectedCountry!.name).states.validate().isNotEmpty)
              DropdownButtonFormField(
                key: UniqueKey(),
                isExpanded: true,
                borderRadius: radius(),
                focusColor: primaryColor,
                dropdownColor: context.cardColor,
                decoration: inputDecoration(
                  context: context,
                  labelText: locale.state,
                  fillColor: context.scaffoldBackgroundColor,
                ),
                value: selectedState,
                items: selectedCountry?.states
                    .validate()
                    .map(
                      (state) => DropdownMenuItem<StateModel>(
                        value: state,
                        child: Text(
                          state.name.validate(),
                          style: secondaryTextStyle(),
                        ).paddingSymmetric(horizontal: 0),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedState = value;

                  if (widget.isBilling) {
                    billingAddress.state = value!.name;
                  } else {
                    shippingAddress.state = value!.name;
                  }
                  setState(() {});
                },
              )
            else
              AppTextField(
                controller: state,
                focus: stateFocus,
                nextFocus: cityFocus,
                textInputAction: TextInputAction.next,
                textFieldType: TextFieldType.OTHER,
                decoration: inputDecoration(
                  context: context,
                  labelText: locale.state,
                  fillColor: context.scaffoldBackgroundColor,
                ),
                onTap: () {
                  if (selectedCountry == null) toast(locale.lblPleaseSelectCountry);
                },
                onChanged: (text) {
                  if (widget.isBilling) {
                    billingAddress.state = text;
                  } else {
                    shippingAddress.state = text;
                  }
                  setState(() {});
                },
                onFieldSubmitted: (text) {
                  if (widget.isBilling) {
                    billingAddress.state = text;
                  } else {
                    shippingAddress.state = text;
                  }
                  setState(() {});
                },
              ),
            16.height,
            Row(
              children: [
                AppTextField(
                  controller: city,
                  focus: cityFocus,
                  nextFocus: postCodeFocus,
                  textInputAction: TextInputAction.next,
                  textFieldType: TextFieldType.OTHER,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblCity,
                    fillColor: context.scaffoldBackgroundColor,
                  ),
                  onFieldSubmitted: (text) {
                    if (widget.isBilling) {
                      billingAddress.city = text;
                    } else {
                      shippingAddress.city = text;
                    }
                  },
                  onChanged: (text) {
                    if (widget.isBilling) {
                      billingAddress.city = text;
                    } else {
                      shippingAddress.city = text;
                    }
                  },
                ).expand(),
                16.width,
                AppTextField(
                  controller: postCode,
                  focus: postCodeFocus,
                  nextFocus: phoneFocus,
                  textFieldType: TextFieldType.OTHER,
                  textInputAction: TextInputAction.next,
                  decoration: inputDecoration(
                    context: context,
                    labelText: locale.lblPostalCode,
                    fillColor: context.scaffoldBackgroundColor,
                  ),
                  onChanged: (text) {
                    if (widget.isBilling) {
                      billingAddress.postcode = text;
                    } else {
                      shippingAddress.postcode = text;
                    }
                  },
                  onFieldSubmitted: (text) {
                    if (widget.isBilling) {
                      billingAddress.postcode = text;
                    } else {
                      shippingAddress.postcode = text;
                    }
                  },
                ).expand()
              ],
            ),
            16.height,
            AppTextField(
              enabled: !appStore.isLoading,
              controller: phone,
              focus: phoneFocus,
              readOnly: false,
              nextFocus: widget.isBilling ? emailFocus : null,
              keyboardType: TextInputType.phone,
              textInputAction: widget.isBilling ? TextInputAction.next : TextInputAction.done,
              textFieldType: TextFieldType.PHONE,
              textStyle: primaryTextStyle(),
              maxLines: 1,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblContactNumber,
                fillColor: context.scaffoldBackgroundColor,
              ),
              onChanged: (text) {
                if (widget.isBilling) {
                  billingAddress.phone = text;
                } else {
                  shippingAddress.phone = text;
                }
              },
              onFieldSubmitted: (text) {
                if (widget.isBilling) {
                  billingAddress.phone = text;
                } else {
                  shippingAddress.phone = text;
                }
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                } else {
                  isFirstTime = false;
                  setState(() {});
                }
              },
            ),
            16.height,
            AppTextField(
              enabled: !appStore.isLoading,
              controller: email,
              focus: emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              textFieldType: TextFieldType.EMAIL,
              textStyle: primaryTextStyle(),
              maxLines: 1,
              decoration: inputDecoration(
                context: context,
                labelText: locale.lblEmail,
                fillColor: context.scaffoldBackgroundColor,
              ),
              onChanged: (text) {
                if (widget.isBilling) {
                  billingAddress.email = text;
                } else {
                  shippingAddress.email = text;
                }
              },
              onFieldSubmitted: (text) {
                if (widget.isBilling) {
                  billingAddress.email = text;
                } else {
                  shippingAddress.email = text;
                }
              },
            ).visible(widget.isBilling),
            16.height,
            16.height,
          ],
        ),
      ),
    );
  }
}
