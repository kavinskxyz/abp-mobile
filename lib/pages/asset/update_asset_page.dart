import 'dart:convert';
import 'dart:typed_data';

import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../config/app_constant.dart';
import '../../models/asset_model.dart';

class UpdateAssetPage extends StatefulWidget {
  const UpdateAssetPage({super.key, required this.oldAsset});
  final AssetModel oldAsset;

  @override
  State<UpdateAssetPage> createState() => _UpdateAssetPageState();
}

class _UpdateAssetPageState extends State<UpdateAssetPage> {
  final formkey = GlobalKey<FormState>();
  final edtName = TextEditingController();
  List<String> types = [
    'Clothes',
    'Transfortation',
    'Electronic',
    'Place',
    'House',
    'Aprtment',
    'Property',
    'Other',
  ];
  String type = 'Property';
  String? imageName;
  Uint8List? imageByte;

  pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      // if there data
      imageName = picked.name;
      imageByte = await picked.readAsBytes();
      setState(() {});
    }
    DMethod.printBasic('imageName: $imageName');
  }

  save() async {
    bool isValidInput = formkey.currentState!.validate();
    // if not valid, stop/return
    if (!isValidInput) return;

    // if valid, go on

    Uri url = Uri.parse(
      'http://192.168.212.22/update.php',
    );
    try {
      final response = await http.post(url, body: {
        'id': widget.oldAsset.id,
        'name': edtName.text,
        'type': type,
        'old_image': widget.oldAsset.image,
        'new_image': imageName ?? widget.oldAsset.image,
        'new_base64code':
            imageByte == null ? '' : base64Encode(imageByte as List<int>),
      });
      DMethod.printResponse(response);

      Map resBody = jsonDecode(response.body);
      bool success = resBody['success'] ?? false;
      if (success) {
        DInfo.toastSuccess('Success Update Asset');
        Navigator.pop(context);
      } else {
        DInfo.toastError('Failed Update Asset');
      }
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
    }
  }

  @override
  void initState() {
    edtName.text = widget.oldAsset.name;
    type = widget.oldAsset.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Asset'),
        centerTitle: true,
      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DInput(
              controller: edtName,
              title: 'Name',
              hint: 'Vas Bunga',
              fillColor: Colors.white,
              validator: (input) => input == '' ? "Don't empty" : null,
              radius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 16),
            const Text(
              'Type',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField(
              value: type,
              icon: const Icon(Icons.keyboard_arrow_down),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
              items: types.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  type = value;
                }
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: imageByte == null
                    ? Image.network(
                        'http://192.168.1.16/image/${widget.oldAsset.image}',
                      )
                    : Image.memory(imageByte!),
              ),
            ),
            ButtonBar(
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text('Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => save(),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
