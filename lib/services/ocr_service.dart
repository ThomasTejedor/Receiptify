import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  
  static Future<String?> processImage(File image) async {
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
    
    textRecognizer.close();
    if(recognizedText.text == ""){
      return null;
    }
    for(final textBlock in recognizedText.blocks){
      print("yo " + textBlock.text);
    }
    return recognizedText.text;
  }
}