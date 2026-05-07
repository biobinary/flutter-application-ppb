import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class AgeEstimationModel {
  final int inputImageSize = 200;
  final int p = 116;
  Interpreter? interpreter;
  double inferenceTime = 0;

  AgeEstimationModel({this.interpreter});

  Future<double> predictAge(img.Image faceImage) async {
    if (interpreter == null) {
      throw Exception("Interpreter not initialized");
    }

    final start = DateTime.now().millisecondsSinceEpoch;

    // Preprocessing: Resize
    img.Image resizedImage = img.copyResize(
      faceImage,
      width: inputImageSize,
      height: inputImageSize,
      interpolation: img.Interpolation.linear,
    );

    // Preprocessing: Normalize and convert to Float32List
    var input = Float32List(1 * inputImageSize * inputImageSize * 3);
    var list = input;
    int index = 0;
    for (int y = 0; y < inputImageSize; y++) {
      for (int x = 0; x < inputImageSize; x++) {
        var pixel = resizedImage.getPixel(x, y);
        list[index++] = pixel.r / 255.0;
        list[index++] = pixel.g / 255.0;
        list[index++] = pixel.b / 255.0;
      }
    }

    // Input shape: [1, 200, 200, 3]
    var inputBuffer = input.reshape([1, inputImageSize, inputImageSize, 3]);

    // Output shape: [1, 1]
    var output = List<double>.filled(1, 0).reshape([1, 1]);

    interpreter!.run(inputBuffer, output);

    inferenceTime = (DateTime.now().millisecondsSinceEpoch - start).toDouble();

    return output[0][0] * p;
  }
}
