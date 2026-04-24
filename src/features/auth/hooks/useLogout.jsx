import { useMutation } from '@tanstack/react-query'
import { logout } from '@api/auth'
import { useAuthStore } from '@store/authStore'
import { useNavigate } from 'react-router-dom'
import { Routes } from '@shared/constant/route-paths'

export const useLogout = () => {
  const logoutStore = useAuthStore((s) => s.logout)
  const navigate = useNavigate()

  return useMutation({
    mutationFn: logout,
    onSettled: () => {
      logoutStore()
      navigate(Routes.Login)
    }
  })
}
