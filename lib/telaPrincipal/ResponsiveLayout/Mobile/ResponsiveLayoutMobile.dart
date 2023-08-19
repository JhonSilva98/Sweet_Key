import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sweets_key/telaPrincipal/ResponsiveLayout/Mobile/ListWidgetMobile.dart';

import '../../../firebase/logicBancodeDados.dart';

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

  BancoDeDados bdFirebase = BancoDeDados();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        scrolledUnderElevation: 5,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "Sweets",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'lobster',
                    color: Colors.black),
              ),
            ),
            const SizedBox(width: 8.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/key going into the strawberryCUT.png",
                fit: BoxFit.contain,
                height: 50,
                width: 50,
              ),
            ),
            const SizedBox(width: 8.0),
            const FittedBox(
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
        actions: const [
          //IconButton(onPressed: (){}, icon: Icon(icon))
        ],
      ),
      body: FutureBuilder(
          future: bdFirebase.getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar os dados'));
            } else {
              imageUrls = bdFirebase.imageUrls;
              textBolos = bdFirebase.textBolos;
              textotest = bdFirebase.textotest;
              imageList = bdFirebase.imageList;
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
                        autoPlayInterval: const Duration(seconds: 5),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: const BoxDecoration(
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
                            child: FittedBox(
                              fit: BoxFit.contain,
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
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              backgroundColor: const Color(0XFFfb4a7a),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            onPressed: () async {
                              List<String> imagesList =
                                  await bdFirebase.getPopulares('images');
                              List<String> nomesList =
                                  await bdFirebase.getPopulares('nomes');
                              List<String> valorList =
                                  await bdFirebase.getPopulares('valor');
                              imageList = bdFirebase.imageList;
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
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
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
                            const NeverScrollableScrollPhysics(), // Impede a rolagem do GridView
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                              List<String> imagesList = await bdFirebase
                                  .getCategorias(textBolos[index], 'images');
                              List<String> nomesList = await bdFirebase
                                  .getCategorias(textBolos[index], 'nomes');
                              List<String> valorList = await bdFirebase
                                  .getCategorias(textBolos[index], 'valor');
                              imageList = bdFirebase.imageList;
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
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const CircularProgressIndicator();
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(Icons.error);
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
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
                                          style: const TextStyle(
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
