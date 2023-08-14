import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweets_key/telaPrincipal/ResponsiveLayout/Mobile/ListWidgetMobile.dart';

class MobileNavigation extends StatefulWidget {
  const MobileNavigation({super.key});

  @override
  State<MobileNavigation> createState() => _MobileNavigationState();
}

class _MobileNavigationState extends State<MobileNavigation> {
  List<String> imageUrls = [];
  List<String> textBolos = [];
  List<String> textotest = [];
  String imageList = '';

  Future<void> getData() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('bolos').get();
    /*await FirebaseFirestore.instance
        .collection('bolos')
        .doc('Tradicionais')
        .set({
      'image':
          'https://static.wixstatic.com/media/9ec495_ec83a62813424056b8caf0096c46f85b~mv2_d_2658_1772_s_2.jpg/v1/fill/w_663,h_440,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Bolo%20Simples.jpg',
      'images': textotest,
      'nomes': textotest,
      'valor': textotest,
    });*/
    snapshot.docs.forEach((element) {
      textBolos.add(element.id);
      //print(element.id);
    });
    for (String i in textBolos) {
      imageUrls.add(await getImagePerfil(i));
    }
  }

  Future<String> getImagePerfil(String colecao) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('bolos').doc(colecao).get();

    String listaImages = snapshot['image'];
    return listaImages;
  }

  Future<List<String>> getCategorias(String colecao, String tip) async {
    DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.collection('bolos').doc(colecao).get();

    if (tip == 'images') {
      List<String> listaImages = List<String>.from(snapshot['images']);
      imageList = snapshot['image'];
      return listaImages;
    } else if (tip == 'nomes') {
      List<String> listaNomes = List<String>.from(snapshot['nomes']);
      return listaNomes;
    } else {
      List<String> listaValor = List<String>.from(snapshot['valor']);
      return listaValor;
    }
  }

  Future<List<String>> getPopulares(String tip) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('especial')
        .doc('Populares')
        .get();

    if (tip == 'images') {
      List<String> listaImages = List<String>.from(snapshot['images']);
      imageList = snapshot['image'];
      return listaImages;
    } else if (tip == 'nomes') {
      List<String> listaNomes = List<String>.from(snapshot['nomes']);
      return listaNomes;
    } else {
      List<String> listaValor = List<String>.from(snapshot['valor']);
      return listaValor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        scrolledUnderElevation: 5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Sweets",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'lobster',
                    color: Colors.black),
              ),
            ),
            SizedBox(width: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/key going into the strawberryCUT.png",
                fit: BoxFit.contain,
                height: 50,
                width: 50,
              ),
            ),
            SizedBox(width: 8.0),
            FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Key",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'lobster',
                    color: Colors.black),
              ),
            ),
          ],
        ),
        actions: [
          //IconButton(onPressed: (){}, icon: Icon(icon))
        ],
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro ao carregar os dados'));
            } else {
              List<String> bolos = textBolos;
              return ListView(children: [
                Stack(
                  children: [
                    CarouselSlider.builder(
                      itemCount: 3,
                      itemBuilder:
                          (BuildContext context, int index, int realIndex) {
                        return Card(
                          elevation: 10,
                          shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const CircularProgressIndicator();
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/boloiconreserve.png',
                                  fit: BoxFit.contain,
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                  width: MediaQuery.of(context).size.width,
                                );
                              },
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 300,
                        viewportFraction: 0.8,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(224, 249, 108, 148),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: MediaQuery.of(context).size.width / 3,
                      right: MediaQuery.of(context).size.width / 3,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 50.0),
                            child: Text(
                              "Populares",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: 'lobster',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor: Color(0XFFfb4a7a),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () async {
                              List<String> imagesList =
                                  await getPopulares('images');
                              List<String> nomesList =
                                  await getPopulares('nomes');
                              List<String> valorList =
                                  await getPopulares('valor');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListWidgetMobile(
                                      images: imagesList,
                                      nomes: nomesList,
                                      valor: valorList,
                                      image: imageList,
                                    ),
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Ver Todos",
                                style: TextStyle(
                                    fontFamily: 'lobster', fontSize: 30),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  "assets/linelovepik2.png",
                  fit: BoxFit.cover,
                ),
                Stack(
                  children: [
                    Image.asset(
                      'assets/bannerMorangoscortado.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      filterQuality: FilterQuality.high,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GridView.builder(
                        shrinkWrap:
                            true, // Importante para evitar problemas de rolagem
                        physics:
                            NeverScrollableScrollPhysics(), // Impede a rolagem do GridView
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, // Duas colunas por linha
                          mainAxisSpacing:
                              10, // Espaçamento vertical entre os containers
                          crossAxisSpacing:
                              10, // Espaçamento horizontal entre os containers
                        ),
                        itemCount: bolos.length, // Número total de widgets
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              //getCategorias(textBolos[index]);
                              List<String> imagesList = await getCategorias(
                                  textBolos[index], 'images');
                              List<String> nomesList = await getCategorias(
                                  textBolos[index], 'nomes');
                              List<String> valorList = await getCategorias(
                                  textBolos[index], 'valor');
                              //print(nomesList);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListWidgetMobile(
                                      images: imagesList,
                                      nomes: nomesList,
                                      valor: valorList,
                                      image: imageList,
                                    ),
                                  ));
                            },
                            borderRadius: BorderRadius.circular(20),
                            splashColor: Colors.pinkAccent,
                            child: Card(
                              elevation: 10,
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      imageUrls[index],
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      width: MediaQuery.of(context).size.width,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const CircularProgressIndicator();
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(224, 249, 108, 148),
                                          Colors.transparent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 10,
                                      left: 10,
                                      right: 10,
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          bolos[index],
                                          softWrap: true,
                                          style: TextStyle(
                                              fontFamily: 'lobster',
                                              color: Colors.white,
                                              fontSize: 50),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ]);
            }
          }),
    );
  }
}
