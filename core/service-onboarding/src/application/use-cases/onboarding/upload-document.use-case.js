import { OnboardingErrors } from '../../../domain/onboarding/onboarding.errors.js';

const VALID_DOC_TYPES = ['id_front', 'id_back', 'license_front', 'license_back', 'vehicle_registration'];

export default function createUploadDocumentUseCase({ applicationRepository, documentRepository }) {
  return async function uploadDocument({ userId, docType, filePath }) {
    if (!VALID_DOC_TYPES.includes(docType)) throw OnboardingErrors.INVALID_DOCUMENT_TYPE();

    const app = await applicationRepository.findByUserId(userId);
    if (!app) throw OnboardingErrors.APPLICATION_NOT_FOUND();

    return documentRepository.create({ appId: app.appId, type: docType, filePath, status: 'pending' });
  };
}
