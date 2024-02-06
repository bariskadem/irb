import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:irockblast/providers/langefors_provider.dart';
import 'package:provider/provider.dart';

class PPVPage extends StatefulWidget {
  const PPVPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PPVPageState createState() => _PPVPageState();
}

class _PPVPageState extends State<PPVPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late TextEditingController _mesafeController;
  late TextEditingController _maksimumParcacikHiziController =
      TextEditingController();
  late TextEditingController _gecikmeBasiSarjController;
  late TextEditingController kController = TextEditingController();
  late TextEditingController betaController = TextEditingController();
  String? selectedil;
  String? selectedilce;
  String? selectedkayacTuru;
  List<String> iller = [];
  List<String> ilceler = [];
  List<String> kayacTurleri = [];
  double? k;
  double? beta;
  double? mesafe;
  double? maksimumParcacikHizi;
  double? gecikmeBasiSarj;
  String? _errorMessage;
  bool _isMaxParticleSpeedFilled = false;
  bool _isMaxChargePerDelayFilled = false;

  @override
  void initState() {
    super.initState();
    fetchiller();
    _mesafeController = TextEditingController();
    _maksimumParcacikHiziController = TextEditingController();
    _gecikmeBasiSarjController = TextEditingController();
    kController = TextEditingController();
    betaController = TextEditingController();
    _gecikmeBasiSarjController = TextEditingController(
        text: Provider.of<LangeforsProvider>(context, listen: false)
            .toplamSarj
            .toStringAsFixed(3));
  }

  @override
  void dispose() {
    _mesafeController.dispose();
    _maksimumParcacikHiziController.dispose();
    _gecikmeBasiSarjController.dispose();
    super.dispose();
  }

  void fetchiller() async {
    QuerySnapshot querySnapshot = await _db.collection('irbppv-a').get();
    setState(() {
      iller =
          querySnapshot.docs.map((doc) => doc['il'] as String).toSet().toList();
    });
  }

  void fetchilceler() async {
    QuerySnapshot querySnapshot = await _db
        .collection('irbppv-a')
        .where('il', isEqualTo: selectedil)
        .get();
    setState(() {
      ilceler = querySnapshot.docs
          .map((doc) => doc['ilce'] as String)
          .toSet()
          .toList();
      selectedilce = null;
      fetchkayacTuru();
    });
  }

  void fetchkayacTuru() async {
    QuerySnapshot querySnapshot = await _db
        .collection('irbppv-a')
        .where('ilce', isEqualTo: selectedilce)
        .get();
    setState(() {
      kayacTurleri =
          querySnapshot.docs.map((doc) => doc['kayacTuru'] as String).toList();
      selectedkayacTuru = null;
      fetchKAndBetaValues();
    });
  }

  void fetchKAndBetaValues() async {
    if (selectedil != null &&
        selectedilce != null &&
        selectedkayacTuru != null) {
      QuerySnapshot querySnapshot = await _db
          .collection('irbppv-a')
          .where('il', isEqualTo: selectedil)
          .where('ilce', isEqualTo: selectedilce)
          .where('kayacTuru', isEqualTo: selectedkayacTuru)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          k = (querySnapshot.docs.first['k'] as num).toDouble();
          beta = (querySnapshot.docs.first['beta'] as num).toDouble();

          kController.text = k.toString();
          betaController.text = beta.toString();
        });
      } else {
        setState(() {
          kController.text = '';
          betaController.text = '';
        });
      }
    } else {
      setState(() {
        kController.text = '';
        betaController.text = '';
      });
    }
  }

  void _validateInputs() {
    setState(() {
      _errorMessage = null;
      double? maksimumParcacikHiziValue =
          double.tryParse(_maksimumParcacikHiziController.text);
      double? gecikmeBasiSarjValue =
          double.tryParse(_gecikmeBasiSarjController.text);

      // Eğer kullanıcı maksimum parçacık hızı değeri girdiyse ve gecikme başı maksimum şarjı hesaplanacaksa
      if (_isMaxParticleSpeedFilled && maksimumParcacikHiziValue != null) {
        // Gecikme başı maksimum şarjı hesapla
        calculateGecikmeBasiSarj();
        // Sonucu gecikme başı maksimum şarj controller'ına yaz
        _gecikmeBasiSarjController.text =
            gecikmeBasiSarj?.toStringAsFixed(3) ?? '';
      }

      // Eğer kullanıcı gecikme başı maksimum şarj değeri girdiyse ve maksimum parçacık hızı hesaplanacaksa
      if (_isMaxChargePerDelayFilled && gecikmeBasiSarjValue != null) {
        // Maksimum parçacık hızını hesapla
        calculatePPV();
        // Sonucu maksimum parçacık hızı controller'ına yaz
        _maksimumParcacikHiziController.text =
            maksimumParcacikHizi?.toStringAsFixed(3) ?? '';
      }

      // Diğer girişlerin doğruluğunu kontrol et
      if (maksimumParcacikHiziValue == null && gecikmeBasiSarjValue == null) {
        _errorMessage = 'Lütfen girdiğiniz değerleri kontrol ediniz.';
        return;
      }

      if (maksimumParcacikHiziValue != null && maksimumParcacikHiziValue <= 0) {
        _errorMessage = 'Lütfen girdiğiniz değerleri kontrol ediniz.';
        return;
      }

      if (gecikmeBasiSarjValue != null && gecikmeBasiSarjValue <= 0) {
        _errorMessage = 'Lütfen girdiğiniz değerleri kontrol ediniz.';
        return;
      }

      if (_mesafeController.text.isEmpty ||
          betaController.text.isEmpty ||
          kController.text.isEmpty ||
          double.tryParse(_mesafeController.text) == null ||
          double.tryParse(betaController.text)! <= 0 ||
          double.tryParse(kController.text)! <= 0) {
        _errorMessage = 'Lütfen girdiğiniz değerleri kontrol ediniz.';
      }
    });
  }

  void _onDefaultPressed() {
    setState(() {
      _mesafeController.text = '100';
      betaController.text = '1.6';
      kController.text = '1730';
      selectedil = null;
      selectedilce = null;
      selectedkayacTuru = null;
      maksimumParcacikHizi = null;
      gecikmeBasiSarj = null;
      _errorMessage = null;
    });
  }

  void _onClearPressed() {
    setState(() {
      _mesafeController.clear();
      _maksimumParcacikHiziController.clear();
      _gecikmeBasiSarjController.clear();
      betaController.clear();
      kController.clear();
      selectedil = null;
      selectedilce = null;
      selectedkayacTuru = null;
      _isMaxParticleSpeedFilled = false;
      _isMaxChargePerDelayFilled = false;
      maksimumParcacikHizi = null;
      gecikmeBasiSarj = null;
      _errorMessage = null;
    });
  }

  void calculateGecikmeBasiSarj() {
    var langeforsProvider =
        Provider.of<LangeforsProvider>(context, listen: false);
    double mesafe = double.tryParse(_mesafeController.text) ?? 0.0;
    double maksimumParcacikHizi =
        double.tryParse(_maksimumParcacikHiziController.text) ?? 0.0;

    double kParsed = double.tryParse(kController.text) ?? 0.0;
    double betaParsed = double.tryParse(betaController.text) ?? 0.0;
    langeforsProvider.setmesafe(mesafe);
    if (kParsed != 0.0 && betaParsed != 0.0) {
      setState(() {
        k = kParsed;
        beta = betaParsed;
        gecikmeBasiSarj =
            pow((mesafe / pow((maksimumParcacikHizi / k!), (1 / -(beta!)))), 2)
                as double?;
      });
    } else {
      setState(() {});
    }
  }

  void calculatePPV() {
    var langeforsProvider =
        Provider.of<LangeforsProvider>(context, listen: false);
    double mesafe = double.tryParse(_mesafeController.text) ?? 0.0;
    double gecikmeBasiSarj =
        double.tryParse(_gecikmeBasiSarjController.text) ?? 0.0;

    double kParsed = double.tryParse(kController.text) ?? 0.0;
    double betaParsed = double.tryParse(betaController.text) ?? 0.0;
    langeforsProvider.setmesafe(mesafe);
    if (kParsed != 0.0 && betaParsed != 0.0) {
      setState(() {
        k = kParsed;
        beta = betaParsed;
        maksimumParcacikHizi =
            k! * pow((mesafe / sqrt(gecikmeBasiSarj)), -beta!);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gecikme Başı Maksimum Şarj Hesabı'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _maksimumParcacikHiziController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Maksimum Parçacık Hızı',
                suffixText: 'mm/sn',
              ),
              onChanged: (value) {
                setState(() {
                  _isMaxParticleSpeedFilled = value.isNotEmpty;
                  if (_isMaxParticleSpeedFilled) {
                    _isMaxChargePerDelayFilled = false;
                    _gecikmeBasiSarjController.clear();
                  }
                });
              },
              enabled: !_isMaxChargePerDelayFilled,
            ),
            TextFormField(
              controller: _gecikmeBasiSarjController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Gecikme Başına Maksimum Şarj',
                suffixText: 'kg',
              ),
              onChanged: (value) {
                setState(() {
                  _isMaxChargePerDelayFilled = value.isNotEmpty;
                  if (_isMaxChargePerDelayFilled) {
                    _isMaxParticleSpeedFilled = false;
                    _maksimumParcacikHiziController.clear();
                  }
                });
              },
              enabled: !_isMaxParticleSpeedFilled,
            ),
            TextFormField(
              controller: _mesafeController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Mesafe',
                suffixText: 'm',
              ),
            ),
            const SizedBox(height: 16),
            const Text("İl", style: TextStyle(fontSize: 16)),
            DropdownButton<String?>(
              items: iller.map((il) {
                return DropdownMenuItem<String?>(
                  value: il,
                  child: Text(il),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedil = newValue;
                  fetchilceler();
                });
              },
              value: selectedil,
              isExpanded: true,
            ),
            const SizedBox(height: 16),
            const Text("İlçe", style: TextStyle(fontSize: 16)),
            DropdownButton<String?>(
              items: ilceler.map((ilce) {
                return DropdownMenuItem<String?>(
                  value: ilce,
                  child: Text(ilce),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedilce = newValue;
                  fetchkayacTuru();
                });
              },
              value: selectedilce,
              isExpanded: true,
            ),
            const SizedBox(height: 16),
            const Text("Kayaç Türü", style: TextStyle(fontSize: 16)),
            DropdownButton<String?>(
              items: kayacTurleri.map((kayacTuru) {
                return DropdownMenuItem<String?>(
                  value: kayacTuru,
                  child: Text(kayacTuru),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedkayacTuru = newValue;
                  fetchKAndBetaValues();
                });
              },
              value: selectedkayacTuru,
              isExpanded: true,
            ),
            TextField(
              controller: kController,
              onChanged: (String? newValue) {
                setState(() {
                  k = double.tryParse(newValue!);
                });
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Saha İletim Katsayısı",
              ),
            ),
            TextField(
              controller: betaController,
              onChanged: (String? newValue) {
                setState(() {
                  beta = double.tryParse(newValue!);
                });
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Saha Jeolojik Sabiti",
              ),
            ),
            const SizedBox(height: 16),
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
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _onDefaultPressed,
                    icon: const Icon(Icons.lightbulb),
                    label: const Text('Varsayılan'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _onClearPressed,
                    icon: const Icon(Icons.delete),
                    label: const Text('Sil'),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _validateInputs();
                  if (_isMaxParticleSpeedFilled && _errorMessage == null) {
                    calculateGecikmeBasiSarj();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gecikme Başı Şarj Miktarı Hesaplandı.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (_isMaxChargePerDelayFilled &&
                      _errorMessage == null) {
                    calculatePPV();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Maksimum Parçacık Hızı Hesaplandı.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.calculate),
                label: const Text('Hesapla'),
              ),
            ),
            const SizedBox(height: 16),
            if (gecikmeBasiSarj != null && maksimumParcacikHizi != null)
              Center(
                child: Text(
                  _isMaxParticleSpeedFilled
                      ? 'Gecikme Başı Maksimum Şarj Miktarı: ${gecikmeBasiSarj?.toStringAsFixed(3)} kg'
                      : (_isMaxChargePerDelayFilled
                          ? 'Maksimum Parçacık Hızı: ${maksimumParcacikHizi?.toStringAsFixed(3)} mm/sn'
                          : 'Gecikme Başı Maksimum Şarj Miktarı: ${gecikmeBasiSarj?.toStringAsFixed(3)} kg\nMaksimum Parçacık Hızı: ${maksimumParcacikHizi?.toStringAsFixed(3)} mm/sn'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
