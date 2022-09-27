import 'package:dartz/dartz.dart';
import 'package:waslny_captain/core/error/failures.dart';
import 'package:waslny_captain/features/localization/domain/repositories/localization_repository.dart';

import '../../../../core/usecases/usecase.dart';
import '../entities/local_entity.dart';

class SetLocaleUseCase implements UseCase<Unit, LocaleEntity> {
  final LocalizationRepository localizationRepository;
  SetLocaleUseCase({required this.localizationRepository});

  @override
  Future<Either<Failure, Unit>> call(LocaleEntity localeEntity) async {
    return await localizationRepository.setLocale(localeEntity);
  }
}
