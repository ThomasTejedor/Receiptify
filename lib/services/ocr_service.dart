import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../widgets/checkbox_widget.dart';

class OcrService {
  
  static Future<List<CheckboxWidget>?> processImage(File image) async {
    final InputImage inputImage = InputImage.fromFilePath(image.path);
    final textRecognizer = TextRecognizer();
    final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);
    
    textRecognizer.close();
    if(recognizedText.text == ""){
      return [];
    }

    List<CheckboxWidget> list = []; 
    for(final blocks in recognizedText.blocks ){
      for(final lines in blocks.lines) {
        for(final items in lines.elements ){
          if(items.text.substring(0,1) == '\$'){
            try{
              list.add(CheckboxWidget(double.parse(items.text.substring(1)), "Item"));
            } catch (error){
              //error occured
            }
          }
        }
      }
    }
    return list;
  }
}