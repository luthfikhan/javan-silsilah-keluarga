import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:javan_silsilah_keluarga/db/database_helper.dart';
import 'package:javan_silsilah_keluarga/model/user_model.dart';
import 'package:javan_silsilah_keluarga/view/additional_data_view.dart';
import 'package:javan_silsilah_keluarga/view/child_details_view.dart';
import 'package:javan_silsilah_keluarga/view/grandchild_detail_view.dart';

class ChildrenView extends StatefulWidget {
  @override
  _ChildrenViewState createState() => _ChildrenViewState();
}

class _ChildrenViewState extends State<ChildrenView> {
  DatabaseHelper _databaseHelper;
  List<UserModel> _users = [];
  UserModel _userModel;

  _getDataAnakCucu() async {
    _users = await _databaseHelper.getAnakCucu();
    setState(() {});
  }

  _getDataDiri() async {
    _userModel = await _databaseHelper.getUserDetail(1);
    setState(() {});
  }

  @override
  void initState() {
    _databaseHelper = DatabaseHelper();
    _getDataAnakCucu();
    _getDataDiri();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Daftar Keluarga ${_userModel == null ? '' : _userModel.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [_buildDaftarKeluarga(), _buildTambahDaftarKeluarga()],
        ),
      ),
    );
  }

  Container _buildDaftarKeluarga() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white))),
      child: Builder(builder: (context) {
        if (_users.isEmpty) {
          return Text(
            'Anda belum memasukan data keluarga anda',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          );
        }

        return GroupedListView<UserModel, int>(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          elements: _users,
          groupComparator: (value1, value2) {
            return value1.compareTo(value2);
          },
          groupBy: (u) => u.status,
          groupSeparatorBuilder: (value) {
            if (value == 1) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  'Daftar anak anda',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              );
            }

            if (value == 2) {
              return Padding(
                padding: EdgeInsets.only(top: 16, bottom: 12),
                child: Text(
                  'Daftar cucu anda',
                  style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              );
            }
            return Text('');
          },
          itemBuilder: (_, user) {
            return InkWell(
              onTap: () async {
                if (user.status == 1) {
                  await Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return ChildDetailView(
                      userModel: user,
                    );
                  }));

                  _getDataAnakCucu();
                }
                if (user.status == 2) {
                  await Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return GrandchildDetailView(
                      userModel: user,
                      parent: _users
                          .firstWhere((element) => element.id == user.ortuId),
                    );
                  }));

                  _getDataAnakCucu();
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.grey[350]))),
                child: Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text(user.name,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    )),
                    InkWell(
                      onTap: () async {
                        await _databaseHelper.delete(user.id);
                        _getDataAnakCucu();
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.grey[350],
                        size: 24,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Container _buildTambahDaftarKeluarga() {
    return Container(
      padding: EdgeInsets.only(top: 30, left: 20, bottom: 12),
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
                        return AdditionalDataView(
                          userModel: _userModel,
                        );
                      })) ??
                      false;
              if (b) _getDataAnakCucu();
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
                  'Tambahkan data anak anda',
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
