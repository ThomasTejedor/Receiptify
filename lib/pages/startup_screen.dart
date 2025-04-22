import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> with WidgetsBindingObserver {
  List<CameraDescription> cameras = [];
  CameraController? cameraController; 
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(cameraController == null || cameraController?.value.isInitialized == false) {
      return;
    }
    
    if(state == AppLifecycleState.inactive) {
      cameraController?.dispose();
    } else if(state == AppLifecycleState.resumed) {
      _setupCameraController();
    }
  }

  @override
  void initState() {
    super.initState();
    _setupCameraController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
    );
  }
  
  Widget _buildUI() {
    if(cameraController == null || cameraController?.value.isInitialized == false) {
      return const Center(
        child: CircularProgressIndicator(),

      );
    }
    return SafeArea(
      child: SizedBox.expand(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          
          children:[
            SizedBox(
              height: MediaQuery.sizeOf(context).height *.75,
              width: MediaQuery.sizeOf(context).width ,
              child: CameraPreview(
                cameraController!,
              ),
            ),
            Row(
              children: [
                //Button to go the profile
                IconButton(
                  onPressed: () {context.push('/profile');},
                  iconSize: MediaQuery.sizeOf(context).height *.05,
                  icon: const Icon(
                    Icons.account_circle

                  ),
                ),
              //Keeps the button expanded in the middle
                Expanded(
                  //This makes sure the actual button isn't expanded but the container
                  child: Center(
                    //Button to take a picture
                    child: IconButton(
                      onPressed: () async {
                        XFile picture = await cameraController!.takePicture();
                        Gal.putImage(
                          picture.path,
                        );
                        File userPicture = File(picture.path);
                        if(mounted) {
                          context.push('/checkbox', extra: userPicture);
                        }
                      },
                      iconSize: MediaQuery.sizeOf(context).height *.10,
                      icon: const Icon(
                        Icons.circle_outlined,
                      ),
                    ),
                  ),
                ),
                //Button to use photos in the gallery instead of taking a photo
                IconButton(
                  onPressed: () async {
                    final pickedFile = 
                      await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(pickedFile != null) {

                      if(mounted) {
                        context.push('/checkbox', extra: File(pickedFile.path));
                      }
                    }
                  },
                  iconSize: MediaQuery.sizeOf(context).height *.05,
                  icon: const Icon(
                    Icons.add_photo_alternate_rounded

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _setupCameraController() async {
    List<CameraDescription> availCameras = await availableCameras();

    if(availCameras.isNotEmpty) {
      setState(() {
        cameras = availCameras;
        cameraController = CameraController(availCameras.last, ResolutionPreset.high);
      });
      cameraController?.initialize().then((_) {
          if(!mounted){
            return;
          }
          setState(() {});
        }).catchError(
          (Object e){
            
          },
        );
    }
  }

}