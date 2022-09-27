import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class LocaleEntity extends Equatable {
  final Locale locale;
  const LocaleEntity({required this.locale});

  @override
  List<Object?> get props => [locale];
}
