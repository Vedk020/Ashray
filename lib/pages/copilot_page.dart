import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class CopilotPage extends StatefulWidget {
  const CopilotPage({super.key});

  @override
  State<CopilotPage> createState() => _CopilotPageState();
}

class _CopilotPageState extends State<CopilotPage> {
  final String _apiKey = 'AIzaSyBUVr8I7M2NcSo1ofm-FxngXyU0gCsYTN8';

  File? _image;
  final ImagePicker _picker = ImagePicker();
  final _notesController = TextEditingController();
  bool _isLoading = false;
  String? _analysisResult;

  // Speech to Text variables
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() {
    _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() {
    _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _notesController.text = result.recognizedWords;
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _analysisResult = null;
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) {
      _showSnackBar('Please take a photo first.');
      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    try {
      final imageBytes = await _image!.readAsBytes();
      final base64Image = base64Encode(imageBytes);

      final prompt =
          "You are an AI health assistant for an ASHA worker in rural India. Based on the provided image and notes, analyze for any visible signs of health issues like malnutrition, anemia, skin conditions, or distress. Provide a simple, point-wise summary of observations and suggest next steps for the ASHA worker. If no issues are visible, state that. Notes from ASHA worker: ${_notesController.text}";

      final response = await http.post(
        Uri.parse(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt},
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": base64Image
                  }
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        final resultText =
            decodedResponse['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _analysisResult = resultText;
        });
      } else {
        final errorResponse = jsonDecode(response.body);
        setState(() {
          _analysisResult = 'Error: ${errorResponse['error']['message']}';
        });
      }
    } catch (e) {
      setState(() {
        _analysisResult = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              title: const Text(
                'AI Health Copilot',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              backgroundColor: isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              elevation: 0,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          _buildBackground(theme),
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 60, 20, 20),
            child: Column(
              children: [
                _buildImagePicker(theme, isDark)
                    .animate()
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.2),
                const SizedBox(height: 24),
                _buildNotesField(theme)
                    .animate()
                    .fadeIn(delay: 150.ms, duration: 400.ms)
                    .slideY(begin: 0.2),
                const SizedBox(height: 24),
                _buildAnalyzeButton(theme)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .scale(begin: const Offset(0.95, 0.95)),
                const SizedBox(height: 32),
                if (_isLoading) _buildLoadingIndicator(theme),
                if (_analysisResult != null)
                  _buildResultCard(theme)
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideY(begin: 0.2),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _speechToText.isListening
          ? FloatingActionButton(
              onPressed: _stopListening,
              tooltip: 'Stop listening',
              child: const Icon(Icons.mic_off),
            )
          : null,
    );
  }

  Widget _buildBackground(ThemeData theme) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme, bool isDark) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: InkWell(
          onTap: _pickImage,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 320,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primaryContainer.withOpacity(0.4),
                  theme.colorScheme.primaryContainer.withOpacity(0.2),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: _image == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tap to take a photo',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.file(_image!, fit: BoxFit.cover),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesField(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: 'Add Notes',
              hintText: 'e.g., fever, cough, skin rash',
              prefixIcon:
                  Icon(Icons.notes_rounded, color: theme.colorScheme.primary),
              suffixIcon: IconButton(
                icon: Icon(
                    _speechToText.isListening ? Icons.mic : Icons.mic_none),
                tooltip: 'Tap to speak',
                onPressed: _speechEnabled
                    ? (_speechToText.isListening
                        ? _stopListening
                        : _startListening)
                    : null,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.transparent,
            ),
            maxLines: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _analyzeImage,
        icon: const Icon(Icons.analytics_rounded),
        label: const Text(
          'Analyze Image',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      children: [
        CircularProgressIndicator(
          strokeWidth: 3,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Analyzing image...',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ).animate(onPlay: (controller) => controller.repeat()).shimmer(
          duration: 1500.ms,
          color: Color.fromRGBO(
            theme.colorScheme.primary.red,
            theme.colorScheme.primary.green,
            theme.colorScheme.primary.blue,
            0.3,
          ),
        );
  }

  Widget _buildResultCard(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Color.fromRGBO(
              theme.colorScheme.surfaceVariant.red,
              theme.colorScheme.surfaceVariant.green,
              theme.colorScheme.surfaceVariant.blue,
              0.4,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(
                        theme.colorScheme.primary.red,
                        theme.colorScheme.primary.green,
                        theme.colorScheme.primary.blue,
                        0.2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.medical_information_rounded,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Analysis Result',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SelectableText(
                _analysisResult!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
