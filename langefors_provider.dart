import 'package:flutter/material.dart';

class LangeforsProvider extends ChangeNotifier {
  double delikCapi = 0.0;
  double aci = 0.0;
  double basamakYuksekligi = 0.0;
  double basamakUzunlugu = 0.0;
  double basamakGenisligi = 0.0;
  double dipDelgi = 0.0;
  double delikBoyu = 0.0;
  double pratikDilimKalinligi = 0.0;
  double siralarArasiMesafe = 0.0;
  double delikSayisi = 0.0;
  double siraSayisi = 0.0;
  double sikilamaBoyu = 0.0;
  double yemleyiciMiktari = 0.0;
  double dipSarjKonsantrasyon = 0.0;
  double dipSarjBoyu = 0.0;
  double dipSarjMiktari = 0.0;
  double kolonSarjKonsantrasyon = 0.0;
  double kolonSarjBoyu = 0.0;
  double kolonSarjMiktari = 0.0;
  double toplamSarj = 0.0;
  double ozgulDelme = 0.0;
  double ozgulSarj = 0.0;
  double deliklerArasiGecikmeSon = 0.0;
  double siralarArasiGecikmeSon = 0.0;
  double ortPatYog = 0.0;
  double mesafe = 0.0;

  void setDelikCapi(double value) {
    delikCapi = value;
    notifyListeners();
  }

  void setAci(double value) {
    aci = value;
    notifyListeners();
  }

  void setBasamakYuksekligi(double value) {
    basamakYuksekligi = value;
    notifyListeners();
  }

  void setBasamakUzunlugu(double value) {
    basamakUzunlugu = value;
    notifyListeners();
  }

  void setBasamakGenisligi(double value) {
    basamakGenisligi = value;
    notifyListeners();
  }

  void setDipDelgi(double value) {
    dipDelgi = value;
    notifyListeners();
  }

  void setDelikBoyu(double value) {
    delikBoyu = value;
    notifyListeners();
  }

  void setDilKal(double value) {
    pratikDilimKalinligi = value;
    notifyListeners();
  }

  void setSirAraMes(double value) {
    siralarArasiMesafe = value;
    notifyListeners();
  }

  void setDelikSayisi(double value) {
    delikSayisi = value;
    notifyListeners();
  }

  void setSiraSayisi(double value) {
    siraSayisi = value;
    notifyListeners();
  }

  void setSikilama(double value) {
    sikilamaBoyu = value;
    notifyListeners();
  }

  void setYemleme(double value) {
    yemleyiciMiktari = value;
    notifyListeners();
  }

  void setDipSarjKon(double value) {
    dipSarjKonsantrasyon = value;
    notifyListeners();
  }

  void setDipSarjBoy(double value) {
    dipSarjBoyu = value;
    notifyListeners();
  }

  void setDipSarjMik(double value) {
    dipSarjMiktari = value;
    notifyListeners();
  }

  void setKolonSarjKon(double value) {
    kolonSarjKonsantrasyon = value;
    notifyListeners();
  }

  void setKolonSarjBoy(double value) {
    kolonSarjBoyu = value;
    notifyListeners();
  }

  void setKolonSarjMik(double value) {
    kolonSarjMiktari = value;
    notifyListeners();
  }

  void setToplamSarj(double value) {
    toplamSarj = value;
    notifyListeners();
  }

  void setOzgulDelme(double value) {
    ozgulDelme = value;
    notifyListeners();
  }

  void setOzgulSarj(double value) {
    ozgulSarj = value;
    notifyListeners();
  }

  void setDelGec(double value) {
    deliklerArasiGecikmeSon = value;
    notifyListeners();
  }

  void setSirGec(double value) {
    siralarArasiGecikmeSon = value;
    notifyListeners();
  }

  void setortPatYog(double value) {
    ortPatYog = value;
    notifyListeners();
  }

  void setmesafe(double value) {
    mesafe = value;
    notifyListeners();
  }
}
