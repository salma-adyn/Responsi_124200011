import 'package:flutter/material.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: <Widget>[
            Image.asset('assets/logo.png'),
          ],
          title: Text("STORE"),
          centerTitle: true,
          backgroundColor: Colors.green
      ),
      body: _buildDetailClothing(),
    );
  }

  Widget _buildDetailClothing() {
    return Container(
      child: FutureBuilder(
        future: BaseNetwork.get(''),
        builder: (BuildContext context,
            AsyncSnapshot<dynamic> snapshot,) {
          if (snapshot.hasError) {
            print(snapshot);
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            ClothingDataModel clothingModel =
            ClothingDataModel.fromJson(snapshot.data);
            print(clothingModel);
            return _buildSuccessSection(clothingModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  Widget _buildEmptySection() {
    return Text("Empty");
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(ClothingDataModel data) {
    return GridView.builder(
      itemCount: data.clothing?.length,
      itemBuilder: (BuildContext context, int index) {
        final ClothingData? clothing = data.clothing?[index];
        return Card(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PageDetail(clothing: clothing,)
                    )
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(0.0, 5.0),
                              blurRadius: 10.0,
                              spreadRadius: -6.0
                          ),
                        ],
                        image: DecorationImage(
                            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.multiply),
                            image: NetworkImage("${data.clothing?[index].image}"),
                            fit: BoxFit.cover
                        )
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 100,
                                  width: 150,
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(15),
                                  ),

                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${data.clothing?[index].title}", style: TextStyle(color: Colors.white),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  )],
              ),
            )
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 5.0,
      ),
    );
  }

  Widget _buildItemClothing(String value) {
    return Text(value);
  }
}