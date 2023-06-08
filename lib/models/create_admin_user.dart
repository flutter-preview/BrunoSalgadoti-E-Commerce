import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateAdminUser {
  void createAdminUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;


    // Verifica se o usuário administrador já existe
    QuerySnapshot adminQuery = await firestore.collection('admins').limit(1).get();
    if (adminQuery.docs.isEmpty) {
      // Cria o usuário administrador com o UID 'admin'
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: 'bruno@gmail.com',
        password: '1234567',
      );
      String adminUid = userCredential.user!.uid;

      // Cria o documento 'admin' na coleção 'admins' com o ID 'admin'
      await firestore.collection('admins').doc(adminUid).set({
        'user': adminUid,
      });
    }
  }
}
