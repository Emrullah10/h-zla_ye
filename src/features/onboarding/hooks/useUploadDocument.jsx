import { useMutation } from '@tanstack/react-query'
import { uploadDocument } from '@api/onboarding'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useUploadDocument = () => {
  const navigate = useNavigate()
  return useMutation({
    mutationFn: ({ type, file }) => uploadDocument(type, file),
    onSuccess: () => navigate(Routes.OnboardingTraining)
  })
}
