import 'dart:io';
import 'dart:async';
import 'package:ecommerce/common/button/custom_text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';


// ignore: must_be_immutable
class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({
    Key? key,
    this.onImageSelected,
    required this.onImageSelectedList,
    this.local,
  }) : super(key: key);

  final ImagePicker picker = ImagePicker();

  final Function(File)? onImageSelected;
  final Function(List<File>) onImageSelectedList;

  String? local = '';

  @override
  Widget build(BuildContext context) {
    Future<void> editImage(String? path) async {
      if (path != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Editar Imagem',
                toolbarColor: Theme
                    .of(context)
                    .primaryColor,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Editar Imagem',
              cancelButtonTitle: 'Cancelar',
              doneButtonTitle: 'Concluir',
            ),
            WebUiSettings(
              context: context,
              presentStyle: CropperPresentStyle.dialog,
              boundary: const CroppieBoundary(
                width: 520,
                height: 520,
              ),
              viewPort: const CroppieViewPort(
                  width: 480, height: 480, type: 'circle'),
              enableExif: true,
              enableZoom: true,
              showZoomer: true,
            ),
          ],
        );
        if (croppedFile != null) {
          final originalFile = File(path);
          await originalFile.writeAsBytes(await croppedFile.readAsBytes());
          onImageSelected!(originalFile);
        }
      }
    }

    Future<void> imgGallery() async {
      local = 'gallery';
      final List<XFile> xfiles = await picker.pickMultiImage();
      final List<File> files = xfiles.map((xfile) => File(xfile.path)).toList();
      if (files.length == 1) {
        File file = files.first;
        editImage(file.path);
      } else {
        onImageSelectedList(List.from(files));
      }
    }

    Future<void> imgCamera() async {
      XFile? photo = await picker.pickImage(source: ImageSource.camera);
      editImage(photo!.path);
    }

    if (Platform.isAndroid) {
      return BottomSheet(
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextButton(
              onPressed: () {
                imgCamera();
              },
              text: 'Câmera',
              fontSize: 18,
            ),
            const Divider(
              height: 5,
            ),
            CustomTextButton(
              onPressed: () {
                imgGallery();
              },
              text: 'Galeria',
              fontSize: 18,
            ),
            //const SizedBox(height: 8,),
            const Divider(
              height: 2,
              thickness: 2,
            ),
            CustomTextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'Cancelar',
              color: Colors.red,
              fontSize: 18,
            ),
          ],
        ),
        onClosing: () {},
      );
    } else if (Platform.isIOS) {
      return CupertinoActionSheet(
        title: const Text('Selecionar a foto para o item:'),
        message: const Text('Escolha a origem da foto!'),
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: const Text('Cancelar'),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('Câmera'),
            onPressed: () {
              imgCamera();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Galeria'),
            onPressed: () {
              imgGallery();
            },
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: const Text('Selecionar foto para o item:'),
        content: const Text('Escolher Fotos!'),
        actions: [
          CustomTextButton(
            onPressed: () {
              imgCamera();
            },
            text: 'Câmera',
            fontSize: 18,
          ),
          const Divider(
            height: 5,
          ),
          CustomTextButton(
            onPressed: () {
              imgGallery();
            },
            text: 'Galeria',
            fontSize: 18,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          )
        ],
      );
    }
  }
}
