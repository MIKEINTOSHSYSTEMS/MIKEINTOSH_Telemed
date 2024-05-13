import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kivicare_flutter/utils/app_common.dart';
import 'package:kivicare_flutter/utils/extensions/enums.dart';
import 'package:kivicare_flutter/utils/extensions/string_extensions.dart';
import 'package:kivicare_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class CustomImagePicker extends StatefulWidget {
  final Function(List<File> files) onFileSelected;
  final Function(String value)? onRemoveClick;
  final List<String>? selectedImages;

  CustomImagePicker({Key? key, required this.onFileSelected, this.selectedImages, this.onRemoveClick}) : super(key: key);

  @override
  _CustomImagePickerState createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  List<File> imageFiles = [];

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      init();
    });
  }

  void init() async {
    if (widget.selectedImages.validate().isNotEmpty) {
      widget.selectedImages.validate().forEach((element) {
        if (element.validate().contains("http")) {
          imageFiles.add(File(element.validate()));
        } else {
          imageFiles.add(File(element.validate()));
          widget.onFileSelected.call(imageFiles);
        }
      });
      setState(() {});
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: widget.key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            await showInDialog(
              context,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
              title: Text(locale.lblChooseAction, style: boldTextStyle()),
              builder: (p0) {
                return FilePickerDialog(isSelected: (false));
              },
            ).then((file) async {
              if (file != null) {
                if (file == GalleryFileTypes.CAMERA) {
                  await getCameraImage().then((value) {
                    if (imageFiles.validate().isNotEmpty) {
                      imageFiles.insert(0, value);
                    } else {
                      imageFiles.add(value);
                    }
                    setState(() {});
                  });
                } else if (file == GalleryFileTypes.GALLERY) {
                  await getMultipleImageSource().then((value) {
                    if (imageFiles.validate().isNotEmpty) {
                      value.forEach((element) {
                        imageFiles.add(element);
                      });
                    } else {
                      imageFiles = value;
                    }
                    setState(() {});
                  });
                }
                widget.onFileSelected.call(imageFiles);
              }
            });
          },
          child: DottedBorderWidget(
            color: context.primaryColor,
            radius: defaultRadius,
            child: Container(
              padding: EdgeInsets.all(26),
              alignment: Alignment.center,
              decoration: boxDecorationWithShadow(blurRadius: 0, backgroundColor: context.cardColor, borderRadius: radius()),
              child: Column(
                children: [
                  ic_no_photo.iconImage(size: 46),
                  8.height,
                  Text(locale.lblChooseImage, style: secondaryTextStyle()),
                ],
              ),
            ),
          ),
        ),
        16.height,
      ],
    );
  }
}

class FilePickerDialog extends StatelessWidget {
  final bool isSelected;

  FilePickerDialog({this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingItemWidget(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            title: locale.lblRemoveImage,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(Icons.close, color: context.iconColor),
            onTap: () {
              finish(context, GalleryFileTypes.CANCEL);
            },
          ).visible(isSelected),
          SettingItemWidget(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            title: locale.lblCamera,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.camera, color: context.iconColor),
            onTap: () {
              finish(context, GalleryFileTypes.CAMERA);
            },
          ).visible(!isWeb),
          SettingItemWidget(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            title: locale.lblGallery,
            titleTextStyle: primaryTextStyle(),
            leading: Icon(LineIcons.image_1, color: context.iconColor),
            onTap: () {
              finish(context, GalleryFileTypes.GALLERY);
            },
          ),
        ],
      ),
    );
  }
}
