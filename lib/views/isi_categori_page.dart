import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:responsi_123100090/controller/controller.dart';
import 'package:responsi_123100090/models/meals.dart';
import 'package:responsi_123100090/views/detail_page.dart';

class MealsView extends StatefulWidget {
  final String text;

  const MealsView({Key? key, required this.text}) : super(key: key);

  @override
  _MealsViewState createState() => _MealsViewState();
}

class _MealsViewState extends State<MealsView> {
  // late String strMealThumb;
  // late String strMeal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.text + ' Meal',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
        // FutureBuilder() membentuk hasil Future dari request API
        child: FutureBuilder(
          future: MealSource.instance.loadMeal(widget.text),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasError || widget.text.isEmpty) {
              return _buildErrorSection();
            }
            if (snapshot.hasData) {
              Makanan maem = Makanan.fromJson(snapshot.data);
              return _buildSuccessSection(maem);
            }
            return _buildLoadingSection();
          },
        ),
      ),
    );
  }

  // Jika API sedang dipanggil
  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorSection() {
    if (widget.text.isEmpty) {
      return const Text("");
    } else {
      return const Text("Error");
    }
  }

  // Jika data ada
  Widget _buildSuccessSection(Makanan data) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Jumlah kolom dalam grid
        crossAxisSpacing: 8.0, // Jarak horizontal antar item
        mainAxisSpacing: 8.0, // Jarak vertikal antar item
      ),
      itemCount: data.meals?.length,
      itemBuilder: (BuildContext context, int index) {
        final maem = data.meals![index];
        return Padding(
          padding:
              EdgeInsets.all(8.0), // Tambahkan padding di sini sesuai kebutuhan
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodDetailPage(foodId: maem.idMeal!),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: Image.network(
                        maem.strMealThumb as String,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      maem.strMeal as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
