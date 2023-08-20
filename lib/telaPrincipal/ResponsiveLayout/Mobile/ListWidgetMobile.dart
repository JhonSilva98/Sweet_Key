import 'package:flutter/material.dart';
import 'package:popup_banner/popup_banner.dart';
import '../../../firebase/logicBancodeDados.dart';

class ListWidgetMobile extends StatelessWidget {
  final List<String> nomes;
  final List<String> valor;
  final List<String> images;
  final String image;
  const ListWidgetMobile({
    super.key,
    required this.images,
    required this.nomes,
    required this.valor,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Opacity(
          opacity: 0.1,
          child: Image.asset(
            'assets/bannerMorangoscortadolist.png',
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.pink,
                  child: IconButton(
                    splashColor: Colors.pinkAccent,
                    visualDensity: VisualDensity.comfortable,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white, // Mude a cor do ícone de voltar
                  ),
                ),
              ),
              expandedHeight: 200.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  image,
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/boloiconreserve.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              sliver: SliverGrid.builder(
                itemCount: nomes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Duas colunas por linha
                  mainAxisSpacing:
                      10, // Espaçamento vertical entre os containers
                  crossAxisSpacing:
                      10, // Espaçamento horizontal entre os containers
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.pinkAccent,
                    onTap: () async {
                      BancoDeDados bdFirebaseList = BancoDeDados();

                      PopupBanner(
                        context: context,
                        images: [images[index]],
                        fit: BoxFit.cover,
                        onClick: (index) {
                          debugPrint("CLICKED $index");
                        },
                        customCloseButton: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Icon(Icons.exit_to_app_rounded)),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(40),
                                    splashColor: Colors.pinkAccent,
                                    onTap: () {
                                      bdFirebaseList.openWhatsApp(
                                          nomes[index], "Whatsapp");
                                      bdFirebaseList.logicPopulares(
                                          nomes[index],
                                          valor[index],
                                          images[index]);
                                    },
                                    child: Image.asset(
                                      "assets/whats.png",
                                      height: 100,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(40),
                                    splashColor: Colors.pinkAccent,
                                    onTap: () {
                                      bdFirebaseList.openWhatsApp(
                                          nomes[index], "Instagram");
                                      bdFirebaseList.logicPopulares(
                                          nomes[index],
                                          valor[index],
                                          images[index]);
                                    },
                                    child: Image.asset(
                                      "assets/insta.png",
                                      height: 100,
                                      fit: BoxFit.scaleDown,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).show();
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Raio das bordas arredondadas
                      ),
                      elevation: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                images[index],
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.height,
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
                          ),
                          Flexible(
                            flex: 1,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Text(
                                  nomes[index],
                                  style: const TextStyle(
                                      fontFamily: 'lobster',
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontSize: 50),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 1,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  valor[index],
                                  style: TextStyle(
                                      fontFamily: 'lobster',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                      fontSize: 50),
                                ),
                              ))
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ],
    ));
  }
}
