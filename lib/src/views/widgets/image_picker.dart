import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../helper/styles.dart';

class ImagePickerWidget extends StatefulWidget {
  final bool cameraOnly;
  final CameraDevice? preferredCamera;
  final String? defaultUrl;
  final File? defaultImage;
  final double? containerWidth;
  final double? containerHeight;
  final Function(File?)? onImageChanged;

  ImagePickerWidget(
      {Key? key,
      this.cameraOnly = false,
      this.preferredCamera,
      this.defaultUrl,
      this.defaultImage,
      this.onImageChanged,
      this.containerWidth,
      this.containerHeight})
      : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  late bool hasImage;
  XFile? img;

  @override
  void initState() {
    hasImage = widget.defaultImage != null || widget.defaultUrl != null;
    if (widget.defaultImage != null) {
      img = XFile(widget.defaultImage!.path);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.cameraOnly) {
          return _getImage(ImageSource.camera);
        }
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text(
                AppLocalizations.of(context)!.selectImageSource,
                style: kSubtitleStyle.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              titleTextStyle: khulaRegular,
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context);
                    _getImage(ImageSource.gallery);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: Colors.blueAccent)],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.photoFilm,
                          color: Theme.of(context).highlightColor,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.gallery,
                            style: kSubtitleStyle.copyWith(
                                color: Theme.of(context).highlightColor),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Divider(
                    color: Theme.of(context).primaryColor,
                    height: 0,
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () async {
                    Navigator.pop(context);
                    _getImage(ImageSource.camera);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [BoxShadow(color: Colors.blueAccent)],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          FontAwesomeIcons.camera,
                          color: Theme.of(context).highlightColor,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.camera,
                            style: kSubtitleStyle.copyWith(
                                color: Theme.of(context).highlightColor),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: widget.containerHeight ??
            ((MediaQuery.of(context).size.width - 40) / 2) * 0.8,
        width: widget.containerWidth ??
            (MediaQuery.of(context).size.width - 40) / 2,
        decoration: BoxDecoration(
          image: !hasImage
              ? null
              : img != null
                  ? DecorationImage(
                      image: FileImage(File(img!.path)),
                      fit: BoxFit.fill,
                    )
                  : DecorationImage(
                      image: NetworkImage(widget.defaultUrl!),
                      fit: BoxFit.fill,
                    ),
          color: Theme.of(context).highlightColor,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [BoxShadow(color: Colors.blueAccent)],
        ),
        child: !hasImage
            ? Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).primaryColor,
                  size: 50,
                ),
              )
            : Align(
                alignment: Alignment.topRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: CircleBorder(),
                  ),
                  onPressed: () {
                    setState(() {
                      hasImage = false;
                      img = null;
                    });
                    if (widget.onImageChanged != null) {
                      widget.onImageChanged!(null);
                    }
                  },
                  child: Icon(
                    Icons.close,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
      ),
    );
  }

  _getImage(ImageSource src) async {
    final ImagePicker _picker = ImagePicker();
    img = await _picker.pickImage(
      source: src,
      imageQuality: 100,
      preferredCameraDevice: widget.preferredCamera ?? CameraDevice.rear,
    );
    if (img != null) {
      setState(() {
        img;
      });
    }
    setState(() => hasImage = img != null);
    if (widget.onImageChanged != null) {
      widget.onImageChanged!(img != null ? File(img!.path) : null);
    }
  }
}
