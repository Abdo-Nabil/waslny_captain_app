import 'package:dartz/dartz.dart';
import 'package:waslny_captain/features/localization/domain/entities/local_entity.dart';

import '../../../../core/error/failures.dart';

abstract class LocalizationRepository {
  Either<Failure, LocaleEntity> getLocale();
  Future<Either<Failure, LocaleEntity>> setToSystemLocale();
  Future<Either<Failure, Unit>> setLocale(LocaleEntity localeEntity);
}
