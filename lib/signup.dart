import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  SignUp();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email;
  String _password;
  String _dropDownValue;
  String _firstName;
  String _fileName = "";
  List<PlatformFile> _paths = [];
  bool _loadingPath = false;
  String _extension;
  String _directoryPath;
  // List<String> _locations = ['india', 'usa', 'australia', 'uk'];
  String _selectedLocation;
  List<String> _locations = [];

  @override
  void initState() {
    fetchCountries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(title: new Text("Employee Details")),
      body: new Container(
        width: 500,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(child: Card(child: formSetup(context))),
      ),
    );
  }

  Widget formSetup(BuildContext context) {
    return new Form(
      key: _formKey,
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          imageSelection(),
          editField(
            _firstName,
            "user name",
            TextInputType.name,
            (val) {
              if (val.length == 0)
                return "Please enter user name";
              else
                return null;
            },
            false,
          ),
          editField(
            _email,
            "email",
            TextInputType.emailAddress,
            (val) {
              if (val.length == 0)
                return "Please enter email";
              else if (!val.contains("@"))
                return "Please enter valid email";
              else
                return null;
            },
            false,
          ),
          editField(
            _password,
            "password",
            TextInputType.emailAddress,
            (val) {
              if (val.length == 0)
                return "Please enter password";
              else if (val.length <= 5)
                return "Your password should be more then 6 char long";
              else
                return null;
            },
            true,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                hintText: "",
                labelText: "country",
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              value: "India",
              onChanged: (newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
              },
              validator: (_selectedLocation) {
                if (_selectedLocation.length == 0)
                  return "select country";
                else
                  return null;
              },
              items: _locations.map((location) {
                return DropdownMenuItem(
                  child: new Text(location),
                  value: location,
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: RaisedButton(
              child: new Text("Submit"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _scaffoldKey.currentState.showSnackBar(
                    new SnackBar(
                      content: new Text("registered",
                          style: TextStyle(color: Colors.white)),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  editField(String value, String hintText, TextInputType inputType,
      Function validator, bool showText) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: "",
          labelText: hintText,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(5.0),
            borderSide: new BorderSide(),
          ),
        ),
        keyboardType: inputType,
        validator: validator,
        onSaved: (val) => value = val,
        obscureText: showText,
      ),
    );
  }

  Widget emptyUpload() {
    return InkWell(
      child: Container(
        height: 150,
        width: 120,
        color: Colors.grey,
        child: Center(
          child: Text("Upload"),
        ),
      ),
      onTap: _openFileExplorer,
    );
  }

  Widget imageSelection() {
    return Container(
      margin: EdgeInsets.all(10),
      child: _paths.isEmpty ? emptyUpload() : showImage(),
    );
  }

  void _openFileExplorer() async {
    setState(() => _loadingPath = true);
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '')?.split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      _loadingPath = false;
      _fileName = _paths != null ? _paths.map((e) => e.name).toString() : '...';
    });
  }

  showImage() {
    if (kIsWeb) {
      return Image.memory(
        _paths[0].bytes,
        height: 150,
        width: 120,
        fit: BoxFit.fill,
      );
    } else {
      if (_paths != null) {
        File file = File(_paths.single.path);
        return Image.file(
          file,
          height: 150,
          width: 120,
          fit: BoxFit.fill,
        );
      }
    }
  }

  Future<void> fetchCountries() async {
    var dio = Dio();
    Response response = await dio
        .get('http://www.json-generator.com/api/json/get/bTVoyXnuKW?indent=2');
    List<dynamic> countries = response.data.toList();
    var sList = List<String>.from(countries);
    setState(() {
      _locations.addAll(sList);
    });
  }
}
