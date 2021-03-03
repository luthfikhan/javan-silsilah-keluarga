import 'package:flutter/material.dart';
import 'package:javan_silsilah_keluarga/components/primary_button.dart';
import 'package:javan_silsilah_keluarga/constans.dart';
import 'package:javan_silsilah_keluarga/db/database_helper.dart';
import 'package:javan_silsilah_keluarga/model/user_model.dart';
import 'package:javan_silsilah_keluarga/view/home_view.dart';

class UserProfileView extends StatefulWidget {
  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  GENDER _jenisKelamin;
  String _name = '';
  DatabaseHelper _databaseHelper;

  _insertUserData() async {
    try {
      await _databaseHelper.insertUser(UserModel(
        genderId: _jenisKelamin.index,
        name: _name,
      ));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
        return HomeView();
      }));
    } catch (e) {
      print(e.toString());
    }
  }

  _checkDb() async {
    bool exists = await _databaseHelper.dbExists();

    if (exists) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
        return HomeView();
      }));
    }
  }

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    _checkDb();
    _jenisKelamin = listJenisKelamin[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Memulai'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Silahkan masukan data diri anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Padding(padding: EdgeInsets.only(bottom: 16)),
            TextField(
              onChanged: (text) {
                _name = text;
              },
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nama',
              ),
            ),
            Padding(padding: EdgeInsets.only(bottom: 16)),
            DropdownButtonFormField<GENDER>(
              onChanged: (v) {
                setState(() {
                  _jenisKelamin = v;
                });
              },
              value: _jenisKelamin,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Jenis kelamin',
              ),
              items: List<DropdownMenuItem<GENDER>>.generate(
                  listJenisKelamin.length,
                  (index) => DropdownMenuItem<GENDER>(
                      value: listJenisKelamin[index],
                      child: Text(
                          '${listJenisKelamin[index].index == 0 ? 'Laki-laki' : 'Perempuan'}'))),
            ),
            Spacer(),
            PrimaryButton(
              buttonText: 'SUBMIT',
              onTap: () async {
                if (_name.isNotEmpty) {
                  _insertUserData();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
