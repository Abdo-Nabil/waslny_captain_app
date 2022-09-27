import 'package:dartz/dartz.dart';
import 'package:waslny_captain/core/error/failures.dart';
import 'package:waslny_captain/features/localization/domain/entities/local_entity.dart';
import 'package:waslny_captain/features/localization/domain/repositories/localization_repository.dart';

import '../../../../core/usecases/usecase.dart';

class SetToSystemLocaleUseCase implements UseCase<LocaleEntity, NoParams> {
  final LocalizationRepository localizationRepository;
  SetToSystemLocaleUseCase({required this.localizationRepository});

  @override
  Future<Either<Failure, LocaleEntity>> call(NoParams params) async {
    return await localizationRepository.setToSystemLocale();
  }
}
