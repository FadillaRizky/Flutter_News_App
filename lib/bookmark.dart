import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_news_app/login.dart';

class Bookmark {
  static void insert(BuildContext context,Map<dynamic,dynamic> berita) async {
    try {
      // UI Loading
      var user = FirebaseAuth.instance.currentUser;
      // Insert data lembur ke Firebase Database
      await FirebaseDatabase.instance
          .ref()
          .child("bookmarks")
          .child(user!.uid)
          .child(berita['title'])
          .set({
            "author":berita['author'],
            "image_url":berita['image_url'],
            "article_url":berita['article_url'],
          })
          .whenComplete(() {
        // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
        EasyLoading.showSuccess('Bookmarks telah di tambahkan',
            dismissOnTap: true, duration: const Duration(seconds: 5));
        return;
      }).onError((error, stackTrace) {
        EasyLoading.showError("Ada Sesuatu Kesalahan: $error",
            dismissOnTap: true, duration: const Duration(seconds: 5));
      });
    } on Exception catch (e) {
      // Menampilkan error yang terjadi pada block code di atas
      EasyLoading.showError('Ada Sesuatu Kesalahan : $e',
          dismissOnTap: true, duration: const Duration(seconds: 5));
    }
  }
  static void update(BuildContext context,Map<dynamic,dynamic> berita) async {
    try {
      // UI Loading
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          EasyLoading.showError("Anda Perlu Login lagi!",
            dismissOnTap: true, duration: const Duration(seconds: 5));
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => LoginPage()));
        });
      }
      // Insert data lembur ke Firebase Database
      FirebaseDatabase.instance
          .ref()
          .child("bookmarks")
          .child(user!.uid)
          .child(berita['id'])
          .push()
          .set({
            "nama":berita['nama'],
            "author":berita['author'],
            "image_url":berita['image_url'],
            "article_url":berita['article_url'],
          })
          .whenComplete(() {
        // Menampilkan alert berhasil jika codingan di atas berhasil dan selesai
        EasyLoading.showSuccess('Bookmarks telah di tambahkan',
            dismissOnTap: true, duration: const Duration(seconds: 5));
        return;
      }).onError((error, stackTrace) {
        EasyLoading.showError("Ada Sesuatu Kesalahan: $error",
            dismissOnTap: true, duration: const Duration(seconds: 5));
      });
    } on Exception catch (e) {
      // Menampilkan error yang terjadi pada block code di atas
      EasyLoading.showError('Ada Sesuatu Kesalahan : $e',
          dismissOnTap: true, duration: const Duration(seconds: 5));
    }
  }
}
