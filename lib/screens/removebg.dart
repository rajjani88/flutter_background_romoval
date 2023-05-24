import 'dart:io';
import 'dart:typed_data';

import 'package:ex_imagecal/helpers/imgpicker.dart';
import 'package:ex_imagecal/helpers/imgremovebg.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

enum ProcessingStatus {
  notstarted,
  processing,
  done;
}

class RemoveBG extends StatefulWidget {
  const RemoveBG({super.key});

  @override
  State<RemoveBG> createState() => _RemoveBGState();
}

class _RemoveBGState extends State<RemoveBG> {
  ImgPicker imgPicker = ImgPicker();
  XFile? xFile;

  ProcessingStatus processingStatus = ProcessingStatus.notstarted;
  Uint8List? imgInBytes;

  ImgRemoveBg imgRemoveBg = ImgRemoveBg();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text('Upload Image')],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        imgPicker.getImageFromGallery().then((value) {
                          setState(() {
                            xFile = value;
                          });
                        });
                      },
                      child: const Text('Gallery'))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: xFile == null
                    ? const Placeholder()
                    : Image.file(File(xFile!.path)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: xFile == null
                          ? null
                          : () {
                              //for loading
                              setState(() {
                                processingStatus = ProcessingStatus.processing;
                              });

                              imgRemoveBg
                                  .removeBg(context, xFile!)
                                  .then((value) {
                                setState(() {
                                  processingStatus = ProcessingStatus.done;
                                  imgInBytes = value;
                                });
                              });
                            },
                      child: const Text('Remove Bg'))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: processingStatus == ProcessingStatus.notstarted
                    ? const Placeholder()
                    : processingStatus == ProcessingStatus.processing
                        ?
                        //circular progress
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: CircularProgressIndicator(),
                              )
                            ],
                          )
                        : imgInBytes == null
                            ? Container()
                            : Image.memory(imgInBytes!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
