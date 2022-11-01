import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

Logger logger = Logger();

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

var pageController = PageController();

bool login_status = true;

final DateFormat date_format = DateFormat('dd/MM/yyyy');
var cep_formater = new MaskTextInputFormatter(mask: '#####-###', filter: { "#": RegExp(r'[0-9]') });

var preco_entrega = null;
var tempo_entrega = null;