import 'dart:math';
import 'package:flutter/material.dart';
import 'oloffson_hesap.dart';
import 'package:provider/provider.dart';
import 'package:irockblast/providers/langefors_provider.dart';

class OloffsonPage extends StatefulWidget {
  const OloffsonPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OloffsonPageState createState() => _OloffsonPageState();
}

class _OloffsonPageState extends State<OloffsonPage> {
  late TextEditingController _delikCapiController = TextEditingController();
  late TextEditingController _basamakYuksekligiController =
      TextEditingController();
  late TextEditingController _atimUzunluguController = TextEditingController();
  late TextEditingController _atimGenisligiController = TextEditingController();
  late TextEditingController _kolonSarjPatYogController =
      TextEditingController();
  late TextEditingController _dipSarjPatYogController = TextEditingController();
  late TextEditingController _delikIciKapsulController =
      TextEditingController();
  late TextEditingController _yemleyiciMiktariController =
      TextEditingController();
  bool sahaMenuAcik = false;
  bool patlayiciMenuAcik = false;
  bool gecikmeMenuAcik = false;
  String? _selectedSarjTipi = 'Kolon Şarj';

  double delikCapi = 0.0;
  double aci = 90.0;
  double basamakYuksekligi = 0.0;
  double basamakUzunlugu = 0.0;
  double basamakGenisligi = 0.0;
  double r1 = 0.95;
  double r2 = 1.15;
  double delikIciKapsul = 0.0;
  double yemleyiciMiktari = 0.0;
  String yemPatlayiciTipi = 'Emülsiyon Tip';
  String kolonPatlayiciTipi = 'ANFO';
  String dipPatlayiciTipi = 'Emülsiyon Tip';
  double kolSarjPatYog = 0.85;
  double dipSarjPatYog = 1.20;
  double deliklerArasiGecikmeFaktor = 1.95;
  double siralarArasiGecikmeFaktor = 2;
  double bulDeliklerArasiGecikme = 0;
  double bulSiralarArasiGecikme = 0;
  String _selectedEgim = "Dik (90°)";
  String _selectedKayac = 'Zayıf Kayaç';

  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _delikCapiController = TextEditingController();
    _basamakYuksekligiController = TextEditingController();
    _atimUzunluguController = TextEditingController();
    _atimGenisligiController = TextEditingController();
    _kolonSarjPatYogController = TextEditingController();
    _dipSarjPatYogController = TextEditingController();
    _yemleyiciMiktariController = TextEditingController();
    _delikIciKapsulController = TextEditingController();
    _kolonSarjPatYogController.text = kolSarjPatYog.toString();
    _dipSarjPatYogController.text = dipSarjPatYog.toString();
  }

  @override
  void dispose() {
    _delikCapiController.dispose();
    _basamakYuksekligiController.dispose();
    _atimUzunluguController.dispose();
    _atimGenisligiController.dispose();
    _kolonSarjPatYogController.dispose();
    _dipSarjPatYogController.dispose();
    _yemleyiciMiktariController.dispose();
    _delikIciKapsulController.dispose();
    super.dispose();
  }

  final Map<String, Map<String, double>> _egimOptions = {
    "Dik (90°)": {"aci": 90.0, "r1": 0.95},
    "10:1 (84°)": {"aci": 84.0, "r1": 0.96},
    "5:1 (79°)": {"aci": 79.0, "r1": 0.98},
    "3:1 (72°)": {"aci": 72.0, "r1": 1.00},
    "2:1 (63°)": {"aci": 63.0, "r1": 1.03},
    "1:1 (45°)": {"aci": 45.0, "r1": 1.10},
  };

  final Map<String, Map<String, double>> _kayacTuruOptions = {
    'Zayıf Kayaç': {'r2': 1.15},
    'Sağlam Kayaç': {'r2': 1.00},
    'Çok Sağlam Kayaç': {'r2': 0.90}
  };

  final List<String> _yemPatlayiciTipiOptions = [
    'ANFO',
    'Dynamex A',
    'Dynamex M',
    'Emulite 100',
    'Emulite 300',
    'Jelatinit Dinamit',
  ];

  final List<String> _dipPatlayiciTipiOptions = [
    'ANFO',
    'Dynamex A',
    'Dynamex M',
    'Emulite 100',
    'Emulite 300',
    'Jelatinit Dinamit',
  ];

  final List<String> _kolonPatlayiciTipiOptions = [
    'ANFO',
    'Dynamex A',
    'Dynamex M',
    'Emulite 100',
    'Emulite 300',
    'Jelatinit Dinamit',
  ];

  final List<String> _deliklerArasiGecikmeOptions = [
    "Kum, toprak, marn, kömür",
    "Bazı kireçtaşları, kaya tuzu, şeyl",
    "Kompakt kireçtaşı ve mermer",
    "Granit ve bazalt, kuvarsit kaya, gnays ve gabro",
    "Diyabaz, kompakt gnays, mikaşist, manyetit",
  ];

  final List<String> _siralarArasiGecikmeOptions = [
    "Şiddetli hava şoku, geri kırılma vb.",
    "Yüksek yığın, orta hava şoku ve geri kırılma",
    "Ortalama yığın, hava şoku ve geri kırılma",
    "Minimum geri kırılma ve dağınık yığın",
    "Blast casting (iyi yığın?)",
  ];

  void _onEgimChanged(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _selectedEgim = selectedValue;
        aci = _egimOptions[selectedValue]!['aci']!;
        r1 = _egimOptions[selectedValue]!['r1']!;
      });
    }
  }

  void _onKayacTuruChanged(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _selectedKayac = selectedValue;
        r2 = _kayacTuruOptions[selectedValue]!['r2']!;
      });
    }
  }

  void _onYemPatlayiciTipiChanged(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        yemPatlayiciTipi = selectedValue;
      });
    }
  }

  void _onDipPatlayiciTipiChanged(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        if (selectedValue == 'ANFO') {
          dipPatlayiciTipi = selectedValue;
          dipSarjPatYog = 0.85;
        } else if (selectedValue == 'Dynamex A') {
          dipPatlayiciTipi = selectedValue;
          dipSarjPatYog = 1.40;
        } else if (selectedValue == 'Dynamex M') {
          dipPatlayiciTipi = selectedValue;
          dipSarjPatYog = 1.40;
        } else if (selectedValue == 'Emulite 100') {
          dipPatlayiciTipi = selectedValue;
          dipSarjPatYog = 1.20;
        } else if (selectedValue == 'Emulite 300') {
          dipPatlayiciTipi = selectedValue;
          dipSarjPatYog = 1.28;
        } else if (selectedValue == 'Jelatinit Dinamit') {
          dipPatlayiciTipi = selectedValue;
          dipSarjPatYog = 1.35;
        }
      });
      _dipSarjPatYogController.text = dipSarjPatYog.toString();
    }
  }

  void _onKolonPatlayiciTipiChanged(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        if (selectedValue == 'ANFO') {
          kolonPatlayiciTipi = selectedValue;
          kolSarjPatYog = 0.85;
        } else if (selectedValue == 'Dynamex A') {
          kolonPatlayiciTipi = selectedValue;
          kolSarjPatYog = 1.40;
        } else if (selectedValue == 'Dynamex M') {
          kolonPatlayiciTipi = selectedValue;
          kolSarjPatYog = 1.40;
        } else if (selectedValue == 'Emülsiyon Tip') {
          kolonPatlayiciTipi = selectedValue;
          kolSarjPatYog = 1.20;
        } else if (selectedValue == 'Emulite 300') {
          kolonPatlayiciTipi = selectedValue;
          kolSarjPatYog = 1.28;
        } else if (selectedValue == 'Jelatinit Dinamit') {
          kolonPatlayiciTipi = selectedValue;
          kolSarjPatYog = 1.35;
        }
      });
      _kolonSarjPatYogController.text = kolSarjPatYog.toString();
    }
  }

  void _deliklerArasiGecikmeChanged(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        if (selectedValue == 'Kum, toprak, marn, kömür') {
          deliklerArasiGecikmeFaktor = 1.95;
        } else if (selectedValue == 'Bazı kireçtaşları, kaya tuzu, şeyl') {
          deliklerArasiGecikmeFaktor = 1.65;
        } else if (selectedValue == 'Kompakt kireçtaşı ve mermer') {
          deliklerArasiGecikmeFaktor = 1.65;
        } else if (selectedValue ==
            'Granit ve bazalt, kuvarsit kaya, gnays ve gabro') {
          deliklerArasiGecikmeFaktor = 1.35;
        } else if (selectedValue ==
            'Diyabaz, kompakt gnays, mikaşist, manyetit') {
          deliklerArasiGecikmeFaktor = 1.05;
        }
      });
    }
  }

  void _siralarArasiGecikmeChanged(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        if (selectedValue == 'Şiddetli hava şoku, geri kırılma vb.') {
          siralarArasiGecikmeFaktor = 2;
        } else if (selectedValue ==
            'Yüksek yığın, orta hava şoku ve geri kırılma') {
          siralarArasiGecikmeFaktor = 2.5;
        } else if (selectedValue ==
            'Ortalama yığın, hava şoku ve geri kırılma') {
          siralarArasiGecikmeFaktor = 3.5;
        } else if (selectedValue == 'Minimum geri kırılma ve dağınık yığın') {
          siralarArasiGecikmeFaktor = 5;
        } else if (selectedValue == 'Blast casting (iyi yığın?)') {
          siralarArasiGecikmeFaktor = 10.5;
        }
      });
    }
  }

  void _validateInputs() {
    setState(() {
      _errorMessage = null;
      if (_delikCapiController.text.isEmpty ||
          _basamakYuksekligiController.text.isEmpty ||
          _atimUzunluguController.text.isEmpty ||
          _atimGenisligiController.text.isEmpty ||
          _kolonSarjPatYogController.text.isEmpty ||
          _dipSarjPatYogController.text.isEmpty ||
          _yemleyiciMiktariController.text.isEmpty ||
          _delikIciKapsulController.text.isEmpty ||
          double.tryParse(_delikCapiController.text) == null ||
          double.tryParse(_basamakYuksekligiController.text) == null ||
          double.tryParse(_atimUzunluguController.text) == null ||
          double.tryParse(_atimGenisligiController.text) == null ||
          double.tryParse(_kolonSarjPatYogController.text) == null ||
          double.tryParse(_dipSarjPatYogController.text) == null ||
          double.tryParse(_delikCapiController.text)! <= 0 ||
          double.tryParse(_basamakYuksekligiController.text)! <= 0 ||
          double.tryParse(_atimUzunluguController.text)! <= 0 ||
          double.tryParse(_atimGenisligiController.text)! <= 0 ||
          double.tryParse(_kolonSarjPatYogController.text)! <= 0 ||
          double.tryParse(_dipSarjPatYogController.text)! <= 0 ||
          double.tryParse(_yemleyiciMiktariController.text)! <= 0 ||
          double.tryParse(_delikIciKapsulController.text)! <= 0) {
        _errorMessage = 'Lütfen girdiğiniz değerleri kontrol ediniz.';
      }
    });
  }

  void _resetToDefaults() {
    setState(() {
      _delikCapiController.text = '89';
      _basamakYuksekligiController.text = '12';
      _atimUzunluguController.text = '60';
      _atimGenisligiController.text = '15';
      _dipSarjPatYogController.text = '1.2';
      _kolonSarjPatYogController.text = '0.85';
      _yemleyiciMiktariController.text = '0.5';
      _delikIciKapsulController.text = '500';
      _selectedEgim = "Dik (90°)";
      _selectedKayac = 'Zayıf Kayaç';
      _errorMessage = null;
    });
  }

  void clearAllFields() {
    _delikCapiController.clear();
    _basamakYuksekligiController.clear();
    _atimUzunluguController.clear();
    _atimGenisligiController.clear();
    _dipSarjPatYogController.clear();
    _kolonSarjPatYogController.clear();
    _yemleyiciMiktariController.clear();
    _delikIciKapsulController.clear();
    _errorMessage = null;
  }

  void _onCalculatePressed() {
    var langeforsProvider =
        Provider.of<LangeforsProvider>(context, listen: false);
    double delikCapi = double.parse(_delikCapiController.text);
    double basamakYuksekligi = double.parse(_basamakYuksekligiController.text);
    double atimUzunlugu = double.parse(_atimUzunluguController.text);
    double atimGenisligi = double.parse(_atimGenisligiController.text);
    double kolSarjPatYog = double.parse(_kolonSarjPatYogController.text);
    double dipSarjPatYog = double.parse(_dipSarjPatYogController.text);
    double delikIciKapsul = double.parse(_delikIciKapsulController.text);
    double yemleyiciMiktari = double.parse(_yemleyiciMiktariController.text);
    double dipSarjMiktari = 0.0;
    double kolonSarjMiktari = 0.0;
    double kolonSarjBoyu = 0.0;
    double dipSarjBoyu = 0.0;
    double kolonKonsantrasyon = 0;
    double dipKonsantrasyon = 0;

    kolonKonsantrasyon = pi * pow((delikCapi / 2), 2) * kolSarjPatYog / 1000;
    dipKonsantrasyon = pi * pow((delikCapi / 2), 2) * dipSarjPatYog / 1000;

    double maksDilimKalinligi = 0.0;
    if (kolonPatlayiciTipi == 'Jelatinit Dinamit') {
      maksDilimKalinligi = 1.47 * sqrt(kolonKonsantrasyon) * r1 * r2;
    } else if (kolonPatlayiciTipi == 'Emülsiyon Tip') {
      maksDilimKalinligi = 1.45 * sqrt(kolonKonsantrasyon) * r1 * r2;
    } else if (kolonPatlayiciTipi == 'ANFO') {
      maksDilimKalinligi = 1.36 * sqrt(kolonKonsantrasyon) * r1 * r2;
    }
    double dipDelgi = 0.3 * maksDilimKalinligi; //delik taban payı
    double delikBoyu = (1 /
        sin((aci * pi / 180)) *
        (dipDelgi + basamakYuksekligi)); // delik boyu
    double hataPayi = (delikCapi / 1000) + 0.03 * delikBoyu; //delik hata payı
    double dilimKalinligi =
        maksDilimKalinligi - hataPayi; //pratik dilim kalınlığı
    double siralarArasiMesafe0 = dilimKalinligi * 1.25; //delikler arası mesafe
    double siralarAraMesduzeltme = atimGenisligi / siralarArasiMesafe0;
    double siralarArasiMesafe = atimGenisligi / siralarAraMesduzeltme;
    double delikSayisi =
        (atimUzunlugu / siralarArasiMesafe + 1).ceilToDouble(); //delik sayısı
    double siraSayisi =
        (atimGenisligi / dilimKalinligi + 1).ceilToDouble(); //sıra sayısı
    double ozgulDelme = delikBoyu /
        (dilimKalinligi * basamakYuksekligi * siralarArasiMesafe); //özgül delme
    double sikilamaBoyu = dilimKalinligi; //sıkılama boyu

    if (_selectedSarjTipi == 'Kolon Şarj') {
      kolonSarjBoyu = delikBoyu - sikilamaBoyu;
      kolonSarjMiktari = kolonKonsantrasyon * kolonSarjBoyu;
      dipSarjBoyu = 0;
      dipKonsantrasyon = 0;
    } else if (_selectedSarjTipi == 'Kolon + Dip Şarj') {
      dipSarjBoyu = 1.30 * dilimKalinligi;
      dipSarjMiktari = dipSarjBoyu * dipKonsantrasyon;
      kolonSarjBoyu = delikBoyu - (dipSarjBoyu + sikilamaBoyu);
      kolonSarjMiktari = kolonSarjBoyu * kolonKonsantrasyon;
    }

    double toplamSarj =
        dipSarjMiktari + kolonSarjMiktari + yemleyiciMiktari; //şarj miktarı
    double ozgulSarj =
        toplamSarj / (dilimKalinligi * siralarArasiMesafe * basamakYuksekligi);

    double deliklerArasiGecikmeSuresi =
        deliklerArasiGecikmeFaktor * (siralarArasiMesafe * 3.2808399);
    double siralarArasiGecikmeSuresi =
        siralarArasiGecikmeFaktor * (dilimKalinligi * 3.2808399);

    double bulDeliklerArasiGecikme(
        double deliklerArasiGecikmeSuresi, List<double> araliklar) {
      double deliklerArasiGecikmeSon = araliklar.first;
      for (var dGecSon in araliklar) {
        if ((deliklerArasiGecikmeSuresi - dGecSon).abs() <
            (deliklerArasiGecikmeSuresi - deliklerArasiGecikmeSon).abs()) {
          deliklerArasiGecikmeSon = dGecSon;
        }
      }
      return deliklerArasiGecikmeSon;
    }

    double bulSiralarArasiGecikme(
        double siralarArasiGecikmeSuresi, List<double> araliklar) {
      double siralarArasiGecikmeSon = araliklar.first;
      for (var sGecSon in araliklar) {
        if ((siralarArasiGecikmeSuresi - sGecSon).abs() <
            (siralarArasiGecikmeSuresi - siralarArasiGecikmeSon).abs()) {
          siralarArasiGecikmeSon = sGecSon;
        }
      }
      return siralarArasiGecikmeSon;
    }

    List<double> araliklar = [
      0,
      9,
      17,
      25,
      33,
      42,
      50,
      67,
      75,
      100,
      109,
      125,
      150,
      175,
      200,
      225,
      250,
      275,
      300,
      325,
      350
    ];

    double deliklerArasiGecikmeSon =
        bulDeliklerArasiGecikme(deliklerArasiGecikmeSuresi, araliklar);

    double siralarArasiGecikmeSon =
        bulSiralarArasiGecikme(siralarArasiGecikmeSuresi, araliklar);

    double ortPatYog = kolSarjPatYog;

    langeforsProvider.setDelikCapi(delikCapi);
    langeforsProvider.setAci(aci);
    langeforsProvider.setBasamakYuksekligi(basamakYuksekligi);
    langeforsProvider.setBasamakUzunlugu(basamakUzunlugu);
    langeforsProvider.setBasamakGenisligi(basamakGenisligi);
    langeforsProvider.setDipDelgi(dipDelgi);
    langeforsProvider.setDelikBoyu(delikBoyu);
    langeforsProvider.setDilKal(dilimKalinligi);
    langeforsProvider.setSirAraMes(siralarArasiMesafe);
    langeforsProvider.setDelikSayisi(delikSayisi);
    langeforsProvider.setSiraSayisi(siraSayisi);
    langeforsProvider.setSikilama(sikilamaBoyu);
    langeforsProvider.setYemleme(yemleyiciMiktari);
    langeforsProvider.setDipSarjKon(dipKonsantrasyon);
    langeforsProvider.setDipSarjBoy(dipSarjBoyu);
    langeforsProvider.setDipSarjMik(dipSarjMiktari);
    langeforsProvider.setKolonSarjKon(kolonKonsantrasyon);
    langeforsProvider.setKolonSarjBoy(kolonSarjBoyu);
    langeforsProvider.setKolonSarjMik(kolonSarjMiktari);
    langeforsProvider.setToplamSarj(toplamSarj);
    langeforsProvider.setOzgulDelme(ozgulDelme);
    langeforsProvider.setOzgulSarj(ozgulSarj);
    langeforsProvider.setDelGec(deliklerArasiGecikmeSon);
    langeforsProvider.setSirGec(siralarArasiGecikmeSon);
    langeforsProvider.setortPatYog(ortPatYog);
    langeforsProvider.setdelikIci(delikIciKapsul);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OloffsonHesapPage(
          delikCapi: delikCapi,
          aci: aci,
          basamakYuksekligi: basamakYuksekligi,
          atimUzunlugu: atimUzunlugu,
          atimGenisligi: atimGenisligi,
          maksDilimKalinligi: maksDilimKalinligi,
          dipDelgi: dipDelgi,
          delikBoyu: delikBoyu,
          hataPayi: hataPayi,
          dilimKalinligi: dilimKalinligi,
          siralarArasiMesafe: siralarArasiMesafe,
          delikSayisi: delikSayisi,
          siraSayisi: siraSayisi,
          sikilamaBoyu: sikilamaBoyu,
          yemleyiciMiktari: yemleyiciMiktari,
          dipSarjKonsantrasyon: dipKonsantrasyon,
          dipSarjBoyu: dipSarjBoyu,
          dipSarjMiktari: dipSarjMiktari,
          kolonSarjKonsantrasyon: kolonKonsantrasyon,
          kolonSarjBoyu: kolonSarjBoyu,
          kolonSarjMiktari: kolonSarjMiktari,
          toplamSarj: toplamSarj,
          ozgulSarj: ozgulSarj,
          ozgulDelme: ozgulDelme,
          deliklerArasiGecikmeSon: deliklerArasiGecikmeSon,
          siralarArasiGecikmeSon: siralarArasiGecikmeSon,
          delikIciKapsul: delikIciKapsul,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Basamak Patlatması Tasarımı'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ExpansionTile(
                title: const Text('Atım Bilgileri'),
                children: [
                  TextField(
                    controller: _delikCapiController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Delik Çapı',
                      suffixText: 'mm',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedEgim,
                    onChanged: _onEgimChanged,
                    decoration: const InputDecoration(
                      labelText: 'Delik Eğimi',
                    ),
                    items: _egimOptions.keys
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _basamakYuksekligiController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Basamak Yüksekliği',
                      suffixText: 'm',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _atimUzunluguController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Atım Uzunluğu',
                      suffixText: 'm',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _atimGenisligiController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Atım Genişliği',
                      suffixText: 'm',
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedKayac,
                    onChanged: _onKayacTuruChanged,
                    decoration: const InputDecoration(
                      labelText: 'Kayaç Türü',
                    ),
                    items: _kayacTuruOptions.keys
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Patlayıcı Bilgileri'),
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedSarjTipi,
                    onChanged: (selectedSarjTipi) {
                      setState(() {
                        _selectedSarjTipi = selectedSarjTipi;
                        patlayiciMenuAcik = selectedSarjTipi != null;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Patlayıcı Şarj Tipi',
                    ),
                    items: const [
                      DropdownMenuItem<String>(
                        value: 'Kolon Şarj',
                        child: Text('Kolon Şarj'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Kolon + Dip Şarj',
                        child: Text('Kolon + Dip Şarj'),
                      ),
                    ],
                  ),
                  if (patlayiciMenuAcik)
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _yemPatlayiciTipiOptions[5],
                          onChanged: _onYemPatlayiciTipiChanged,
                          decoration: const InputDecoration(
                            labelText: 'Yemleyici Patlayıcı Türü',
                          ),
                          items: _yemPatlayiciTipiOptions
                              .map<DropdownMenuItem<String>>(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _yemleyiciMiktariController,
                          decoration: const InputDecoration(
                            labelText: 'Yemleyici Patlayıcı Miktarı',
                            suffixText: 'kg',
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _delikIciKapsulController,
                          decoration: const InputDecoration(
                            labelText: 'Delik İçi Kapsül Gecikmesi',
                            suffixText: 'ms',
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (_selectedSarjTipi == 'Kolon + Dip Şarj')
                          Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: _dipPatlayiciTipiOptions[2],
                                onChanged: _onDipPatlayiciTipiChanged,
                                decoration: const InputDecoration(
                                  labelText: 'Dip Şarj Patlayıcı Türü',
                                ),
                                items: _dipPatlayiciTipiOptions
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _dipSarjPatYogController,
                                decoration: const InputDecoration(
                                  labelText: 'Dip Şarj Patlayıcı Yoğunluğu',
                                  suffixText: 'g/cm³',
                                ),
                              ),
                              DropdownButtonFormField<String>(
                                value: _kolonPatlayiciTipiOptions[0],
                                onChanged: _onKolonPatlayiciTipiChanged,
                                decoration: const InputDecoration(
                                  labelText: 'Kolon Şarj Patlayıcı Türü',
                                ),
                                items: _kolonPatlayiciTipiOptions
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _kolonSarjPatYogController,
                                decoration: const InputDecoration(
                                  labelText: 'Kolon Şarj Patlayıcı Yoğunluğu',
                                  suffixText: 'g/cm³',
                                ),
                              ),
                            ],
                          ),
                        if (_selectedSarjTipi == 'Kolon Şarj')
                          Column(
                            children: [
                              DropdownButtonFormField<String>(
                                value: _kolonPatlayiciTipiOptions[0],
                                onChanged: _onKolonPatlayiciTipiChanged,
                                decoration: const InputDecoration(
                                  labelText: 'Kolon Şarj Patlayıcı Türü',
                                ),
                                items: _kolonPatlayiciTipiOptions
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _kolonSarjPatYogController,
                                decoration: const InputDecoration(
                                  labelText: 'Kolon Şarj Patlayıcı Yoğunluğu',
                                  suffixText: 'g/cm³',
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text('Gecikme Bilgileri'),
                children: [
                  DropdownButtonFormField<String>(
                      value: _deliklerArasiGecikmeOptions[0],
                      onChanged: _deliklerArasiGecikmeChanged,
                      decoration: const InputDecoration(
                        labelText: 'Deliker Arası Gecikmede Kayaç Faktörü',
                      ),
                      items: _deliklerArasiGecikmeOptions
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList()),
                  DropdownButtonFormField<String>(
                      value: _siralarArasiGecikmeOptions[0],
                      onChanged: _siralarArasiGecikmeChanged,
                      decoration: const InputDecoration(
                        labelText: 'Sıralar Arası Gecikmede İstenen Sonuçlar',
                      ),
                      items: _siralarArasiGecikmeOptions
                          .map<DropdownMenuItem<String>>(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList()),
                ],
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Center(
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _resetToDefaults();
                      },
                      icon: const Icon(Icons.lightbulb),
                      label: const Text('Varsayılan'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        clearAllFields();
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Sil'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _validateInputs();
                    if (_errorMessage == null) {
                      _onCalculatePressed();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Basamak tasarımı başarıyla hesaplandı.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.calculate),
                  label: const Text('Hesapla'),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        )));
  }
}
