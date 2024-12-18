import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:depokrasa_mobile/models/featured_news.dart';
import 'package:depokrasa_mobile/models/user.dart' as depokrasa_user;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

class AddNewsPage extends StatefulWidget {
  final depokrasa_user.User user;
  final VoidCallback onNewsSubmitted; // Add a callback

  const AddNewsPage(
      {Key? key, required this.user, required this.onNewsSubmitted})
      : super(key: key);

  @override
  _AddNewsPageState createState() => _AddNewsPageState();
}

class _AddNewsPageState extends State<AddNewsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _grandTitleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _timeAddedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authorController.text = widget.user.username;
    _timeAddedController.text = DateTime.now().toIso8601String();
  }

  // Image files
  File? _iconImage;
  File? _grandImage;

  // Image picker
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImage(bool isIconImage) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isIconImage) {
          _iconImage = File(pickedFile.path);
        } else {
          _grandImage = File(pickedFile.path);
        }
      });
    }
  }

  Future<String?> _uploadImage(File image, String path) async {
  try {
    // Ensure Supabase is properly initialized
    if (Supabase.instance.client == null) {
      print('Supabase client is not initialized');
      return null;
    }

    final supabaseClient = Supabase.instance.client;
    final bytes = await image.readAsBytes();

    final uploadResponse = await supabaseClient.storage
        .from('images')
        .uploadBinary(
          path, 
          bytes,
          fileOptions: FileOptions(
            contentType: 'image/png',
            upsert: true
          ),
        );

    final publicUrl = supabaseClient.storage
        .from('images')
        .getPublicUrl(path);

    return publicUrl;
  } catch (error) {
    print('Upload Error Details:');
    print(error);
    print('Error Type: ${error.runtimeType}');
    return null;
  }
}

  // Submit news
  void _submitNews() async {
    if (_formKey.currentState!.validate()) {
      // Create FeaturedNews object
      final news = FeaturedNews(
        id: Uuid().v4(), // Add this line
        title: _titleController.text.trim(),
        iconImage: '',
        grandTitle: _grandTitleController.text.trim(),
        content: _contentController.text.trim(),
        author: widget.user.username,
        grandImage: '',
        cookingTime: int.tryParse(_cookingTimeController.text) ?? 0,
        calories: int.tryParse(_caloriesController.text) ?? 0,
        timeAdded: DateTime.now().toIso8601String(),
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      String? iconImageUrl;
      String? grandImageUrl;

      if (_iconImage != null) {
        iconImageUrl = await _uploadImage(_iconImage!, 'icons/${news.id}.png');
      }

      if (_grandImage != null) {
        grandImageUrl =
            await _uploadImage(_grandImage!, 'grands/${news.id}.png');
      }

      final updatedNews = news.copyWith(
        iconImage: iconImageUrl ?? '',
        grandImage: grandImageUrl ?? '',
      );

      String baseUrl = dotenv.env['BASE_URL'] ?? "http://127.0.0.1:8000";
      String apiUrl = "$baseUrl/create-news/";

      Map<String, dynamic> newsJson = updatedNews.toJson();

      String jsonPayload = jsonEncode(newsJson);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonPayload,
      );

      if (response.statusCode == 200) {
        widget.onNewsSubmitted(); // Call the callback
        _showSuccessDialog();
      } else {
        final responseData = jsonDecode(response.body);
        _showErrorDialog(responseData['message']);
      }
    }
  }

  // Success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('News Added Successfully'),
        content: const Text('Your news has been submitted.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to previous screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add News'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Input
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  prefixIcon: const Icon(Icons.title),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Grand Title Input
              TextFormField(
                controller: _grandTitleController,
                decoration: InputDecoration(
                  labelText: 'Grand Title',
                  prefixIcon: const Icon(Icons.title_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a grand title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Content Input
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  prefixIcon: const Icon(Icons.article),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Cooking Time Input
              TextFormField(
                controller: _cookingTimeController,
                decoration: InputDecoration(
                  labelText: 'Cooking Time (minutes)',
                  prefixIcon: const Icon(Icons.timer),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter cooking time';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Calories Input
              TextFormField(
                controller: _caloriesController,
                decoration: InputDecoration(
                  labelText: 'Calories',
                  prefixIcon: const Icon(Icons.local_fire_department),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter calories';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Author Input
              TextFormField(
                controller: _authorController,
                decoration: InputDecoration(
                  labelText: 'Author',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Time Added Input
              TextFormField(
                controller: _timeAddedController,
                decoration: InputDecoration(
                  labelText: 'Time Added',
                  prefixIcon: const Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Icon Image Picker
              _buildImagePickerCard(
                title: 'Pick Icon Image',
                image: _iconImage,
                onPickImage: () => _pickImage(true),
              ),
              const SizedBox(height: 16),

              // Grand Image Picker
              _buildImagePickerCard(
                title: 'Pick Grand Image',
                image: _grandImage,
                onPickImage: () => _pickImage(false),
              ),
              const SizedBox(height: 16),

              // Submit Button
              ElevatedButton(
                onPressed: _submitNews,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Submit News',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable image picker card
  Widget _buildImagePickerCard({
    required String title,
    required File? image,
    required VoidCallback onPickImage,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPickImage,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Image preview or icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                  image: image != null
                      ? DecorationImage(
                          image: FileImage(image),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: image == null
                    ? const Icon(
                        Icons.add_photo_alternate,
                        size: 40,
                        color: Colors.grey,
                      )
                    : null,
              ),
              const SizedBox(width: 16),

              // Text and hint
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      image == null ? 'Tap to select image' : 'Image selected',
                      style: TextStyle(
                        color: image == null ? Colors.grey : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),

              // Change/Add button
              Icon(
                image == null ? Icons.add : Icons.change_circle_outlined,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers
    _titleController.dispose();
    _grandTitleController.dispose();
    _contentController.dispose();
    _cookingTimeController.dispose();
    _caloriesController.dispose();
    _authorController.dispose();
    _timeAddedController.dispose();
    super.dispose();
  }
}
