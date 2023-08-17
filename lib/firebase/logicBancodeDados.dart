import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher_string.dart';

class BancoDeDados {
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
    for (var element in snapshot.docs) {
      textBolos.add(element.id);
      //print(element.id);
    }
    for (String i in textBolos) {
      imageUrls.add(await getImagePerfil(i));
    }
    await getPopulares('images');
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

  void openWhatsApp(String text, String tipo) async {
    if (tipo == "Whatsapp") {
      const phoneNumber =
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
    } else {
      const instagram =
          "https://instagram.com/sweetskey_?igshid=MzRlODBiNWFlZA==";
      if (await canLaunchUrlString(instagram)) {
        await launchUrlString(instagram);
      } else {
        throw "Não foi possível abrir o WhatsApp";
      }
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
      List<String> nomesEdit = listaNomes;
      List<String> valorEdit = listaValor;
      List<String> imagesEdit = listaImages;
      //removendo ultimo
      nomesEdit.removeLast();
      valorEdit.removeLast();
      imagesEdit.removeLast();

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
}
