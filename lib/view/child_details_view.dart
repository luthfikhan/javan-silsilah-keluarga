import 'package:flutter/material.dart';
import 'package:javan_silsilah_keluarga/components/primary_button.dart';
import 'package:javan_silsilah_keluarga/constans.dart';
import 'package:javan_silsilah_keluarga/db/database_helper.dart';
import 'package:javan_silsilah_keluarga/model/user_model.dart';
import 'package:javan_silsilah_keluarga/view/grandchild_detail_view.dart';

import 'additional_data_view.dart';

class ChildDetailView extends StatefulWidget {
  final UserModel userModel;

  const ChildDetailView({Key key, this.userModel}) : super(key: key);

  @override
  _ChildDetailViewState createState() => _ChildDetailViewState();
}

class _ChildDetailViewState extends State<ChildDetailView> {
  GENDER _jenisKelamin;
  TextEditingController _name = TextEditingController();
  DatabaseHelper _databaseHelper;
  List<UserModel> _children = [];

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

  _getAnak() async {
    _children = await _databaseHelper.getAnakByIdOrtu(widget.userModel.id);
    setState(() {});
  }

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    _jenisKelamin = listJenisKelamin[widget.userModel.genderId];
    _name.text = widget.userModel.name;
    _getAnak();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keluarga: ${widget.userModel.name}'),
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
            Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'Daftar anak ${widget.userModel.name}',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 8)),
            Builder(builder: (c) {
              if (_children.isEmpty) {
                return Text('Belum ada data');
              }
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _children.length,
                  itemBuilder: (c, i) {
                    return InkWell(
                      onTap: () async {
                        bool b = await Navigator.push(context,
                                MaterialPageRoute(builder: (c) {
                              return GrandchildDetailView(
                                userModel: _children[i],
                                parent: widget.userModel,
                              );
                            })) ??
                            false;

                        if (b) _getAnak();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.grey[350]))),
                        child: Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Text(_children[i].name,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    );
                  });
            }),
            _buildTambahDaftarKeluarga()
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

  Container _buildTambahDaftarKeluarga() {
    return Container(
      padding: EdgeInsets.only(top: 30, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tambahkan data',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Padding(
              padding: EdgeInsets.only(
            top: 14,
          )),
          InkWell(
            onTap: () async {
              bool b =
                  await Navigator.push(context, MaterialPageRoute(builder: (c) {
                        return AdditionalDataView(userModel: widget.userModel);
                      })) ??
                      false;
              if (b) _getAnak();
            },
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 6,
                            offset: Offset(0, 3),
                            color: Colors.black.withOpacity(0.16))
                      ]),
                  width: 50,
                  height: 50,
                  child: Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.grey[350],
                  ),
                ),
                Expanded(
                    child: Text(
                  'Tambahkan data anak ${widget.userModel.name}',
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
