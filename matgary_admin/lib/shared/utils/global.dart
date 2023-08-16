import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';



FirebaseAuth fAuth=FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage firestorage = FirebaseStorage.instance;


// UserModel? user;
// User? currentFirebaseUser;


class StripeConfig{
static const String StripePiblishKey='pk_test_51NbR4dEGR9ignEbg7i100vpBaHsrKibDaaXMaU5d0kA5MZ7mhMRJf0iyHthFi0jjCXHGWD5bPbyVvyEBCC9DQQDL00b4HEisDd';
static const String StripeSecKey='sk_test_51NbR4dEGR9ignEbgNA0rTI5gj1N1bfAYxEFXqXZq91mVgzRND6cRJZi7ePSvZnyrVWE1JdIzCSNF64lyrRxv1y9k00lDyUwnCE';
}