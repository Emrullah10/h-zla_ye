import datasources from '@hizla/datasource/index.js';
import {
  ApplicationRepositoryImpl,
  DocumentRepositoryImpl,
  TrainingRepositoryImpl,
} from '#core/infrastructure/persistence/repositories/onboarding.repository-impl.js';
import createGetStatusUseCase from '#core/application/use-cases/onboarding/get-status.use-case.js';
import createSelectVehicleUseCase from '#core/application/use-cases/onboarding/select-vehicle.use-case.js';
import createUploadDocumentUseCase from '#core/application/use-cases/onboarding/upload-document.use-case.js';
import createCompleteTrainingUseCase from '#core/application/use-cases/onboarding/complete-training.use-case.js';

export const buildContainer = () => {
  const db = datasources.coreAppDb;

  const applicationRepository = new ApplicationRepositoryImpl(db);
  const documentRepository = new DocumentRepositoryImpl(db);
  const trainingRepository = new TrainingRepositoryImpl(db);

  return {
    getStatus: createGetStatusUseCase({ applicationRepository, documentRepository, trainingRepository }),
    selectVehicle: createSelectVehicleUseCase({ applicationRepository }),
    uploadDocument: createUploadDocumentUseCase({ applicationRepository, documentRepository }),
    completeTraining: createCompleteTrainingUseCase({ applicationRepository, trainingRepository }),
  };
};
