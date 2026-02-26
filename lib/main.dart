import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main()
{
  runApp(MaterialApp(home:UploadImage()));
}

class UploadImage extends StatefulWidget
{
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage>
{
  TextEditingController name = TextEditingController();
  File _imageFile = File("");

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
        appBar: AppBar(title: Text("Upload Data"),),
        body: Center
          (
            child: Column
              (
                children:
                [
                  TextField(controller:name,decoration: InputDecoration(hintText: "Enter Category"),),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()
                  {
                    chooseimage();

                  }, child: Text("Choose File")),
                  SizedBox(height: 10,),
                  ElevatedButton(onPressed: ()
                  {
                    uploadimage();
                  }, child: Text("Upload")),

                ],
              ),
          ),
      );
  }

  void chooseimage()async
  {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if(pickedFile!=null)
    {
      setState(()
      {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void uploadimage() async
  {
    var url = "https://prakrutitech.xyz/API/upload.php";
    var url2 =await Uri.parse(url);
    var request = http.MultipartRequest('POST', url2)
      ..fields['category_name'] = name.text.toString()
      ..files.add(await http.MultipartFile.fromPath('category_img', _imageFile.path));
    var response = await request.send();
    if (response.statusCode == 200)
    {
      print('Data uploaded successfully');

    } else {
      print('Failed to upload data. Error: ${response.statusCode}');
    }
  }
}
