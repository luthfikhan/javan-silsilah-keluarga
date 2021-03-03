import 'package:flutter/material.dart';
import 'package:javan_silsilah_keluarga/components/primary_button.dart';
import 'package:javan_silsilah_keluarga/constans.dart';
import 'package:javan_silsilah_keluarga/db/database_helper.dart';
import 'package:javan_silsilah_keluarga/model/user_model.dart';

class GrandchildDetailView extends StatefulWidget {
  final UserModel parent;
  final UserModel userModel;

  const GrandchildDetailView({Key key, this.parent, this.userModel})
      : super(key: key);

  @override
  _GrandchildDetailViewState createState() => _GrandchildDetailViewState();
}

class _GrandchildDetailViewState extends State<GrandchildDetailView> {
  GENDER _jenisKelamin;
  TextEditingController _name = TextEditingController();
  DatabaseHelper _databaseHelper;

  _updateUserData() async {
    try {
      await _databaseHelper.updateUser(UserModel(
          genderId: _jenisKelamin.index,
          name: _name.text,
          status: widget.userModel.status,
          id: widget.userModel.id,
          ortuId: widget.userModel.ortuId));
      Navigator.pop(context, true);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    _jenisKelamin = listJenisKelamin[widget.userModel.genderId];
    _name.text = widget.userModel.name;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keluarga: ${widget.parent.name}'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _name,
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: PrimaryButton(
          buttonText: 'SIMPAN',
          onTap: () async {
            if (_name.text.isNotEmpty && _name.text != widget.userModel.name ||
                _jenisKelamin.index != widget.userModel.genderId) {
              _updateUserData();
              return;
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
