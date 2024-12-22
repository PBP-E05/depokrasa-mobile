import 'package:depokrasa_mobile/screen/menu.dart' as menu;
import 'package:flutter/material.dart';
import 'dart:typed_data'; // Untuk Uint8List
import 'package:image_picker/image_picker.dart';
import 'package:depokrasa_mobile/shared/bottom_navbar.dart';

class AddMenuForm extends StatefulWidget {
  const AddMenuForm({Key? key}) : super(key: key); // Remove user parameter

  @override
  State<AddMenuForm> createState() => _AddMenuFormState();
}

class _AddMenuFormState extends State<AddMenuForm> {
  final _formKey = GlobalKey<FormState>();
  String _foodName = "";
  String _restaurantName = "";
  String _price = "";
  Uint8List? _imageBytes; // Gunakan Uint8List untuk gambar
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async { // Tambahkan 'async'
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() async {
        _imageBytes = await pickedFile.readAsBytes(); // Baca sebagai byte array
      });
    }
  }

  int _currentIndex = 0;

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const menu.DepokRasaHomePage(),
              ),
            );
          },
        ),
        title: const Text('Tambah Menu'),
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upload Foto
                GestureDetector(
                  onTap: () async {
                    await _pickImage(); // Pastikan ada 'await'
                  },
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _imageBytes == null
                        ? const Icon(Icons.add, size: 50, color: Colors.grey)
                        : Image.memory(_imageBytes!, fit: BoxFit.cover), // Gunakan Image.memory
                  ),
                ),
                const SizedBox(height: 16),

                // Input Nama Makanan
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Masukan Nama',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _foodName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama makanan tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Nama Restoran
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Masukan Nama Restoran',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _restaurantName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama restoran tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input Harga
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Masukan Harga',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _price = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga tidak boleh kosong!';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Harga harus berupa angka!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Tombol Submit
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Kembalikan data ke halaman utama
                        Navigator.pop(context, {
                          'foodName': _foodName,
                          'restaurantName': _restaurantName,
                          'price': _price,
                          'imageBytes': _imageBytes,
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
