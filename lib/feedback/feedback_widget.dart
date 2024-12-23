import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FeedbackSupportPage extends StatelessWidget {
  final String baseUrl = "${kDebugMode ? "http://127.0.0.1:8000": "https://sx6s6j6f-8000.asse.devtunnels.ms/"}/feedback/submit_feedback_anonymous/"; // Ganti dengan URL yang benar

  const FeedbackSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0, bottom: 15),
              child: Image.asset(
                'images/depokrasa-logo.png',
                width: 198,
                height: 52,
              ),
            ),
          ),
          Positioned(
            top: 95, // Posisi di bawah logo
            left: 16, // Mepet kiri
            child: const Text(
              'Feedback & Support',
              style: TextStyle(
                fontSize: 20, // Ukuran font
                color: Colors.black, // Warna hitam
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 130), // Spasi tambahan agar konten tidak bertabrakan dengan teks
                Expanded(
                  child: ListView(
                    children: const [
                      ExpandableItem(
                        question: "How Can I Get Started?",
                        answer:
                            "You can get started by signing up and exploring our platform.",
                      ),
                      ExpandableItem(
                        question: "What is the info I can get?",
                        answer:
                            "You can find details about our services, features, and more.",
                      ),
                      ExpandableItem(
                        question: "What kind of support do you provide?",
                        answer:
                            "We provide technical support, guidance, and troubleshooting.",
                      ),
                      ExpandableItem(
                        question: "Can I book an appointment with a restaurant?",
                        answer:
                            "Yes, you can use our app to schedule appointments easily.",
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: screenHeight * 0.08,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => FeedbackForm(apiUrl: apiUrl),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Feedback'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class ExpandableItem extends StatefulWidget {
  final String question;
  final String answer;

  const ExpandableItem(
      {super.key, required this.question, required this.answer});

  @override
  // ignore: library_private_types_in_public_api
  _ExpandableItemState createState() => _ExpandableItemState();
}

class _ExpandableItemState extends State<ExpandableItem> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.answer,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  final String apiUrl; // API endpoint to send feedback

  const FeedbackForm({super.key, required this.apiUrl});

  @override
  // ignore: library_private_types_in_public_api
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Future<void> submitFeedback() async {
    try {
      final response = await http.post(
        Uri.parse(widget.apiUrl),
        headers: {
          'Content-Type': 'application/json', // Kirim sebagai JSON
        },
        body: jsonEncode({
          'subject': subjectController.text,
          'message': messageController.text,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        final errorResponse = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error: ${errorResponse['error'] ?? 'Failed to submit feedback'}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Feedback Form'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: subjectController,
                decoration: const InputDecoration(
                  labelText: 'Subject',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Subject cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: messageController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Message cannot be empty';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              submitFeedback();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}