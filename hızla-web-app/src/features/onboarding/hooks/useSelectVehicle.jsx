import { useMutation } from '@tanstack/react-query'
import { selectVehicle } from '@api/onboarding'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useSelectVehicle = () => {
  const navigate = useNavigate()
  return useMutation({
    mutationFn: selectVehicle,
    onSuccess: () => navigate(Routes.OnboardingDocuments)
  })
}
