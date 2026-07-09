import { useMutation } from '@tanstack/react-query'
import { completeTraining } from '@api/onboarding'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useCompleteTraining = () => {
  const navigate = useNavigate()
  return useMutation({
    mutationFn: completeTraining,
    onSuccess: () => navigate(Routes.OnboardingPending)
  })
}
