import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Persona {
  String? nome;
  String? cognome;

  Persona({this.nome, this.cognome});

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      nome: json['nome'] as String?,
      cognome: json['cognome'] as String?,
    );
  }
}

class PeopleScreen extends StatefulWidget {
  const PeopleScreen({super.key});

  @override
  State<PeopleScreen> createState() => _PeopleScreenState();
}

class _PeopleScreenState extends State<PeopleScreen> {
  List<Persona> personeList = [];
  List<Persona> personeFiltered = [];
  final TextEditingController cognomeController = TextEditingController();
  String? myToken;
  bool isLoading = true;
  String soloFiltro = 'tutti'; // 'tutti', 'nome', 'cognome'

  Future<void> login() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': 'FlutterDev'}),
      );

      print("Login Response Status: ${response.statusCode}");
      print("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        myToken = data['token'];
        print("✅ Token ottenuto con successo: $myToken");
      } else {
        print("❌ Errore login - Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Errore nella login: $e");
    }
  }

  Future<void> getSoloNomi() async {
    // Ottiene tutti i dati delle persone (cognome e nome)
    final url = Uri.parse('http://10.0.2.2:3000/api/persone');

    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $myToken'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List persone = data['data'];
        print("Persone ricevute: ${persone.length}");

        setState(() {
          personeList.clear();
          for (var p in persone) {
            personeList.add(Persona.fromJson(p));
            print("Aggiunto: ${p['nome']} ${p['cognome']}");
          }
          personeFiltered = List.from(personeList);
        });
      } else {
        print("Errore: ${response.statusCode}");
      }
    } catch (e) {
      print("Errore nel fetch persone: $e");
    }
  }

  Future<void> getPersoneByCognome(String cognome) async {
    final url = Uri.http('10.0.2.2:3000', '/api/persone', {'cognome': cognome});

    try {
      final response = await http.get(url, headers: {'Authorization': 'Bearer $myToken'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List persone = data['data'];
        print("Persone trovate per '$cognome': ${persone.length}");

        setState(() {
          personeList.clear();
          for (var p in persone) {
            personeList.add(Persona.fromJson(p));
          }
          _applicaFiltriPersone();
        });
      } else {
        print("Errore: ${response.statusCode}");
      }
    } catch (e) {
      print("Errore nel fetch per cognome: $e");
    }
  }

  void _applicaFiltriPersone() {
    setState(() {
      personeFiltered = personeList.where((persona) {
        if (soloFiltro == 'nome') {
          return persona.nome != null && persona.nome!.isNotEmpty;
        } else if (soloFiltro == 'cognome') {
          return persona.cognome != null && persona.cognome!.isNotEmpty;
        }
        return true;
      }).toList();
    });
  }

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    try {
      await login();
      await getSoloNomi();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Errore durante l'inizializzazione: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    cognomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 13, 107, 88),
        elevation: 8,
        title: const Row(
          children: [
            Icon(Icons.people, color: Color.fromARGB(255, 200, 224, 217), size: 32),
            SizedBox(width: 12),
            Text(
              'Persone',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                color: Color.fromARGB(255, 200, 224, 217),
                fontFamily: 'Roboto'
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 240, 248, 245),
              Color.fromARGB(255, 225, 240, 237),
            ],
          ),
        ),
        child: Column(
          children: [
            // Filtri Persone
            if (personeList.isNotEmpty)
              Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔎 Filtri Persone',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 13, 107, 88),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Filtro "Solo"
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 250, 248),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color.fromARGB(255, 13, 107, 88),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Color.fromARGB(255, 13, 107, 88),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Mostra:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 13, 107, 88),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButton<String>(
                              value: soloFiltro,
                              isExpanded: true,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 'tutti', child: Text('Tutti i dati')),
                                DropdownMenuItem(value: 'nome', child: Text('Solo Nome')),
                                DropdownMenuItem(value: 'cognome', child: Text('Solo Cognome')),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    soloFiltro = value;
                                  });
                                  _applicaFiltriPersone();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // Sezione Persone API
            if (personeFiltered.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 12.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '👥 Risultati (${personeFiltered.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 13, 107, 88),
                    ),
                  ),
                ),
              ),
            if (personeFiltered.isNotEmpty)
              SizedBox(
                height: 140,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => const SizedBox(width: 12),
                  itemCount: personeFiltered.length,
                  itemBuilder: (context, index) {
                    final persona = personeFiltered[index];
                    return Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        width: 160,
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 46, 178, 150),
                              Color.fromARGB(255, 13, 107, 88),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (soloFiltro != 'cognome')
                              Text(
                                persona.nome ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (soloFiltro != 'nome' && soloFiltro != 'cognome')
                              const SizedBox(height: 4),
                            if (soloFiltro != 'nome')
                              Text(
                                persona.cognome ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 200, 224, 217),
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (personeFiltered.isEmpty && personeList.isNotEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 48,
                        color: const Color.fromARGB(255, 13, 107, 88).withOpacity(0.3),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Nessuno risultato corrisponde ai filtri selezionati',
                        style: TextStyle(
                          color: Color.fromARGB(255, 100, 100, 100),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            if (isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 13, 107, 88),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
