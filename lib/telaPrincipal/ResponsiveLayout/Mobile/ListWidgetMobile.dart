import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  void openWhatsApp(String text) async {
    final phoneNumber =
        "+5579996342964"; // Substitua pelo número de telefone do destinatário
    final message =
        'Gostaria de saber de mais informações sobre $text.'; // Substitua pela mensagem que você deseja enviar

    final whatsappUrl =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrlString(whatsappUrl)) {
      await launchUrlString(whatsappUrl);
    } else {
      throw "Não foi possível abrir o WhatsApp";
    }
  }

  Future<void> logicPopulares(
      String nomeVar, String valorVar, String imagesVar) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('especial')
        .doc('Populares')
        .get();
    List<String> listaNomes = List<String>.from(snapshot['nomes']);
    List<String> listaValor = List<String>.from(snapshot['valor']);
    List<String> listaImages = List<String>.from(snapshot['images']);
    if (!listaNomes.contains(nomeVar)) {
      print("entrou");
      List<String> nomesEdit = listaNomes;
      List<String> valorEdit = listaValor;
      List<String> imagesEdit = listaImages;
      //removendo ultimo
      nomesEdit.removeLast();
      valorEdit.removeLast();
      imagesEdit.removeLast();
      print(nomes);

      //adicionando na frente
      nomesEdit.insert(0, nomeVar);
      valorEdit.insert(0, valorVar);
      imagesEdit.insert(0, imagesVar);
      print(nomesEdit);

      //Atualizando banco de dados
      await FirebaseFirestore.instance
          .collection('especial')
          .doc('Populares')
          .update({
        'images': imagesEdit,
        'nomes': nomesEdit,
        'valor': valorEdit,
      });
    }
  }

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
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              sliver: SliverGrid.builder(
                itemCount: nomes.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                      openWhatsApp(nomes[index]);
                      /*await FirebaseFirestore.instance
                          .collection('especial')
                          .doc('Populares')
                          .set({
                        'image':
                            'https://static.wixstatic.com/media/9ec495_ec83a62813424056b8caf0096c46f85b~mv2_d_2658_1772_s_2.jpg/v1/fill/w_663,h_440,al_c,q_80,usm_0.66_1.00_0.01,enc_auto/Bolo%20Simples.jpg',
                        'images': images,
                        'nomes': nomes,
                        'valor': valor,
                      });*/
                      logicPopulares(nomes[index], valor[index], images[index]);
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
                              child: Text(
                                nomes[index],
                                style: TextStyle(
                                    fontFamily: 'lobster',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 50),
                              ),
                            ),
                          ),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                valor[index],
                                style: TextStyle(
                                    fontFamily: 'lobster',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                    fontSize: 30),
                              ),
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
