import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/age_estimation_model.dart';
import '../models/gender_classification_model.dart';
import '../services/face_detector_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final FaceDetectorService _faceDetectorService = FaceDetectorService();
  
  AgeEstimationModel? _ageEstimationModel;
  GenderClassificationModel? _genderClassificationModel;
  
  File? _image;
  String _predictedAge = "";
  String _predictedGender = "";
  double _ageInferenceTime = 0;
  double _genderInferenceTime = 0;
  
  bool _isModelInitialized = false;
  bool _isProcessing = false;
  bool _showImageSelector = true;

  final List<String> _modelNames = [
    "Age/Gender Detection Model ( Quantized ) ",
    "Age/Gender Detection Model ( Non-quantized )",
    "Age/Gender Detection Lite Model ( Quantized )",
    "Age/Gender Detection Lite Model ( Non-quantized )",
  ];

  final List<List<String>> _modelFilenames = [
    ["model_age_q.tflite", "model_gender_q.tflite"],
    ["model_age_nonq.tflite", "model_gender_nonq.tflite"],
    ["model_lite_age_q.tflite", "model_lite_gender_q.tflite"],
    ["model_lite_age_nonq.tflite", "model_lite_gender_nonq.tflite"],
  ];

  int _selectedModelIndex = 0;

  @override
  void dispose() {
    _faceDetectorService.dispose();
    _ageEstimationModel?.interpreter?.close();
    _genderClassificationModel?.interpreter?.close();
    super.dispose();
  }

  Future<void> _initModels(bool useGpu) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      final options = InterpreterOptions();
      if (useGpu) {
        if (Platform.isAndroid) {
          options.addDelegate(GpuDelegateV2());
        } else if (Platform.isIOS) {
          options.addDelegate(GpuDelegate());
        }
      }

      final ageInterpreter = await Interpreter.fromAsset(
        'assets/models/${_modelFilenames[_selectedModelIndex][0]}',
        options: options,
      );
      final genderInterpreter = await Interpreter.fromAsset(
        'assets/models/${_modelFilenames[_selectedModelIndex][1]}',
        options: options,
      );

      setState(() {
        _ageEstimationModel = AgeEstimationModel(interpreter: ageInterpreter);
        _genderClassificationModel = GenderClassificationModel(interpreter: genderInterpreter);
        _isModelInitialized = true;
        _isProcessing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Models initialized.")),
        );
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error initializing models: $e")),
        );
      }
    }
  }

  Future<void> _processImage(XFile? pickedFile) async {
    if (pickedFile == null) return;

    setState(() {
      _image = File(pickedFile.path);
      _isProcessing = true;
    });

    final inputImage = InputImage.fromFilePath(pickedFile.path);
    final faces = await _faceDetectorService.detectFaces(inputImage);

    if (faces.isNotEmpty) {
      final face = faces.first;
      final bytes = await pickedFile.readAsBytes();
      final originalImage = img.decodeImage(bytes);

      if (originalImage != null) {
        // Match Kotlin's shift logic (top + 5)
        const int shift = 5;
        final faceCrop = img.copyCrop(
          originalImage,
          x: face.boundingBox.left.toInt(),
          y: (face.boundingBox.top.toInt() + shift).clamp(0, originalImage.height),
          width: face.boundingBox.width.toInt(),
          height: face.boundingBox.height.toInt(),
        );

        final age = await _ageEstimationModel!.predictAge(faceCrop);
        final genderProbs = await _genderClassificationModel!.predictGender(faceCrop);

        setState(() {
          _predictedAge = age.floor().toString();
          _predictedGender = genderProbs[0] > genderProbs[1] ? "Male" : "Female";
          _ageInferenceTime = _ageEstimationModel!.inferenceTime;
          _genderInferenceTime = _genderClassificationModel!.inferenceTime;
          _showImageSelector = false;
          _isProcessing = false;
        });
      }
    } else {
      setState(() {
        _isProcessing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No faces detected in the image.")),
        );
      }
    }
  }

  void _showModelInitDialog() {
    bool useGpu = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Initialize the Model", textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Choose a TFLite Model", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...List.generate(_modelNames.length, (index) {
                      return ListTile(
                        leading: Icon(
                          Icons.check_circle,
                          color: _selectedModelIndex == index ? Colors.blue : Colors.grey,
                        ),
                        title: Text(_modelNames[index]),
                        selected: _selectedModelIndex == index,
                        onTap: () {
                          setDialogState(() {
                            _selectedModelIndex = index;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    const Text("Other Options", style: TextStyle(fontWeight: FontWeight.bold)),
                    CheckboxListTile(
                      title: const Text("Use GPU Delegate"),
                      value: useGpu,
                      onChanged: (val) {
                        setDialogState(() {
                          useGpu = val ?? false;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _initModels(useGpu);
                  },
                  child: const Text("Initialize"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Age & Gender Estimation"),
        actions: [
          if (!_showImageSelector)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _showImageSelector = true;
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          _showImageSelector ? _buildImageSelector() : _buildPredictionsLayout(),
          if (_isProcessing)
            Container(
              color: Colors.black.withAlpha(128),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpinKitFadingCircle(color: Colors.white, size: 50.0),
                    SizedBox(height: 16),
                    Text("Processing...", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageSelector() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Select a Picture or Take a Photo",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.camera_alt,
                label: "Take Photo",
                onPressed: () async {
                  if (!_isModelInitialized) {
                    _showModelInitDialog();
                  } else {
                    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                    _processImage(pickedFile);
                  }
                },
              ),
              _buildActionButton(
                icon: Icons.image,
                label: "Select Picture",
                onPressed: () async {
                  if (!_isModelInitialized) {
                    _showModelInitDialog();
                  } else {
                    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                    _processImage(pickedFile);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _showModelInitDialog,
            child: const Text("Configure Model"),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_image != null)
            Card(
              clipBehavior: Clip.antiAlias,
              child: Image.file(_image!),
            ),
          const SizedBox(height: 16),
          _buildResultsCard(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.camera_alt,
                label: "Take Photo",
                onPressed: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  _processImage(pickedFile);
                },
              ),
              _buildActionButton(
                icon: Icons.image,
                label: "Select Picture",
                onPressed: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  _processImage(pickedFile);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildResultItem("Predicted Age", _predictedAge),
                _buildResultItem("Predicted Gender", _predictedGender),
              ],
            ),
            const Divider(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Age Estimation Inference Time: ${_ageInferenceTime.toInt()} ms",
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    "Gender Detection Inference Time: ${_genderInferenceTime.toInt()} ms",
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(String title, String value) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, color: Colors.blue)),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
