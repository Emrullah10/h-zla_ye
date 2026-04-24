import { useMutation } from '@tanstack/react-query'
import { login } from '@api/auth'
import { useAuthStore } from '@store/authStore'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useLogin = () => {
  const setToken = useAuthStore((s) => s.setToken)
  const setDriver = useAuthStore((s) => s.setDriver)
  const setOnboardingStatus = useAuthStore((s) => s.setOnboardingStatus)
  const navigate = useNavigate()

  return useMutation({
    mutationFn: login,
    onSuccess: ({ data }) => {
      setToken(data.token, data.expiresIn, data.refreshToken)
      setDriver(data.driver)
      setOnboardingStatus(data.onboardingStatus)
      if (data.onboardingStatus !== 'APPROVED') {
        navigate(Routes.OnboardingVehicle)
      } else {
        navigate(Routes.Dashboard)
      }
    }
  })
}
