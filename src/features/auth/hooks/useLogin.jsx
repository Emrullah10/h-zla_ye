import { useMutation } from '@tanstack/react-query'
import { login } from '@api/auth'
import { useAuthStore } from '@store/authStore'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useLogin = () => {
  const setUser = useAuthStore((s) => s.setUser)
  const navigate = useNavigate()

  return useMutation({
    mutationFn: login,
    onSuccess: ({ data }) => {
      setUser({
        driver: data.driver,
        role: data.role,
        onboardingStatus: data.onboardingStatus,
        userPermissionList: data.userPermissionList ?? [],
      })
      if (data.role === 'admin') {
        navigate(Routes.Admin)
      } else if (data.onboardingStatus?.toLowerCase() !== 'approved') {
        navigate(Routes.OnboardingVehicle)
      } else {
        navigate(Routes.Dashboard)
      }
    },
  })
}
