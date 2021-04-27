import 'dart:developer';

import 'package:flutter_command/flutter_command.dart';
import 'package:get_it/get_it.dart';
import 'package:reactive_way/model.dart';
import 'package:reactive_way/service.dart';

class Manager {
  Command<String, List<Articles>>? loadData;

  Manager() {
    loadData = Command.createAsync<String, List<Articles>>(
        (countryCode) => GetIt.I<Service>().getData(countryCode), []);
  }
}