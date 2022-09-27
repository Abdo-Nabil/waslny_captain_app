import 'package:dartz/dartz.dart';
import 'package:waslny_captain/core/error/failures.dart';
import 'package:waslny_captain/core/usecases/usecase.dart';
import 'package:waslny_captain/features/localization/domain/repositories/localization_repository.dart';

import '../entities/local_entity.dart';

class GetLocaleUseCase {
  final LocalizationRepository localizationRepository;
  GetLocaleUseCase({required this.localizationRepository});

  Either<Failure, LocaleEntity> call(NoParams noParams) {
    return localizationRepository.getLocale();
  }
}
