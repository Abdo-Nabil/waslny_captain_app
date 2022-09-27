import 'package:dartz/dartz.dart';
import 'package:waslny_captain/core/error/failures.dart';
import 'package:waslny_captain/features/localization/data/models/locale_model.dart';
import 'package:waslny_captain/features/localization/domain/entities/local_entity.dart';
import 'package:waslny_captain/features/localization/domain/repositories/localization_repository.dart';

import '../../../../core/error/exceptions.dart';
import '../datasources/localization_local_data_source.dart';

class LocalizationRepositoryImpl implements LocalizationRepository {
  final LocalizationLocalDataSource localizationLocalDataSource;
  const LocalizationRepositoryImpl({required this.localizationLocalDataSource});

  @override
  Either<Failure, LocaleEntity> getLocale() {
    final result = localizationLocalDataSource.getLocale();
    return Right(result);
  }

  @override
  Future<Either<Failure, Unit>> setLocale(LocaleEntity localeEntity) async {
    try {
      final result = await localizationLocalDataSource
          .setLocale(LocaleModel(locale: localeEntity.locale));
      return Right(result);
    } on CacheSavingException {
      return Left(CacheSavingFailure());
    }
  }

  @override
  Future<Either<Failure, LocaleEntity>> setToSystemLocale() async {
    try {
      final result = await localizationLocalDataSource.setToSystemLocale();
      return Right(LocaleEntity(locale: result.locale));
    } on CacheSavingException {
      return Left(CacheSavingFailure());
    }
  }
}
