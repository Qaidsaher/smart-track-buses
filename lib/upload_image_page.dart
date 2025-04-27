import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:aws_signature_v4/aws_signature_v4.dart';

class UploadImagePage extends StatefulWidget {
  const UploadImagePage({super.key});

  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  File? _imageFile;
  bool _isUploading = false;

  final String bucketName = "ash-smarttrack";
  final String region = "eu-north-1";
  final String accessKey = "AKIA22MARJBURSWUDZF6";
  final String secretKey = "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";

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    setState(() => _isUploading = true);

    final fileName = path.basename(_imageFile!.path);
    final mimeType =
        lookupMimeType(_imageFile!.path) ?? 'application/octet-stream';
    final fileBytes = await _imageFile!.readAsBytes();

    final host = '$bucketName.s3.$region.amazonaws.com';
    final uri = Uri.https(host, '/$fileName');

    final credentials = AWSCredentials(accessKey, secretKey);
    final signer = AWSSigV4Signer(
      credentials: credentials,
      region: region,
      service: AWSService.s3,
    );

    final signedRequest = await signer.sign(
      method: AWSHttpMethod.put,
      host: host,
      path: '/$fileName',
      headers: {'Content-Type': mimeType},
      body: fileBytes,
    );

    final response = await http.put(
      Uri.parse(signedRequest.url.toString()),
      headers: signedRequest.headers,
      body: fileBytes,
    );

    setState(() => _isUploading = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Uploaded successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed (${response.statusCode})')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Image to S3")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _imageFile != null
                ? Image.file(_imageFile!, height: 200)
                : const Text("No image selected"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Pick Image"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadImage,
              child:
                  _isUploading
                      ? const CircularProgressIndicator()
                      : const Text("Upload to S3"),
            ),
          ],
        ),
      ),
    );
  }
}
