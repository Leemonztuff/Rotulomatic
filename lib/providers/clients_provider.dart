import 'package:flutter/material.dart';
import '../models/client.dart';

class ClientsProvider with ChangeNotifier {
  final List<Client> _clients = [];

  List<Client> get clients => _clients;

  void addClient(Client client) {
    _clients.add(client);
    notifyListeners();
  }

  void updateClient(Client client) {
    int index = _clients.indexWhere((c) => c.id == client.id);
    if (index != -1) {
      _clients[index] = client;
      notifyListeners();
    }
  }

  void removeClient(String id) {
    _clients.removeWhere((client) => client.id == id);
    notifyListeners();
  }
}
