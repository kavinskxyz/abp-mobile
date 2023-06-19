import 'dart:convert';
import 'package:course_asset_management/config/app_constant.dart';
import 'package:course_asset_management/models/asset_model.dart';
import 'package:course_asset_management/pages/asset/create_asset_page.dart';
import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchAssetPage extends StatefulWidget {
  const SearchAssetPage({super.key});

  @override
  State<SearchAssetPage> createState() => _SearchAssetPageState();
}

class _SearchAssetPageState extends State<SearchAssetPage> {
  List<AssetModel> assets = [];
  final edtSearch = TextEditingController();

  searchAssets() async {
    if (edtSearch.text=='') return;

    assets.clear();
    setState(() {});

    Uri url = Uri.parse('${AppConstant.baseURL}/asset/search.php');
    try {
       final response = await http.post(url, body: {
        'search': edtSearch(response);


       });
       bool success = resBody['success'] ?? false;
       if (success) {
        List data = resBody['data'];
        assets = data.map((e) => AssetModel.fromJson(e)). toList();
       }

       setState(() {});
    } catch(e) {
        DMethod.printTitle('catch', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(30),
            ), // BoxDecoration
            aligment: Aligment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
                controller: edtSearch,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText:'Search here..'
                    isDense: true,
                ), // InputDecoration
              ), // TextField
            ), // Container
        )
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
        ), // IconButton
      ],
    ), // Column
    : GridView.builder(
      itemCount: assets.length,
      padding: const EdgeInsets.fromTRB(16, 16, 16, 80)
      gridDelegate: const SliverGridDelegateWithFixedCro
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisspacing: 16,
        childAspectRatio: 0.8,
       ), // SliverGridDelegateWithFixedCrossAxisCount
       itemBuilder: (context, index) {
         AssetModel item = assets[index];
         return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'http://192.168.1.26/image/' + item.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ), // Image.network
                        ), // ClipRRect
                      ), // Expanded
                      const SizedBox(height: 8),
                          children: [
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    item.type,
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                              color: Colors.purple[50],
                            ),
                        },
                    }
                }
